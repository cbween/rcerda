# frozen_string_literal: true

require 'optparse'
require 'semantic_logger'

module EdrAgentTester
  class EdrAgentTester
    attr_accessor :extra

    include SemanticLogger::Loggable

    class EdrAgentTesterFailure < StandardError
      attr_reader :options

      def initialize(message, opt_parser = nil)
        super(message)
        @options = opt_parser
      end
    end

    def initialize(args = {})
      if Hash === args && args.empty? == false
        args.each do |k,v|
          instance_variable_set("@#{k}", v.to_s) if v
        end
      else
        @extra = options.parse(args)
      end
    rescue OptionParser::ParseError => e
      raise EdrAgentTesterFailure.new(e.message, options.to_s)
    end

    def run
      extra = options.order!
      command = extra.shift

      if command.nil?
        puts options
      elsif commands.values.include?(command) == false
        puts "Unrecognized command: #{command}"
        puts options
      else
        SemanticLogger.tagged(system_username: Etc.getpwuid(Process.uid).name, process: $PROGRAM_NAME, command_given: ([command] + extra)) do
          command_class = commands.find { |_k, c| c == command }.first
          command_handle = command_class.new(extra)

          logger.info "Initialize #{command_handle.log_name}", command_handle.log_payload
          logger.measure_info(message: "Completed #{command_handle.log_name}", payload: command_handle.log_payload) do
            command_handle.run
          rescue StandardError => e
            logger.error(e.message, error: e)
            raise EdrAgentTesterFailure.new(e.message, command_handle.options.to_s)
          end
        end
      end
    end

    def commands
      @commands ||= {}
      EdrAgentTester.subclasses.each { |k| @commands[k] = k.send 'command' } if @commands.empty?
      @commands
    end

    def options
      OptionParser.new do |parser|
        parser.banner = "Usage: #{script_name} [#{commands.values.join('|')}] [options]"
        parser.separator("use '#{script_name} <command> -h' to see detailed command options")
        parser
      end
    end

    def script_name
      File.basename($PROGRAM_NAME)
    end
  end
end
