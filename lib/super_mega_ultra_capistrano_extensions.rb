require "super_mega_ultra_capistrano_extensions/version"

require "super_mega_ultra_capistrano_extensions/recipes/app"
require "super_mega_ultra_capistrano_extensions/recipes/app_server"
require "super_mega_ultra_capistrano_extensions/recipes/config"
require "super_mega_ultra_capistrano_extensions/recipes/deploy"
require "super_mega_ultra_capistrano_extensions/recipes/job_runner"

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
