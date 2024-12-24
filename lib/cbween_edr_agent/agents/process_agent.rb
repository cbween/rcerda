# frozen_string_literal: true

class CbweenEdrAgent::ProcessAgent < CbweenEdrAgent::EdrAgent
  attr_accessor :host, :port

  def self.command; 'process'; end

  def initialize(args = {})
    super args
  end

  def run
    logger.info "Initialize #{log_name}", log_payload
    logger.measure_debug("Completed #{log_name}", log_payload) do
      pid = Process.spawn "#{@name} #{@process_args}"
      Process.waitpid(pid)
    end
  rescue => e
    logger.error "Failed #{log_name}", error_message: e.message
    raise EdrAgentFailure.new(e.message)
  end

  def log_name
    "#{self.class.command.capitalize}#start"
  end

  def log_payload
    { name: @name, arguments: @process_args }
  end

  def options
    OptionParser.new("Usage: #{$0} #{self.class.command} [OPTIONS]") do |parser|
      parser.on('-n', '--name=NAME', String, 'The name of a process to run') { |x| @name = x }
      parser.on('-a', '--args=ARGS', String, 'The arguments to pass on to the process') { |x| @process_args = x }
    end
  end
end