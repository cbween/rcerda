# frozen_string_literal: true

require 'test_helper'
require 'edr_agent_tester'
require 'edr_agent_tester/agents/process_agent_tester'

class EdrAgentTester::ProcessAgentTesterTest < Minitest::Test
  def test_log_name
    assert_equal 'Process#start', EdrAgentTester::ProcessAgentTester.new(%w[-n ls -a -alh]).log_name
  end

  def test_log_payload
    expected_hash = { name: 'ls', arguments: '-alh' }
    agent = EdrAgentTester::ProcessAgentTester.new(%w[-n ls -a -alh])
    assert_equal expected_hash, agent.log_payload
  end

  def test_process_success_valid_params
    params = %w[-n ls -a -alh]
    agent = EdrAgentTester::ProcessAgentTester.new(params)

    out, err = capture_subprocess_io do
      agent.run
    end

    assert_match(/edr_agent_tester.gemspec/, out)
    assert_empty err
  end

  def test_process_fails_invalid_process
    params = %w[-n some_invalid_process_name -a -alh]
    agent = EdrAgentTester::ProcessAgentTester.new(params)

    assert_raises(EdrAgentTester::EdrAgentTester::EdrAgentTesterFailure) do
      _, err = capture_subprocess_io do
        agent.run
      end

      refute_empty err
    end
  end

  def test_process_returns_error_invalid_arguments
    params = %w[-n ping -a -alh]
    agent = EdrAgentTester::ProcessAgentTester.new(params)

    _, err = capture_subprocess_io do
      agent.run
    end

    refute_empty err
  end
end
