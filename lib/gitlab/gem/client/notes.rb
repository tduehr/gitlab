# frozen_string_literal: true

class Gitlab::Gem::Client
  # Defines methods related to notes.
  # @see https://docs.gitlab.com/ce/api/notes.html
  module Notes
    # Gets a list of projects notes.
    #
    # @example
    #   Gitlab::Gem.notes(5)
    #
    # @param [Integer] project The ID of a project.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::Gem::ObjectifiedHash>]
    def notes(project, options = {})
      get("/projects/#{url_encode project}/notes", query: options)
    end

    # Gets a list of notes for a issue.
    #
    # @example
    #   Gitlab::Gem.issue_notes(5, 10)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] issue The ID of an issue.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::Gem::ObjectifiedHash>]
    def issue_notes(project, issue, options = {})
      get("/projects/#{url_encode project}/issues/#{issue}/notes", query: options)
    end

    # Gets a list of notes for a snippet.
    #
    # @example
    #   Gitlab::Gem.snippet_notes(5, 1)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] snippet The ID of a snippet.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::Gem::ObjectifiedHash>]
    def snippet_notes(project, snippet, options = {})
      get("/projects/#{url_encode project}/snippets/#{snippet}/notes", query: options)
    end

    # Gets a list of notes for a merge request.
    #
    # @example
    #   Gitlab::Gem.merge_request_notes(5, 1)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] merge_request The ID of a merge request.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::Gem::ObjectifiedHash>]
    def merge_request_notes(project, merge_request, options = {})
      get("/projects/#{url_encode project}/merge_requests/#{merge_request}/notes", query: options)
    end
    alias merge_request_comments merge_request_notes

    # Gets a list of notes for an epic.
    #
    # @example
    #   Gitlab::Gem.epic_notes(5, 10)
    #
    # @param [Integer] project The ID of a group.
    # @param [Integer] epic The ID of an epic.
    # @option options [Integer] :page The page number.
    # @option options [Integer] :per_page The number of results per page.
    # @return [Array<Gitlab::Gem::ObjectifiedHash>]
    def epic_notes(group, epic, options = {})
      get("/groups/#{url_encode group}/epics/#{epic}/notes", query: options)
    end

    # Gets a single wall note.
    #
    # @example
    #   Gitlab::Gem.note(5, 15)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] id The ID of a note.
    # @return [Gitlab::Gem::ObjectifiedHash]
    def note(project, id)
      get("/projects/#{url_encode project}/notes/#{id}")
    end

    # Gets a single issue note.
    #
    # @example
    #   Gitlab::Gem.issue_note(5, 10, 1)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] issue The ID of an issue.
    # @param [Integer] id The ID of a note.
    # @return [Gitlab::Gem::ObjectifiedHash]
    def issue_note(project, issue, id)
      get("/projects/#{url_encode project}/issues/#{issue}/notes/#{id}")
    end

    # Gets a single snippet note.
    #
    # @example
    #   Gitlab::Gem.snippet_note(5, 11, 3)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] snippet The ID of a snippet.
    # @param [Integer] id The ID of a note.
    # @return [Gitlab::Gem::ObjectifiedHash]
    def snippet_note(project, snippet, id)
      get("/projects/#{url_encode project}/snippets/#{snippet}/notes/#{id}")
    end

    # Gets a single merge_request note.
    #
    # @example
    #   Gitlab::Gem.merge_request_note(5, 11, 3)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] merge_request The ID of a merge_request.
    # @param [Integer] id The ID of a note.
    # @return [Gitlab::Gem::ObjectifiedHash]
    def merge_request_note(project, merge_request, id)
      get("/projects/#{url_encode project}/merge_requests/#{merge_request}/notes/#{id}")
    end

    # Creates a new wall note.
    #
    # @example
    #   Gitlab::Gem.create_note(5, 'This is a wall note!')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [String] body The body of a note.
    # @return [Gitlab::Gem::ObjectifiedHash] Information about created note.
    def create_note(project, body)
      post("/projects/#{url_encode project}/notes", body: { body: body })
    end

    # Creates a new issue note.
    #
    # @example
    #   Gitlab::Gem.create_issue_note(6, 1, 'Adding a note to my issue.')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] issue The ID of an issue.
    # @param  [String] body The body of a note.
    # @return [Gitlab::Gem::ObjectifiedHash] Information about created note.
    def create_issue_note(project, issue, body)
      post("/projects/#{url_encode project}/issues/#{issue}/notes", body: { body: body })
    end

    # Creates a new snippet note.
    #
    # @example
    #   Gitlab::Gem.create_snippet_note(3, 2, 'Look at this awesome snippet!')
    #
    # @param  [Integer, String] project The ID or name of a project.
    # @param  [Integer] snippet The ID of a snippet.
    # @param  [String] body The body of a note.
    # @return [Gitlab::Gem::ObjectifiedHash] Information about created note.
    def create_snippet_note(project, snippet, body)
      post("/projects/#{url_encode project}/snippets/#{snippet}/notes", body: { body: body })
    end

    # Creates a new note for a single merge request.
    #
    # @example
    #   Gitlab::Gem.create_merge_request_note(5, 3, 'This MR is ready for review.')
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] merge_request The ID of a merge request.
    # @param [String] body The content of a note.
    def create_merge_request_note(project, merge_request, body)
      post("/projects/#{url_encode project}/merge_requests/#{merge_request}/notes", body: { body: body })
    end
    alias create_merge_request_comment create_merge_request_note

    # Creates a new epic note.
    #
    # @example
    #   Gitlab::Gem.create_epic_note(6, 1, 'Adding a note to my epic.')
    #
    # @param  [Integer, String] group The ID or name of a group.
    # @param  [Integer] epic The ID of an epic.
    # @param  [String] body The body of a note.
    # @return [Gitlab::Gem::ObjectifiedHash] Information about created note.
    def create_epic_note(group, epic, body)
      post("/groups/#{url_encode group}/epics/#{epic}/notes", body: { body: body })
    end

    # Deletes a wall note.
    #
    # @example
    #   Gitlab::Gem.delete_note(5, 15)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] id The ID of a note.
    # @return [Gitlab::Gem::ObjectifiedHash]
    def delete_note(project, id)
      delete("/projects/#{url_encode project}/notes/#{id}")
    end

    # Deletes an issue note.
    #
    # @example
    #   Gitlab::Gem.delete_issue_note(5, 10, 1)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] issue The ID of an issue.
    # @param [Integer] id The ID of a note.
    # @return [Gitlab::Gem::ObjectifiedHash]
    def delete_issue_note(project, issue, id)
      delete("/projects/#{url_encode project}/issues/#{issue}/notes/#{id}")
    end

    # Deletes a snippet note.
    #
    # @example
    #   Gitlab::Gem.delete_snippet_note(5, 11, 3)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] snippet The ID of a snippet.
    # @param [Integer] id The ID of a note.
    # @return [Gitlab::Gem::ObjectifiedHash]
    def delete_snippet_note(project, snippet, id)
      delete("/projects/#{url_encode project}/snippets/#{snippet}/notes/#{id}")
    end

    # Deletes a merge_request note.
    #
    # @example
    #   Gitlab::Gem.delete_merge_request_note(5, 11, 3)
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] merge_request The ID of a merge_request.
    # @param [Integer] id The ID of a note.
    # @return [Gitlab::Gem::ObjectifiedHash]
    def delete_merge_request_note(project, merge_request, id)
      delete("/projects/#{url_encode project}/merge_requests/#{merge_request}/notes/#{id}")
    end
    alias delete_merge_request_comment delete_merge_request_note

    # Modifies a wall note.
    #
    # @example
    #   Gitlab::Gem.edit_note(5, 15, 'This is an edited note')
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] id The ID of a note.
    # @param [String] body The content of a note.
    # @return [Gitlab::Gem::ObjectifiedHash]
    def edit_note(project, id, body)
      put("/projects/#{url_encode project}/notes/#{id}", body: note_content(body))
    end

    # Modifies an issue note.
    #
    # @example
    #   Gitlab::Gem.edit_issue_note(5, 10, 1, 'This is an edited issue note')
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] issue The ID of an issue.
    # @param [Integer] id The ID of a note.
    # @param [String] body The content of a note.
    # @return [Gitlab::Gem::ObjectifiedHash]
    def edit_issue_note(project, issue, id, body)
      put("/projects/#{url_encode project}/issues/#{issue}/notes/#{id}", body: note_content(body))
    end

    # Modifies a snippet note.
    #
    # @example
    #   Gitlab::Gem.edit_snippet_note(5, 11, 3, 'This is an edited snippet note')
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] snippet The ID of a snippet.
    # @param [Integer] id The ID of a note.
    # @param [String] body The content of a note.
    # @return [Gitlab::Gem::ObjectifiedHash]
    def edit_snippet_note(project, snippet, id, body)
      put("/projects/#{url_encode project}/snippets/#{snippet}/notes/#{id}", body: note_content(body))
    end

    # Modifies a merge_request note.
    #
    # @example
    #   Gitlab::Gem.edit_merge_request_note(5, 11, 3, 'This is an edited merge request note')
    #
    # @param [Integer] project The ID of a project.
    # @param [Integer] merge_request The ID of a merge_request.
    # @param [Integer] id The ID of a note.
    # @param [String] body The content of a note.
    # @return [Gitlab::Gem::ObjectifiedHash]
    def edit_merge_request_note(project, merge_request, id, body)
      put("/projects/#{url_encode project}/merge_requests/#{merge_request}/notes/#{id}", body: note_content(body))
    end
    alias edit_merge_request_comment edit_merge_request_note

    private

    # TODO: Remove this method after a couple deprecation cycles.  Replace calls with the code
    # in the 'else'.
    def note_content(body)
      if body.is_a?(Hash)
        warn 'Passing the note body as a Hash is deprecated.  You should just pass the String.'
        body
      else
        { body: body }
      end
    end
  end
end
