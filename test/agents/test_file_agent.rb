# frozen_string_literal: true

require "test_helper"
require "edr_agent_tester"
require "edr_agent_tester/agents/file_agent_tester"

class EdrAgentTester::FileAgentTesterTest < Minitest::Test
  def test_log_name
    assert_equal "File#create", EdrAgentTester::FileAgentTester.new(%w(-a create -n test_file -t txt)).log_name
    assert_equal "File#modify", EdrAgentTester::FileAgentTester.new(%w(-a modify -n test_file -t txt)).log_name
    assert_equal "File#delete", EdrAgentTester::FileAgentTester.new(%w(-a delete -n test_file -t txt)).log_name
  end

  def test_log_payload
    path = File.expand_path('../../tmp/', __dir__)
    expected_hash =  { file: "#{path}/test_file.txt" }

    agent = EdrAgentTester::FileAgentTester.new(%w(-a create -n test_file -t txt))
    assert_equal expected_hash, agent.log_payload
  end
end

class EdrAgentTester::FileAgentCreateTest < Minitest::Test
  def teardown
    File.delete @agent.file_uri if (@agent && File.exist?(@agent.file_uri))
    super
  end

  def test_create_sucess_with_expected_params
    params = %w(-a create -n test_file -t txt)
    @agent = EdrAgentTester::FileAgentTester.new(params)

    File.delete @agent.file_uri if File.exist? @agent.file_uri
    refute File.exist? @agent.file_uri

    @agent.run
    assert File.exist? @agent.file_uri
  end

  def test_create_success_sub_dir_not_exists
    params = %w(-a create -n test_file -p test -t txt)
    @agent = EdrAgentTester::FileAgentTester.new(params)

    File.delete @agent.file_uri if File.exist? @agent.file_uri
    refute File.exist? @agent.file_uri

    @agent.run
    assert File.exist? @agent.file_uri
  end

  def test_create_fails_file_existed
    params = %w(-a create -n test_file -t txt)
    @agent = EdrAgentTester::FileAgentTester.new(params)

    File.delete @agent.file_uri if File.exist? @agent.file_uri
    refute File.exist? @agent.file_uri

    @agent.run
    assert File.exist? @agent.file_uri

    assert_raises(EdrAgentTester::EdrAgentTester::EdrAgentTesterFailure) do
      @agent.run
    end
  end
end

class EdrAgentTester::FileAgentModifyTest < Minitest::Test
  def setup
    super
    @test_params = %w(-n test_file -t json)
    agent = EdrAgentTester::FileAgentTester.new(['-a', 'create'] + @test_params)
    agent.create unless File.exist? agent.file_uri
  end

  def teardown
    a = EdrAgentTester::FileAgentTester.new(['-a', 'delete'] + @test_params)
    a.run if File.exist? a.file_uri
    super
  end

  def test_modify_success
    agent = EdrAgentTester::FileAgentTester.new(['-a', 'modify'] + @test_params)
    original_mftime = File.mtime(agent.file_uri)

    agent.run
    refute_equal original_mftime, File.mtime(agent.file_uri)
  end

  def test_modify_fail_file_does_not_exists
    agent = EdrAgentTester::FileAgentTester.new(['-a', 'delete'] + @test_params)
    agent.delete if File.exist? agent.file_uri
    refute File.exist? agent.file_uri

    assert_raises(EdrAgentTester::EdrAgentTester::EdrAgentTesterFailure) do
      test_agent = EdrAgentTester::FileAgentTester.new(['-a', 'modify'] + @test_params)
      test_agent.run
    end
  end
end

class EdrAgentTester::FileAgentDeleteTest < Minitest::Test
  def setup
    super
    @test_params = %w(-n test_file -t json)
    agent = EdrAgentTester::FileAgentTester.new(['-a', 'create'] + @test_params)
    agent.create unless File.exist? agent.file_uri
  end

  def teardown
    a = EdrAgentTester::FileAgentTester.new(['-a', 'delete'] + @test_params)
    a.run if File.exist? a.file_uri
    super
  end

  def test_delete_sucess
    agent = EdrAgentTester::FileAgentTester.new(['-a', 'delete'] + @test_params)
    assert File.exist? agent.file_uri

    agent.run
    refute File.exist? agent.file_uri
  end

  def test_delete_fail_file_not_exists
    agent = EdrAgentTester::FileAgentTester.new(['-a', 'delete'] + @test_params)
    agent.run

    assert_raises(EdrAgentTester::EdrAgentTester::EdrAgentTesterFailure) do
      agent.run
    end
  end
end
