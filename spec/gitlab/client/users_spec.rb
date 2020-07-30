# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Gem::Client do
  describe '.users' do
    before do
      stub_get('/users', 'users')
      @users = Gitlab::Gem.users
    end

    it 'gets the correct resource' do
      expect(a_get('/users')).to have_been_made
    end

    it 'returns a paginated response of users' do
      expect(@users).to be_a Gitlab::Gem::PaginatedResponse
      expect(@users.first.email).to eq('john@example.com')
    end
  end

  describe '.user' do
    context 'with user ID passed' do
      before do
        stub_get('/users/1', 'user')
        @user = Gitlab::Gem.user(1)
      end

      it 'gets the correct resource' do
        expect(a_get('/users/1')).to have_been_made
      end

      it 'returns information about a user' do
        expect(@user.email).to eq('john@example.com')
      end
    end

    context 'without user ID passed' do
      before do
        stub_get('/user', 'user')
        @user = Gitlab::Gem.user
      end

      it 'gets the correct resource' do
        expect(a_get('/user')).to have_been_made
      end

      it 'returns information about an authorized user' do
        expect(@user.email).to eq('john@example.com')
      end
    end
  end

  describe '.create_user' do
    context 'when successful request' do
      before do
        stub_post('/users', 'user')
        @user = Gitlab::Gem.create_user('email', 'pass', 'john.smith')
      end

      it 'gets the correct resource' do
        body = { email: 'email', password: 'pass', username: 'john.smith', name: 'email' }
        expect(a_post('/users').with(body: body)).to have_been_made
      end

      it 'returns information about a created user' do
        expect(@user.email).to eq('john@example.com')
      end
    end

    context 'when bad request' do
      it 'throws an exception' do
        stub_post('/users', 'error_already_exists', 409)
        expect do
          Gitlab::Gem.create_user('email', 'pass', 'john.smith')
        end.to raise_error(Gitlab::Gem::Error::Conflict, "Server responded with code 409, message: 409 Already exists. Request URI: #{Gitlab::Gem.endpoint}/users")
      end
    end

    context 'when not enough arguments' do
      it 'throws an exception' do
        expect do
          Gitlab::Gem.create_user('email', 'pass')
        end.to raise_error(ArgumentError, 'Missing required parameters')
      end
    end
  end

  describe '.create_user_with_userame' do
    context 'when successful request' do
      before do
        stub_post('/users', 'user')
        @user = Gitlab::Gem.create_user('email', 'pass', 'username')
      end

      it 'gets the correct resource' do
        body = { email: 'email', password: 'pass', username: 'username', name: 'email' }
        expect(a_post('/users').with(body: body)).to have_been_made
      end

      it 'returns information about a created user' do
        expect(@user.email).to eq('john@example.com')
      end
    end

    context 'when bad request' do
      it 'throws an exception' do
        stub_post('/users', 'error_already_exists', 409)
        expect do
          Gitlab::Gem.create_user('email', 'pass', 'username')
        end.to raise_error(Gitlab::Gem::Error::Conflict, "Server responded with code 409, message: 409 Already exists. Request URI: #{Gitlab::Gem.endpoint}/users")
      end
    end
  end

  describe '.edit_user' do
    before do
      @options = { name: 'Roberto' }
      stub_put('/users/1', 'user').with(body: @options)
      @user = Gitlab::Gem.edit_user(1, @options)
    end

    it 'gets the correct resource' do
      expect(a_put('/users/1').with(body: @options)).to have_been_made
    end
  end

  describe '.delete_user' do
    before do
      stub_delete('/users/1', 'user')
      @user = Gitlab::Gem.delete_user(1)
    end

    it 'gets the correct resource' do
      expect(a_delete('/users/1')).to have_been_made
    end

    it 'returns information about a deleted user' do
      expect(@user.email).to eq('john@example.com')
    end
  end

  describe '.block_user' do
    before do
      stub_post('/users/1/block', 'user_block_unblock')
      @result = Gitlab::Gem.block_user(1)
    end

    it 'gets the correct resource' do
      expect(a_post('/users/1/block')).to have_been_made
    end

    it 'returns boolean' do
      expect(@result).to eq(true)
    end
  end

  describe '.unblock_user' do
    before do
      stub_post('/users/1/unblock', 'user_block_unblock')
      @result = Gitlab::Gem.unblock_user(1)
    end

    it 'gets the correct resource' do
      expect(a_post('/users/1/unblock')).to have_been_made
    end

    it 'returns boolean' do
      expect(@result).to eq(true)
    end
  end

  describe '.session' do
    after do
      Gitlab::Gem.endpoint = 'https://api.example.com'
      Gitlab::Gem.private_token = 'secret'
    end

    before do
      stub_request(:post, "#{Gitlab::Gem.endpoint}/session")
        .to_return(body: load_fixture('session'), status: 200)
      @session = Gitlab::Gem.session('email', 'pass')
    end

    context 'when endpoint is not set' do
      it 'raises Error::MissingCredentials' do
        Gitlab::Gem.endpoint = nil
        expect do
          Gitlab::Gem.session('email', 'pass')
        end.to raise_error(Gitlab::Gem::Error::MissingCredentials, 'Please set an endpoint to API')
      end
    end

    context 'when private_token is not set' do
      it 'does not raise Error::MissingCredentials' do
        Gitlab::Gem.private_token = nil
        expect { Gitlab::Gem.session('email', 'pass') }.not_to raise_error
      end
    end

    context 'when endpoint is set' do
      it 'gets the correct resource' do
        expect(a_request(:post, "#{Gitlab::Gem.endpoint}/session")).to have_been_made
      end

      it 'returns information about a created session' do
        expect(@session.email).to eq('john@example.com')
        expect(@session.private_token).to eq('qEsq1pt6HJPaNciie3MG')
      end
    end
  end

  describe '.activities' do
    before do
      stub_get('/user/activities', 'activities')
      @activities = Gitlab::Gem.activities
    end

    it 'gets the correct resource' do
      expect(a_get('/user/activities')).to have_been_made
    end

    it 'returns a paginated response of user activity' do
      expect(@activities).to be_a Gitlab::Gem::PaginatedResponse
      expect(@activities.first.username).to eq('someuser')
    end
  end

  describe '.ssh_keys' do
    context 'with user ID passed' do
      before do
        stub_get('/users/1/keys', 'keys')
        @keys = Gitlab::Gem.ssh_keys(user_id: 1)
      end

      it 'gets the correct resource' do
        expect(a_get('/users/1/keys')).to have_been_made
      end

      it 'returns a paginated response of SSH keys' do
        expect(@keys).to be_a Gitlab::Gem::PaginatedResponse
        expect(@keys.first.title).to eq('narkoz@helium')
      end
    end

    context 'without user ID passed' do
      before do
        stub_get('/user/keys', 'keys')
        @keys = Gitlab::Gem.ssh_keys
      end

      it 'gets the correct resource' do
        expect(a_get('/user/keys')).to have_been_made
      end

      it 'returns a paginated response of SSH keys' do
        expect(@keys).to be_a Gitlab::Gem::PaginatedResponse
        expect(@keys.first.title).to eq('narkoz@helium')
      end
    end
  end

  describe '.ssh_key' do
    before do
      stub_get('/user/keys/1', 'key')
      @key = Gitlab::Gem.ssh_key(1)
    end

    it 'gets the correct resource' do
      expect(a_get('/user/keys/1')).to have_been_made
    end

    it 'returns information about an SSH key' do
      expect(@key.title).to eq('narkoz@helium')
    end
  end

  describe '.create_ssh_key' do
    describe 'without user ID' do
      before do
        stub_post('/user/keys', 'key')
        @key = Gitlab::Gem.create_ssh_key('title', 'body')
      end

      it 'gets the correct resource' do
        body = { title: 'title', key: 'body' }
        expect(a_post('/user/keys').with(body: body)).to have_been_made
      end

      it 'returns information about a created SSH key' do
        expect(@key.title).to eq('narkoz@helium')
      end
    end

    describe 'with user ID' do
      before do
        stub_post('/users/1/keys', 'key')
        @options = { user_id: 1 }
        @key = Gitlab::Gem.create_ssh_key('title', 'body', @options)
      end

      it 'gets the correct resource' do
        body = { title: 'title', key: 'body' }
        expect(a_post('/users/1/keys').with(body: body)).to have_been_made
      end

      it 'returns information about a created SSH key' do
        expect(@key.title).to eq('narkoz@helium')
      end
    end
  end

  describe '.delete_ssh_key' do
    describe 'without user ID' do
      before do
        stub_delete('/user/keys/1', 'key')
        @key = Gitlab::Gem.delete_ssh_key(1)
      end

      it 'gets the correct resource' do
        expect(a_delete('/user/keys/1')).to have_been_made
      end

      it 'returns information about a deleted SSH key' do
        expect(@key.title).to eq('narkoz@helium')
      end
    end

    describe 'with user ID' do
      before do
        stub_delete('/users/1/keys/1', 'key')
        @options = { user_id: 1 }
        @key = Gitlab::Gem.delete_ssh_key(1, @options)
      end

      it 'gets the correct resource' do
        expect(a_delete('/users/1/keys/1')).to have_been_made
      end

      it 'returns information about a deleted SSH key' do
        expect(@key.title).to eq('narkoz@helium')
      end
    end
  end

  describe '.emails' do
    describe 'without user ID' do
      before do
        stub_get('/user/emails', 'user_emails')
        @emails = Gitlab::Gem.emails
      end

      it 'gets the correct resource' do
        expect(a_get('/user/emails')).to have_been_made
      end

      it 'returns a information about a emails of user' do
        email = @emails.first
        expect(email.id).to eq 1
        expect(email.email).to eq('email@example.com')
      end
    end

    describe 'with user ID' do
      before do
        stub_get('/users/2/emails', 'user_emails')
        @emails = Gitlab::Gem.emails(2)
      end

      it 'gets the correct resource' do
        expect(a_get('/users/2/emails')).to have_been_made
      end

      it 'returns a information about a emails of user' do
        email = @emails.first
        expect(email.id).to eq 1
        expect(email.email).to eq('email@example.com')
      end
    end
  end

  describe '.email' do
    before do
      stub_get('/user/emails/2', 'user_email')
      @email = Gitlab::Gem.email(2)
    end

    it 'gets the correct resource' do
      expect(a_get('/user/emails/2')).to have_been_made
    end

    it 'returns a information about a email of user' do
      expect(@email.id).to eq 1
      expect(@email.email).to eq('email@example.com')
    end
  end

  describe '.add_email' do
    describe 'without user ID' do
      before do
        stub_post('/user/emails', 'user_email')
        @email = Gitlab::Gem.add_email('email@example.com')
      end

      it 'gets the correct resource' do
        body = { email: 'email@example.com' }
        expect(a_post('/user/emails').with(body: body)).to have_been_made
      end

      it 'returns information about a new email' do
        expect(@email.id).to eq(1)
        expect(@email.email).to eq('email@example.com')
      end
    end

    describe 'with user ID' do
      before do
        stub_post('/users/2/emails', 'user_email')
        @email = Gitlab::Gem.add_email('email@example.com', 2)
      end

      it 'gets the correct resource' do
        body = { email: 'email@example.com' }
        expect(a_post('/users/2/emails').with(body: body)).to have_been_made
      end

      it 'returns information about a new email' do
        expect(@email.id).to eq(1)
        expect(@email.email).to eq('email@example.com')
      end
    end
  end

  describe '.delete_email' do
    describe 'without user ID' do
      before do
        stub_delete('/user/emails/1', 'user_email')
        @email = Gitlab::Gem.delete_email(1)
      end

      it 'gets the correct resource' do
        expect(a_delete('/user/emails/1')).to have_been_made
      end

      it 'returns information about a deleted email' do
        expect(@email).to be_truthy
      end
    end

    describe 'with user ID' do
      before do
        stub_delete('/users/2/emails/1', 'user_email')
        @email = Gitlab::Gem.delete_email(1, 2)
      end

      it 'gets the correct resource' do
        expect(a_delete('/users/2/emails/1')).to have_been_made
      end

      it 'returns information about a deleted email' do
        expect(@email).to be_truthy
      end
    end
  end

  describe '.user_search' do
    before do
      stub_get('/users?search=User', 'user_search')
      @users = Gitlab::Gem.user_search('User')
    end

    it 'gets the correct resource' do
      expect(a_get('/users?search=User')).to have_been_made
    end

    it 'returns an array of users found' do
      expect(@users.first.id).to eq(1)
      expect(@users.last.id).to eq(2)
    end
  end
end
