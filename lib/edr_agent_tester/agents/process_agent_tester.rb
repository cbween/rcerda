# frozen_string_literal: true

module EdrAgentTester
  class ProcessAgentTester < EdrAgentTester
    attr_accessor :host, :port

    def self.command = 'process'

    def initialize(args = {})
      super args
    end

    def run
      pid = Process.spawn "#{@name} #{@process_args}"
      Process.waitpid(pid)
    rescue StandardError => e
      logger.error("Failed #{log_name}", log_payload, e)
      raise EdrAgentTesterFailure.new(e.message)
    end

    def log_name
      "#{self.class.command.capitalize}#start"
    end

    def log_payload
      { name: @name, arguments: @process_args }
    end

    def options
      OptionParser.new("Usage: #{script_name} #{self.class.command} [OPTIONS]") do |parser|
        parser.on('-n', '--name=NAME', String, 'The name of a process to run') { |x| @name = x }
        parser.on('-a', '--args=ARGS', String, 'The arguments to pass on to the process') { |x| @process_args = x }
      end
    end
  end
end