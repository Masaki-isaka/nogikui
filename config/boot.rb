require 'yaml'
if YAML.respond_to?(:unsafe_load)
  module YAML
    class << self
      alias_method :load, :unsafe_load
    end
  end
end

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
