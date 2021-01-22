# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Client do
  describe '.protected_tags' do
    before do
      stub_get('/projects/1/protected_tags', 'protected_tags')
      @protected_tags = Gitlab::Client.protected_tags(1)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/1/protected_tags')).to have_been_made
    end

    it "returns a response of a project's protected_tags" do
      expect(@protected_tags).to be_a Gitlab::Client::PaginatedResponse
    end
  end

  describe '.protected_tag' do
    before do
      stub_get('/projects/1/protected_tags/release-1-0', 'protected_tag')
      @protected_tag = Gitlab::Client.protected_tag(1, 'release-1-0')
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/1/protected_tags/release-1-0')).to have_been_made
    end

    it 'returns correct information about the protected_tag' do
      expect(@protected_tag.name).to eq 'release-1-0'
    end
  end

  describe '.protect_repository_tag' do
    before do
      stub_post('/projects/1/protected_tags', 'protected_tag')
      @protected_tag = Gitlab::Client.protect_repository_tag(1, 'release-1-0')
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/1/protected_tags')
        .with(body: { name: 'release-1-0' })).to have_been_made
    end

    it 'returns correct information about the protected repository tag' do
      expect(@protected_tag.name).to eq 'release-1-0'
    end
  end

  describe '.unprotect_repository_tag' do
    before do
      stub_delete('/projects/1/protected_tags/release-1-0', 'empty')
      Gitlab::Client.unprotect_repository_tag(1, 'release-1-0')
    end

    it 'gets the correct resource' do
      expect(a_delete('/projects/1/protected_tags/release-1-0')).to have_been_made
    end
  end
end
