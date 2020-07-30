# frozen_string_literal: true

class Gitlab::Gem::Client
  # Defines methods related to keys.
  # @see https://docs.gitlab.com/ce/api/keys.html
  module Keys
    # Gets information about a key.
    #
    # @example
    #   Gitlab::Gem.key(1)
    #
    # @param  [Integer] id The ID of a key.
    # @return [Gitlab::Gem::ObjectifiedHash]
    def key(id)
      get("/keys/#{id}")
    end
  end
end
