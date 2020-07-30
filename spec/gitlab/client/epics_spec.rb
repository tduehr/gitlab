# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Gem::Client do
  describe '.epics' do
    before do
      stub_get('/groups/1/epics', 'epics')
      @epics = Gitlab::Gem.epics(1)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/1/epics')).to have_been_made
    end

    it 'returns a paginated response of groups' do
      expect(@epics).to be_a Gitlab::Gem::PaginatedResponse
    end
  end

  describe '.epic' do
    before do
      stub_get('/groups/1/epics/2', 'epic')
      Gitlab::Gem.epic(1, 2)
    end

    it 'gets the correct resource' do
      expect(a_get('/groups/1/epics/2')).to have_been_made
    end
  end

  describe '.create_epic' do
    before do
      stub_post('/groups/1/epics', 'epic')
      Gitlab::Gem.create_epic(1, 'foo', description: 'bar')
    end

    it 'creates the right resource' do
      expect(a_post('/groups/1/epics')
        .with(body: { title: 'foo', description: 'bar' })).to have_been_made
    end
  end

  describe '.edit_epic' do
    before do
      stub_put('/groups/1/epics/2', 'epic')
      Gitlab::Gem.edit_epic(1, 2, title: 'mepmep')
    end

    it 'updates the correct resource' do
      expect(a_put('/groups/1/epics/2')
        .with(body: { title: 'mepmep' })).to have_been_made
    end
  end

  describe '.delete_epic' do
    before do
      stub_delete('/groups/1/epics/2', 'epic')
      Gitlab::Gem.delete_epic(1, 2)
    end

    it 'deletes the correct resource' do
      expect(a_delete('/groups/1/epics/2')).to have_been_made
    end
  end
end
