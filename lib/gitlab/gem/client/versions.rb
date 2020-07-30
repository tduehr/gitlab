# frozen_string_literal: true

class Gitlab::Gem::Client
  # Defines methods related to version
  # @see https://docs.gitlab.com/ce/api/version.html
  module Versions
    # Returns server version.
    # @see https://docs.gitlab.com/ce/api/version.html
    #
    # @example
    #   Gitlab::Gem.version
    #
    # @return [Array<Gitlab::Gem::ObjectifiedHash>]
    def version
      get('/version')
    end
  end
end
