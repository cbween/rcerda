# frozen_string_literal: true

require "fileutils"

class CbweenEdrAgent::FileAgent < CbweenEdrAgent::EdrAgent
  ACTIONS = %w(create modify delete)

  attr_reader :action, :name, :path, :type, :jail

  def self.command; 'file'; end

  def initialize(args = {})
    super args
  end

  def run
    logger.info "Initialize #{log_name}", log_payload
    logger.measure_debug("Completed #{log_name}", log_payload) do
      # TODO: Raise error if action not in list of ACTIONS
      # TODO: Validate inputs
      self.send @action
    end
  rescue => e
    logger.error("Failed #{log_name}", log_payload, e)
    raise EdrAgentFailure.new(e.message)
  end

  def create
    if Dir.exist?(path) == false
      logger.debug("creating nonexistent path for file", path: path)
      FileUtils.mkdir_p path
    end
    
    handle = File.new(file_uri, 'wx')
    # TODO: Write something to file.
    handle.close

    true
  end

  def modify
    raise EdrAgentFailure.new "The file #{file_uri} does not exist" unless File.exist? file_uri
    FileUtils.touch file_uri
  end

  def delete
    File.delete file_uri
  end

  def path
    @path ||= jail
  end

  def log_payload
    { file: file_uri }
  end

  def file_uri
     file_uri = "#{path}/#{name}.#{type}"
  end

  def jail
    @jail ||= File.expand_path('../../../tmp/', __dir__)
  end

  def log_name
    "#{self.class.command.capitalize}##{@action}"
  end

  def options
    OptionParser.new("Usage: #{$0} #{self.class.command} [ OPTIONS] 'application name'") do |parser|
      parser.on('-a', '--action=ACTION', String, 'The action to take on a file.')   { |x| @action = x }
      parser.on('-n', '--name=NAME', String, 'The name of a existing or new file.') { |x| @name = x }
      parser.on('-p', '--path=PATH', String, 'The path of a existing or new file.') { |x| @path = "#{jail}/#{x}" }
      parser.on('-t', '--type=TYPE', String, 'The type of a new file to create.')   { |x| @type = x.gsub(".", "") }
    end
  end
end