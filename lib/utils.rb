require 'find'
require 'tempfile'
require_relative '../lib/utils.rb'

module Trebuchet

  class Utils

    def self.filenames_from_directory(directory)
      Find.find(directory).reject do |pathname|
        File.directory?(pathname) || pathname.start_with?(File.join(directory, '.git'))
      end
    end

    def self.safe_environment_name(application_name, version_label)
      safe_application_name = application_name[0..9]
      safe_version_label = ('-' + version_label[0..7]).gsub(/\-+$/, '')

      "#{safe_application_name}-dev#{safe_version_label}"
    end

  end
end
