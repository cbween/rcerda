# frozen_string_literal: true

require_relative "cbween_edr_agent/version"
require 'optparse'
require 'semantic_logger'

module CbweenEdrAgent
  class EdrAgent
    attr_accessor :extra

    include SemanticLogger::Loggable
  
    class EdrAgentFailure < StandardError
      attr_reader :options
      def initialize(message, opt_parser = nil)
        super(message)
        @options = opt_parser
      end
    end
    
    def initialize(args)
      if Hash === args
        args.each do |k,v|
          instance_variable_set("@#{k}", v.to_s) if v
        end
      else
        @options = options do |opts|
          # TODO Can use Trailing?
          opts.on('-h', 'Show this help') { raise EdrAgentFailure, opts.to_s }
          # TODO: Provide Help
        end

        @extra = @options.parse(args)
      end
    rescue OptionParser::ParseError => e
      raise EdrAgentFailure.new(e.message, @options)
    end

    @commands = []
    def self.inherited(subclass)
      @commands << subclass
    end
    
    def self.agents
      Dir[File.expand_path(File.join(File.dirname(__FILE__), 'cbween_edr_agent/agents', '*.rb'))]
    end

    def self.run
      SemanticLogger.tagged(system_username: Etc.getpwuid(Process.uid).name, process: $0) do
        require_agents
        @command_names = @commands.map { |c| c.command }
        extra = []

        options = ARGV.options do |opts|
          script_name = File.basename($0)
          opts.banner = "Usage: #{script_name} [ #{@command_names.join(' | ')} ] [options]"
          opts.separator("use '#{script_name} <command> -h' to see detailed command options")
          opts
        end

        extra = options.order!
        command = extra.shift

        if command.nil?
          STDERR.puts options
        elsif !@command_names.include?(command)
          STDERR.puts "Unrecognized command: #{command}"
          STDERR.puts options
        else
          command_class = @commands.find { |c| c.command == command }
          command_class.new(extra).run
        end
      end
    rescue OptionParser::InvalidOption => e
      logger.error(e.message, error: e)
      raise EdrAgentFailure, e.message
    end

    private

    def self.require_agents
      agents.each { |agent| require agent unless agent.nil? }
    end
  end
end
