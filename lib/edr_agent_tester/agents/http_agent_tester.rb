# frozen_string_literal: true

require 'httparty'

class EdrAgentTester::HttpAgentTester < EdrAgentTester::EdrAgentTester
  # TODO: More methods.
  METHODS = %w(get)
  PORTS = %w(80 443)

  attr_reader :method, :host, :port
  attr_accessor :log_payload

  def self.command; 'http'; end

  def initialize(args = {})
    super args
  end

  def run
    # TODO: Raise error if method not in list of methods
    # TODO: Raise error if port not in list of ports
    # TODO: Validate other inputs
    raise EdrAgentTesterFailure.new("Method, Domain, and Port are required.") if @method.nil? || @host.nil? || @port.nil?
    self.send @method
  rescue => e
   logger.error("Failed #{log_name}", log_payload, e)
   raise EdrAgentTesterFailure.new(e)
  end

  def get
    response = HTTParty.get(full_uri, headers: {}, logger: logger)
    log_payload[:content_length] = response.body.nil? ? 0 : response.body.size

    response
  end

  def full_uri
    "#{host}:#{port}/#{path}"
  end

  def path
    @path ||= ""
  end

  def log_name
    "#{self.class.command.capitalize}##{@method}"
  end

  def log_payload
    @log_payload ||= { http_method: @method, host: @host, port: @port, path: @path }
  end

  def options
    OptionParser.new("Usage: #{script_name} #{self.class.command} [OPTIONS]") do |parser|
      parser.on('-m', '--method=METHOD', 'The http method to take on a file.')   { |x| @method = x }
      parser.on('-d', '--domain=DOMAIN', 'The domain/host to preform the http method on.') { |x| @host = x }
      parser.on('-p', '--port=PORT', 'The port to make a request to.') { |x| @port = x }
      parser.on('-s', '--subpath=SUBPATH', 'The path of a request.') { |x| @path = x }
    end
  end
end