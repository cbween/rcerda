# frozen_string_literal: true

require 'test_helper'
require 'edr_agent_tester/version'

class TestEdrAgentTester < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::EdrAgentTester::VERSION
  end
end
