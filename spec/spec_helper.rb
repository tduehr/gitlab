# frozen_string_literal: true

require 'rspec'
require 'webmock/rspec'

require File.expand_path('../lib/gitlab/client', __dir__)
require File.expand_path('../lib/gitlab/client/cli', __dir__)

def capture_output
  out = StringIO.new
  $stdout = out
  $stderr = out
  yield
  $stdout = STDOUT
  $stderr = STDERR
  out.string
end

def load_fixture(name)
  name, extension = name.split('.')
  File.new(File.dirname(__FILE__) + "/fixtures/#{name}.#{extension || 'json'}")
end

RSpec.configure do |config|
  config.before(:all) do
    Gitlab::Client.endpoint = 'https://api.example.com'
    Gitlab::Client.private_token = 'secret'
  end
end

%i[get post put delete].each do |method|
  define_method "stub_#{method}" do |path, fixture, status_code = 200|
    stub_request(method, "#{Gitlab::Client.endpoint}#{path}")
      .with(headers: { 'PRIVATE-TOKEN' => Gitlab::Client.private_token })
      .to_return(body: load_fixture(fixture), status: status_code)
  end

  define_method "a_#{method}" do |path|
    a_request(method, "#{Gitlab::Client.endpoint}#{path}")
      .with(headers: { 'PRIVATE-TOKEN' => Gitlab::Client.private_token })
  end
end
