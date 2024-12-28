# frozen_string_literal: true

require_relative "cbween_edr_agent/version"
require 'optparse'
require 'semantic_logger'

module CbweenEdrAgent
  class EdrAgent
    attr_accessor :extra, :script_name

    include SemanticLogger::Loggable
  
    class EdrAgentFailure < StandardError
      attr_reader :options
      def initialize(message, opt_parser = nil)
        super(message)
        @options = opt_parser
      end
    end
    
    def initialize(args = {})
      if Hash === args
        args.each do |k,v|
          instance_variable_set("@#{k}", v.to_s) if v
        end
      else
        @options = options do |opts|
          opts.on('-h', 'Show this help') { raise EdrAgentFailure, opts.to_s }
        end
        @extra = @options.parse(args)      
      end
    rescue OptionParser::ParseError => e
      raise EdrAgentFailure.new(e.message, options.to_s)
    end

    def run
      SemanticLogger.tagged(system_username: Etc.getpwuid(Process.uid).name, process: $0) do
        @commands = {}
        EdrAgent.subclasses.each{ |k| @commands[k] = k.send 'command' }
        extra = []

        options = ARGV.options do |opts|
          opts.banner = "Usage: #{script_name} [#{@commands.values.join('|')}] [options]"
          opts.separator("use '#{script_name} <command> -h' to see detailed command options")
          opts
        end

        extra = options.order!
        command = extra.shift

        if command.nil?
          puts options
        elsif false == @commands.values.include?(command)
          puts "Unrecognized command: #{command}"
          puts options
        else
          @error = {}
          command_class = @commands.find { |k,c| c == command }.first
          command_handle = command_class.new(extra)

          logger.info "Initialize #{command_handle.log_name}", command_handle.log_payload
          logger.measure_info(message: "Completed #{command_handle.log_name}", payload: command_handle.log_payload, error: @error) do
            begin
              command_handle.run
            rescue => e
              @error = e
              logger.error(e.message, error: e)
              raise EdrAgentFailure.new(e.message, command_handle.options.to_s)
            end
          end

        end
      end
    end

    def script_name
      File.basename($0)
    end
  end
end
