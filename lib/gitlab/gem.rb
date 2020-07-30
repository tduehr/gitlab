# frozen_string_literal: true

require 'gitlab/gem/version'
require 'gitlab/gem/objectified_hash'
require 'gitlab/gem/configuration'
require 'gitlab/gem/error'
require 'gitlab/gem/page_links'
require 'gitlab/gem/paginated_response'
require 'gitlab/gem/file_response'
require 'gitlab/gem/request'
require 'gitlab/gem/api'
require 'gitlab/gem/client'

module Gitlab
  module Gem
    extend Configuration

    # Alias for Gitlab::Gem::Client.new
    #
    # @return [Gitlab::Gem::Client]
    def self.client(options = {})
      Gitlab::Gem::Client.new(options)
    end

    # Delegate to Gitlab::Gem::Client
    def self.method_missing(method, *args, &block)
      return super unless client.respond_to?(method)

      client.send(method, *args, &block)
    end

    # Delegate to Gitlab::Gem::Client
    def self.respond_to_missing?(method_name, include_private = false)
      client.respond_to?(method_name) || super
    end

    # Delegate to HTTParty.http_proxy
    def self.http_proxy(address = nil, port = nil, username = nil, password = nil)
      Gitlab::Gem::Request.http_proxy(address, port, username, password)
    end

    # Returns an unsorted array of available client methods.
    #
    # @return [Array<Symbol>]
    def self.actions
      hidden =
        /endpoint|private_token|auth_token|user_agent|sudo|get|post|put|\Adelete\z|validate\z|request_defaults|httparty/
      (Gitlab::Gem::Client.instance_methods - Object.methods).reject { |e| e[hidden] }
    end
  end
end