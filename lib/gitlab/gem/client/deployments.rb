# frozen_string_literal: true

class Gitlab::Gem::Client
  # Defines methods related to deployments.
  # @see https://docs.gitlab.com/ce/api/deployments.html
  module Deployments
    # Gets a list of project deployments.
    #
    # @example
    #   Gitlab::Gem.deployments(5)
    #   Gitlab::Gem.deployments(5, { per_page: 10, page:  2 })
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Hash] options A customizable set of options.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::Gem::ObjectifiedHash>]
    def deployments(project, options = {})
      get("/projects/#{url_encode project}/deployments", query: options)
    end

    # Gets a single deployment.
    #
    # @example
    #   Gitlab::Gem.deployment(5, 36)
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] id The ID of an deployment.
    # @return [Gitlab::Gem::ObjectifiedHash]
    def deployment(project, id)
      get("/projects/#{url_encode project}/deployments/#{id}")
    end
  end
end
