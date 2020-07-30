# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Gem::Client do
  describe '.features' do
    before do
      stub_get('/features', 'features')
      @features = Gitlab::Gem.features
    end

    it 'gets the correct resource' do
      expect(a_get('/features')).to have_been_made
    end

    it 'returns a paginated response of features' do
      expect(@features).to be_a Gitlab::Gem::PaginatedResponse
    end
  end

  describe '.set_feature' do
    context 'when setting boolean value' do
      before do
        stub_post('/features/new_library', 'feature')
        @feature = Gitlab::Gem.set_feature('new_library', true)
      end

      it 'gets the correct resource' do
        expect(a_post('/features/new_library')
          .with(body: { value: true })).to have_been_made
      end

      it 'returns information about the feature' do
        expect(@feature).to be_a Gitlab::Gem::ObjectifiedHash
      end
    end

    context 'when setting percentage-of-time gate value' do
      before do
        stub_post('/features/new_library', 'feature')
        @feature = Gitlab::Gem.set_feature('new_library', 30)
      end

      it 'gets the correct resource' do
        expect(a_post('/features/new_library')
          .with(body: { value: 30 })).to have_been_made
      end

      it 'returns information about the feature' do
        expect(@feature).to be_a Gitlab::Gem::ObjectifiedHash
      end
    end
  end

  describe '.delete_feature' do
    before do
      stub_delete('/features/new_library', 'empty')
      Gitlab::Gem.delete_feature('new_library')
    end

    it 'gets the correct resource' do
      expect(a_delete('/features/new_library')).to have_been_made
    end
  end
end
