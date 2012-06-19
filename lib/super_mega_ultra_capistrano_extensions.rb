require "super_mega_ultra_capistrano_extensions/version"
# require "capistrano/command"

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
        end.inject("#{command} env") do |string, (name, value)|
          value = value.to_s.gsub(/[ "]/) { |m| "\\#{m}" }
          string << " #{name}=#{value}"
        end
      end
    end
  end
end
