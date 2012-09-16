require "deploy/version"

require "deploy/recipes/app"
require "deploy/recipes/app_server"
require "deploy/recipes/config"
require "deploy/recipes/deploy"
require "deploy/recipes/job_runner"

module Capistrano
  class Command
    def environment
      return if options[:env].nil? || options[:env].empty?

      @environment ||= if String === options[:env]
        "env #{options[:env]}"
      else
        options[:env][:environment] ? ". #{options[:env][:environment]}; " : '' +
        options[:env].reject do |key, value|
          key == :environment
        end.inject("env") do |string, (name, value)|
          value = value.to_s.gsub(/[ "]/) { |m| "\\#{m}" }
          string << " #{name}=#{value}"
        end
      end
    end
  end
end
