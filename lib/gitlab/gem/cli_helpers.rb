# frozen_string_literal: true

require 'yaml'
require 'json'
require 'base64'

class Gitlab::Gem::CLI
  # Defines methods related to CLI output and formatting.
  module Helpers
    module_function

    # Returns actions available to CLI & Shell
    #
    # @return [Array]
    def actions
      @actions ||= Gitlab::Gem.actions
    end

    # Returns Gitlab::Gem::Client instance
    #
    # @return [Gitlab::Gem::Client]
    def client
      @client ||= Gitlab::Gem::Client.new(endpoint: (Gitlab::Gem.endpoint || ''))
    end

    # Returns method names and their owners
    #
    # @return [Array<Hash>]
    def method_owners
      @method_owners ||= actions.map do |action|
        {
          name: action.to_s,
          owner: client.method(action).owner.to_s
        }
      end
    end

    # Returns filtered required fields.
    #
    # @return [Array]
    def required_fields(args)
      filtered_fields(args, '--only=')
    end

    # Returns filtered excluded fields.
    #
    # @return [Array]
    def excluded_fields(args)
      filtered_fields(args, '--except=')
    end

    # Returns fields filtered by a keyword.
    #
    # @return [Array]
    def filtered_fields(args, key)
      return [] unless args.any? && args.last.is_a?(String) && args.last.start_with?(key)

      args.last.gsub(key, '').split(',')
    end

    # Confirms command is valid.
    #
    # @return [Boolean]
    def valid_command?(cmd)
      command = cmd.is_a?(Symbol) ? cmd : cmd.to_sym
      Gitlab::Gem.actions.include?(command)
    end

    # Confirms command with a desctructive action.
    #
    # @return [String]
    def confirm_command(cmd)
      return unless cmd.start_with?('remove_', 'delete_')

      puts 'Are you sure? (y/n)'

      if %w[y yes].include?($stdin.gets.to_s.strip.downcase)
        puts 'Proceeding..'
      else
        puts 'Command aborted.'
        exit(1)
      end
    end

    # Gets defined help for a specific command/action.
    #
    # @return [String]
    def help(cmd = nil, &block)
      if cmd.nil? || Gitlab::Gem::Help.help_map.key?(cmd)
        Gitlab::Gem::Help.actions_table(cmd)
      else
        Gitlab::Gem::Help.get_help(cmd, &block)
      end
    end

    # Outputs a nicely formatted table or error message.
    def output_table(cmd, args, data)
      case data
      when Gitlab::Gem::ObjectifiedHash, Gitlab::Gem::FileResponse
        puts record_table([data], cmd, args)
      when Gitlab::Gem::PaginatedResponse
        puts record_table(data, cmd, args)
      else # probably just an error message
        puts data
      end
    end

    def output_json(cmd, args, data)
      if data.respond_to?(:empty?) && data.empty?
        puts '{}'
      else
        hash_result = case data
                      when Gitlab::Gem::ObjectifiedHash, Gitlab::Gem::FileResponse
                        record_hash([data], cmd, args, true)
                      when Gitlab::Gem::PaginatedResponse
                        record_hash(data, cmd, args)
                      else
                        { cmd: cmd, data: data, args: args }
                      end
        puts JSON.pretty_generate(hash_result)
      end
    end

    # Table to display records.
    #
    # @return [Terminal::Table]
    def record_table(data, cmd, args)
      return 'No data' if data.empty?

      arr, keys = get_keys(args, data)

      table do |t|
        t.title = "Gitlab::Gem.#{cmd} #{args.join(', ')}"
        t.headings = keys

        arr.each_with_index do |hash, index|
          values = []

          keys.each do |key|
            case value = hash[key]
            when Hash
              value = value.key?('id') ? value['id'] : 'Hash'
            when StringIO
              value = 'File'
            when nil
              value = 'null'
            end

            values << value
          end

          t.add_row values
          t.add_separator unless arr.size - 1 == index
        end
      end
    end

    # Renders the result of given commands and arguments into a Hash
    #
    # @param  [Array]  data         Resultset from the API call
    # @param  [String] cmd          The command passed to the API
    # @param  [Array]  args         Options passed to the API call
    # @param  [bool]   single_value If set to true, a single result should be returned
    # @return [Hash]   Result hash
    def record_hash(data, cmd, args, single_value = false)
      if data.empty?
        result = nil
      else
        arr, keys = get_keys(args, data)
        result = []
        arr.each do |hash|
          row = {}

          keys.each do |key|
            row[key] = case hash[key]
                       when Hash
                         'Hash'
                       when StringIO
                         Base64.encode64(hash[key].read)
                       when nil
                         nil
                       else
                         hash[key]
                       end
          end

          result.push row
        end
        result = result[0] if single_value && result.count.positive?
      end

      {
        cmd: "Gitlab::Gem.#{cmd} #{args.join(', ')}".strip,
        result: result
      }
    end

    # Helper function to get rows and keys from data returned from API call
    def get_keys(args, data)
      arr = data.map(&:to_h)
      keys = arr.first.keys.sort_by(&:to_s)
      keys &= required_fields(args) if required_fields(args).any?
      keys -= excluded_fields(args)
      [arr, keys]
    end

    # Helper function to call Gitlab commands with args.
    def gitlab_helper(cmd, args = [])
      args.any? ? Gitlab::Gem.send(cmd, *args) : Gitlab::Gem.send(cmd)
    rescue StandardError => e
      puts e.message
      yield if block_given?
    end

    # Convert a hash (recursively) to use symbol hash keys
    # @return [Hash]
    def symbolize_keys(hash)
      if hash.is_a?(Hash)
        hash = hash.each_with_object({}) do |(key, value), new_hash|
          new_hash[key.to_sym] = symbolize_keys(value)
        rescue NoMethodError
          raise "Error: cannot convert hash key to symbol: #{key}"
        end
      end

      hash
    end

    # Check if arg is a color in 6-digit hex notation with leading '#' sign
    def hex_color?(arg)
      pattern = /\A#\h{6}\Z/

      pattern.match(arg)
    end

    # YAML::load on a single argument
    def yaml_load(arg)
      hex_color?(arg) ? arg : YAML.safe_load(arg)
    rescue Psych::SyntaxError
      raise "Error: Argument is not valid YAML syntax: #{arg}"
    end
  end
end
