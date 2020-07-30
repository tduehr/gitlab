# frozen_string_literal: true

class Gitlab::Gem::Client
  # Defines methods related to Award Emojis.
  # @see https://docs.gitlab.com/ce/api/access_requests.html
  module AccessRequests
    # Gets a list of access requests for a project viewable by the authenticated user.
    #
    # @example
    #   Gitlab::Gem.project_access_requests(1)
    #
    # @param  [Integer, String] :project(required) The ID or name of a project.
    # @return [Array<Gitlab::Gem::ObjectifiedHash>] List of project access requests
    def project_access_requests(project)
      get("/projects/#{url_encode project}/access_requests")
    end

    # Gets a list of access requests for a group viewable by the authenticated user.
    #
    # @example
    #   Gitlab::Gem.group_access_requests(1)
    #
    # @param  [Integer, String] :group(required) The ID or name of a group.
    # @return [Array<Gitlab::Gem::ObjectifiedHash>] List of group access requests
    def group_access_requests(group)
      get("/groups/#{url_encode group}/access_requests")
    end

    # Requests access for the authenticated user to a project.
    #
    # @example
    #    Gitlab::Gem.request_project_access(1)
    #
    # @param  [Integer, String] :project(required) The ID or name of a project.
    # @return <Gitlab::Gem::ObjectifiedHash] Information about the requested project access
    def request_project_access(project)
      post("/projects/#{url_encode project}/access_requests")
    end

    # Requests access for the authenticated user to a group.
    #
    # @example
    #    Gitlab::Gem.request_group_access(1)
    #
    # @param  [Integer, String] :group(required) The ID or name of a group.
    # @return <Gitlab::Gem::ObjectifiedHash] Information about the requested group access
    def request_group_access(group)
      post("/groups/#{url_encode group}/access_requests")
    end

    # Approves a project access request for the given user.
    #
    # @example
    #    Gitlab::Gem.approve_project_access_request(1, 1)
    #    Gitlab::Gem.approve_project_access_request(1, 1, {access_level: '30'})
    #
    # @param  [Integer, String] :project(required) The ID or name of a project.
    # @param  [Integer] :user_id(required) The user ID of the access requester
    # @option options [Integer] :access_level(optional) A valid access level (defaults: 30, developer access level)
    # @return <Gitlab::Gem::ObjectifiedHash] Information about the approved project access request
    def approve_project_access_request(project, user_id, options = {})
      put("/projects/#{url_encode project}/access_requests/#{user_id}/approve", body: options)
    end

    # Approves a group access request for the given user.
    #
    # @example
    #    Gitlab::Gem.approve_group_access_request(1, 1)
    #    Gitlab::Gem.approve_group_access_request(1, 1, {access_level: '30'})
    #
    # @param  [Integer, String] :group(required) The ID or name of a group.
    # @param  [Integer] :user_id(required) The user ID of the access requester
    # @option options [Integer] :access_level(optional) A valid access level (defaults: 30, developer access level)
    # @return <Gitlab::Gem::ObjectifiedHash] Information about the approved group access request
    def approve_group_access_request(group, user_id, options = {})
      put("/groups/#{url_encode group}/access_requests/#{user_id}/approve", body: options)
    end

    # Denies a project access request for the given user.
    #
    # @example
    #    Gitlab::Gem.deny_project_access_request(1, 1)
    #
    # @param  [Integer, String] :project(required) The ID or name of a project.
    # @param  [Integer] :user_id(required) The user ID of the access requester
    # @return [void] This API call returns an empty response body.
    def deny_project_access_request(project, user_id)
      delete("/projects/#{url_encode project}/access_requests/#{user_id}")
    end

    # Denies a group access request for the given user.
    #
    # @example
    #    Gitlab::Gem.deny_group_access_request(1, 1)
    #
    # @param  [Integer, String] :group(required) The ID or name of a group.
    # @param  [Integer] :user_id(required) The user ID of the access requester
    # @return [void] This API call returns an empty response body.
    def deny_group_access_request(group, user_id)
      delete("/groups/#{url_encode group}/access_requests/#{user_id}")
    end
  end
end
