require 'roodi'

def roodi(ruby_files)
  roodi = Roodi::Core::Runner.new
  ruby_files.each { |file| roodi.check_file(file) }
  roodi.errors.each {|error| puts error}
  puts "\nFound #{roodi.errors.size} errors."
end
