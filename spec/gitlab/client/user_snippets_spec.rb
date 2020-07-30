# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Gem::Client do
  describe '.user_snippets' do
    before do
      stub_get('/snippets', 'user_snippets')
      @snippets = Gitlab::Gem.user_snippets
    end

    it 'gets the correct resource' do
      expect(a_get('/snippets')).to have_been_made
    end

    it "returns a paginated response of user's snippets" do
      expect(@snippets).to be_a Gitlab::Gem::PaginatedResponse
      expect(@snippets.first.file_name).to eq('mclaughlin.rb')
    end
  end

  describe '.user_snippet' do
    before do
      stub_get('/snippets/1', 'user_snippet')
      @snippet = Gitlab::Gem.user_snippet(1)
    end

    it 'gets the correct resource' do
      expect(a_get('/snippets/1')).to have_been_made
    end

    it 'returns information about a snippet' do
      expect(@snippet.file_name).to eq('add.rb')
      expect(@snippet.author.name).to eq('John Smith')
    end
  end

  describe '.user_snippet_raw' do
    before do
      stub_get('/snippets/1/raw', 'snippet_content')
      @snippet_content = Gitlab::Gem.user_snippet_raw(1)
    end

    it 'gets the correct resource' do
      expect(a_get('/snippets/1/raw')).to have_been_made
    end

    it 'returns raw content of a user snippet' do
      expect(@snippet_content).to eq("#!/usr/bin/env ruby\n\nputs \"Cool snippet!\"\n")
    end
  end

  describe '.create_user_snippet' do
    before do
      stub_post('/snippets', 'created_user_snippet')
      @snippet = Gitlab::Gem.create_user_snippet(title: 'This is a snippet', content: 'Hello world', description: 'Hello World snippet', file_name: 'test.txt', visibility: 'internal')
    end

    it 'gets the correct resource' do
      body = { title: 'This is a snippet', content: 'Hello world', description: 'Hello World snippet', file_name: 'test.txt', visibility: 'internal' }
      expect(a_post('/snippets').with(body: body)).to have_been_made
    end

    it 'returns information about a new snippet' do
      expect(@snippet.file_name).to eq('test.txt')
      expect(@snippet.description).to eq('Hello World snippet')
      expect(@snippet.author.name).to eq('John Smith')
    end
  end

  describe '.edit_user_snippet' do
    before do
      stub_put('/snippets/1', 'updated_user_snippet')
      @snippet = Gitlab::Gem.edit_user_snippet(1, file_name: 'add.rb')
    end

    it 'gets the correct resource' do
      expect(a_put('/snippets/1')
        .with(body: { file_name: 'add.rb' })).to have_been_made
    end

    it 'returns information about an edited snippet' do
      expect(@snippet.file_name).to eq('add.rb')
    end
  end

  describe '.delete_user_snippet' do
    before do
      stub_delete('/snippets/1', 'empty')
      @snippet = Gitlab::Gem.delete_user_snippet(1)
    end

    it 'gets the correct resource' do
      expect(a_delete('/snippets/1')).to have_been_made
    end
  end

  describe '.public_snippets' do
    before do
      stub_get('/snippets/public', 'public_snippets').with(query: { per_page: 2, page: 1 })
      @snippets = Gitlab::Gem.public_snippets(per_page: 2, page: 1)
    end

    it 'gets the correct resource' do
      expect(a_get('/snippets/public')
        .with(query: { per_page: 2, page: 1 })).to have_been_made
    end

    it 'returns a paginated response of public snippets' do
      expect(@snippets).to be_a Gitlab::Gem::PaginatedResponse
      expect(@snippets.last.visibility).to eq('public')
    end
  end

  describe '.snippet_user_agent_details' do
    before do
      stub_get('/snippets/1/user_agent_detail', 'snippet_user_agent_details')
      @detail = Gitlab::Gem.snippet_user_agent_details(1)
    end

    it 'gets the correct resource' do
      expect(a_get('/snippets/1/user_agent_detail')).to have_been_made
    end

    it 'returns user agent detail information about the snippet' do
      expect(@detail.to_h.keys.sort).to eq(%w[akismet_submitted ip_address user_agent])
    end
  end
end
