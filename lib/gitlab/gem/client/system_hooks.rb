# frozen_string_literal: true

class Gitlab::Gem::Client
  # Defines methods related to system hooks.
  # @see https://docs.gitlab.com/ce/api/system_hooks.html
  module SystemHooks
    # Gets a list of system hooks.
    #
    # @example
    #   Gitlab::Gem.hooks
    #   Gitlab::Gem.system_hooks
    #
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::Gem::ObjectifiedHash>]
    def hooks(options = {})
      get('/hooks', query: options)
    end
    alias system_hooks hooks

    # Adds a new system hook.
    #
    # @example
    #   Gitlab::Gem.add_hook('http://example.com/hook')
    #   Gitlab::Gem.add_system_hook('https://api.example.net/v1/hook')
    #
    # @param  [String] url The hook URL.
    # @param  [Hash] options Additional options, as allowed by Gitlab API, including but not limited to:
    # @option options [String] :token A secret token for Gitlab to send in the `X-Gitlab-Token` header for authentication.
    # @option options [boolean] :enable_ssl_verification `false` will cause Gitlab to ignore invalid/unsigned certificate errors (default is `true`)
    # @return [Gitlab::Gem::ObjectifiedHash]
    def add_hook(url, options = {})
      post('/hooks', body: options.merge(url: url))
    end
    alias add_system_hook add_hook

    # Tests a system hook.
    #
    # @example
    #   Gitlab::Gem.hook(3)
    #   Gitlab::Gem.system_hook(12)
    #
    # @param  [Integer] id The ID of a system hook.
    # @return [Array<Gitlab::Gem::ObjectifiedHash>]
    def hook(id)
      get("/hooks/#{id}")
    end
    alias system_hook hook

    # Deletes a new system hook.
    #
    # @example
    #   Gitlab::Gem.delete_hook(3)
    #   Gitlab::Gem.delete_system_hook(12)
    #
    # @param  [Integer] id The ID of a system hook.
    # @return [Gitlab::Gem::ObjectifiedHash]
    def delete_hook(id)
      delete("/hooks/#{id}")
    end
    alias delete_system_hook delete_hook
  end
end
