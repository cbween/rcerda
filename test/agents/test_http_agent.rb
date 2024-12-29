# frozen_string_literal: true

require "test_helper"
require "edr_agent_tester"
require "edr_agent_tester/agents/http_agent_tester"

class EdrAgentTester::HttpAgentTesterTest < Minitest::Test

  def setup
    super
    @test_url = 'https://example-pretend-tld.com'
    @params = ['-m', 'get', '-d', @test_url, '-p', '443']
  end

  def test_get_success_valid_params_http
    test_url = 'http://example-pretend-tld.com'
    stub_request(:get, test_url).to_return(status: 200)
    params = ['-m', 'get', '-d', test_url, '-p', '80']
  
    agent = EdrAgentTester::HttpAgentTester.new(params)

    response = agent.run
    assert_equal Net::HTTPOK, response.response.class
  end

  def test_get_success_valid_params_https
    stub_request(:get, @test_url).to_return(status: 200)
    agent = EdrAgentTester::HttpAgentTester.new(@params)

    response = agent.run
    assert_equal Net::HTTPOK, response.response.class
  end

  def test_get_client_error
    stub_request(:get, @test_url).to_return(status: 400)
    agent = EdrAgentTester::HttpAgentTester.new(@params)

    response = agent.run
    assert_equal Net::HTTPBadRequest, response.response.class
  end

  def test_get_server_error
    stub_request(:get, @test_url).to_return(status: 500)
    agent = EdrAgentTester::HttpAgentTester.new(@params)

    response = agent.run
    assert_equal Net::HTTPInternalServerError, response.response.class
  end
end
