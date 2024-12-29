# frozen_string_literal: true

require 'test_helper'
require 'edr_agent_tester'
require 'edr_agent_tester/agents/process_agent_tester'

class EdrAgentTester::ProcessAgentTesterTest < Minitest::Test
  def setup
    super
    @test_params = { name: 'ls', args: '-alh' }
  end

  def test_log_name
    assert_equal 'Process#start', EdrAgentTester::ProcessAgentTester.new(@test_params).log_name
  end

  def test_log_payload
    expected_hash = { process_name: 'ls', arguments: '-alh' }
    agent = EdrAgentTester::ProcessAgentTester.new(@test_params)
    assert_equal expected_hash, agent.log_payload
  end

  def test_process_success_valid_params_quotes
    agent = EdrAgentTester::ProcessAgentTester.new({ name: 'ls', args: '"-alh"' })

    out, err = capture_subprocess_io do
      agent.run
    end

    assert_match(/edr_agent_tester.gemspec/, out)
    assert_empty err
  end

  def test_process_fails_invalid_process
    agent = EdrAgentTester::ProcessAgentTester.new({ name: 'some_invalid_process_name', args: '-alh' })

    assert_raises(EdrAgentTester::EdrAgentTester::EdrAgentTesterFailure) do
      _, err = capture_subprocess_io do
        agent.run
      end

      refute_empty err
    end
  end

  def test_process_returns_error_invalid_arguments
    agent = EdrAgentTester::ProcessAgentTester.new({ name: 'ping', args: '-alh' })

    _, err = capture_subprocess_io do
      agent.run
    end

    refute_empty err
  end
end
