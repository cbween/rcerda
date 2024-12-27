# frozen_string_literal: true

require 'httparty'

class CbweenEdrAgent::HttpAgent < CbweenEdrAgent::EdrAgent
  # TODO: More methods.
  METHODS = %w(get)
  #PORTS = %w(80 443)

  attr_reader :method, :host, :port
  attr_accessor :log_payload

  def self.command; 'http'; end

  def initialize(args = {})
    super args
  
    # TODO: Raise error if method not in list of methods
    # TODO: Raise error if port not in list of ports
    # TODO: Validate other inputs
  end

  def run
    logger.info "Initialize #{log_name}", log_payload
    logger.measure_info(message: "Completed #{log_name}", payload: log_payload) do
      self.send @method
    end
  end

  def get
    response = HTTParty.get(full_uri, headers: {}, logger: logger)
    @log_payload[:content_length] = response.body.size

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
    OptionParser.new("Usage: #{$0} #{self.class.command} [OPTIONS]") do |parser|
      parser.on('-m', '--method=METHOD', 'The method to take on a file.')   { |x| @method = x }
      parser.on('-h', '--host=HOST', 'The host to preform the method on.') { |x| @host = x }
      parser.on('-d', '--port=PORT', 'The port to make a request to.') { |x| @port = x }
      parser.on('-p', '--path=PATH', 'The path of a request.') { |x| @path = x }
      # TODO: Add Auth header / token
    end
  end
end