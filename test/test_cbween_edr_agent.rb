# frozen_string_literal: true

require "test_helper"
require "cbween_edr_agent/version"

class TestCbweenEdrAgent < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::CbweenEdrAgent::VERSION
  end
end
