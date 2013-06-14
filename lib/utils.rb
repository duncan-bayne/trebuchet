require 'find'
require 'tempfile'

def filenames_from_directory(directory)
  Find.find(directory).reject do |pathname|
    File.directory?(pathname) || pathname.start_with?(File.join(directory, '.git'))
  end
end

def safe_environment_name(application_name, version_label)
  safe_application_name = application_name[0..9]
  safe_version_label = ('-' + version_label[0..7]).gsub(/\-+$/, '')

  "#{safe_application_name}-dev#{safe_version_label}"
end

def safe_system(command)
  system("#{command} > /dev/null") or raise "Could not run '#{command}' in '#{Dir.pwd}'"
end

def zip_from_directory(directory)
  string_io = Zip::ZipOutputStream::write_buffer do |zipfile|
    filenames_from_directory(directory).each do |pathname|
      zipfile.put_next_entry(pathname.sub(directory + '/', ''))
      zipfile.write(File.read(pathname))
    end
  end
  string_io.rewind
  string_io.sysread
end
