# frozen_string_literal: true

require 'fileutils'
module EdrAgentTester
  class FileAgentTester < EdrAgentTester
    ACTIONS = %w[create modify delete]

    attr_reader :action, :name, :type

    def self.command = 'file'

    def initialize(args = {})
      super args
    end

    def run
      # TODO: Raise error if action not in list of ACTIONS
      # TODO: Validate inputs
      raise EdrAgentTesterFailure.new('Action, Name and Type are required.') if @action.nil? || @name.nil? || @type.nil?

      send @action
    rescue StandardError => e
      logger.error("Failed #{log_name}", log_payload, e)
      raise EdrAgentTesterFailure.new(e.message)
    end

    def create
      if Dir.exist?(path) == false
        logger.debug('creating nonexistent path for file', path: path)
        FileUtils.mkdir_p path
      end

      handle = File.new(file_uri, 'wx')
      # TODO: Write something to file.
      handle.close

      true
    end

    def modify
      raise EdrAgentTesterFailure.new "The file #{file_uri} does not exist" unless File.exist? file_uri

      FileUtils.touch file_uri
    end

    def delete
      File.delete file_uri
    end

    def path
      @path ||= jail
    end

    def file_uri
      File.expand_path "#{path}/#{name}.#{type}"
    end

    def jail
      @jail ||= File.expand_path('../../../tmp/', __dir__)
    end

    def log_name
      "#{self.class.command.capitalize}##{@action}"
    end

    def log_payload
      { action: @action, file: file_uri }
    end

    def options
      OptionParser.new("Usage: #{script_name} #{self.class.command} [OPTIONS]") do |parser|
        parser.on('-a', '--action=ACTION', String, 'The action to take on a file.')   { |x| @action = x }
        parser.on('-n', '--name=NAME', String, 'The name of a existing or new file.') { |x| @name = x }
        parser.on('-p', '--path=PATH', String, 'The path of a existing or new file.') { |x|@path = x }
        # TODO: Mime gem to lookup and set vaild types
        parser.on('-t', '--type=TYPE', String, 'The type of a new file to create. e.g. [txt|csv|jpg]') { |x| @type = x.gsub('.', '') }
      end
    end
  end
end
