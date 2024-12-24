# frozen_string_literal: true

require "test_helper"
require "cbween_edr_agent"
require "cbween_edr_agent/agents/process_agent"

class CbweenEdrAgent::ProcessAgentTest < Minitest::Test
  def test_process_success_valid_params
    params = %w(-n ls -a "-alh")
    agent = CbweenEdrAgent::ProcessAgent.new(params)

    out, err = capture_subprocess_io do
      agent.run
    end

    assert_match %r%cbween_edr_agent.gemspec%, out
    assert_empty err
  end

  def test_process_fails_invalid_process
    params = %w(-n some_invalid_process_name -a "-alh")
    agent = CbweenEdrAgent::ProcessAgent.new(params)

    out, err = capture_subprocess_io do
      agent.run
    end

    refute_empty err
  end

  def test_process_fails_invalid_invoke
    params = %w(-n ping -a "-alh")
    agent = CbweenEdrAgent::ProcessAgent.new(params)

    out, err = capture_subprocess_io do
      agent.run
    end

    refute_empty err
  end

  def test_log_name
    assert_equal "Process#start", CbweenEdrAgent::ProcessAgent.new(%w(-n ls -a "-alh")).log_name
  end

  def test_log_payload
    expected_hash =  { name: "ls", arguments: '"-alh"' }
    agent = CbweenEdrAgent::ProcessAgent.new(%w(-n ls -a "-alh"))
    assert_equal expected_hash, agent.log_payload
  end
end
