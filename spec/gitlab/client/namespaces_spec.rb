# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Gem::Client do
  it { is_expected.to respond_to :namespaces }

  describe '.namespaces' do
    before do
      stub_get('/namespaces', 'namespaces')
      @namespaces = Gitlab::Gem.namespaces
    end

    it 'gets the correct resource' do
      expect(a_get('/namespaces')).to have_been_made
    end

    it 'returns a paginated response of namespaces' do
      expect(@namespaces).to be_a Gitlab::Gem::PaginatedResponse
      expect(@namespaces.first.path).to eq('john')
      expect(@namespaces.first.kind).to eq('user')
    end
  end
end
