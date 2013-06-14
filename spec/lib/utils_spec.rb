require_relative '../../lib/utils.rb'
require_relative '../spec_helper.rb'

describe 'utils' do

  describe '#filenames_from_directory' do

    before(:all) do
      @tmp_dir = Dir.mktmpdir
      Dir.chdir(@tmp_dir) do
        FileUtils.touch('all_the_files')
        FileUtils.touch('.all_the_files')
        FileUtils.mkdir('subdirectory')
        FileUtils.touch('subdirectory/subfile')
        FileUtils.mkdir('.subdirectory')
        FileUtils.touch('.subdirectory/subfile')
        FileUtils.mkdir('.git')
        FileUtils.touch('.git/subfile')
      end

      @files = filenames_from_directory(@tmp_dir)
    end

    it 'includes all the files' do
      @files.should include(File.join(@tmp_dir, 'all_the_files'))
    end

    it 'includes all the hidden files' do
      @files.should include(File.join(@tmp_dir, '.all_the_files'))
    end

    it 'excludes subdirectories themselves' do
      @files.should_not include(File.join(@tmp_dir, 'subdirectory'))
    end

    it 'includes files in subdirectories' do
      @files.should include(File.join(@tmp_dir, 'subdirectory', 'subfile'))
    end

    it 'excludes hidden subdirectories themselves' do
      @files.should_not include(File.join(@tmp_dir, '.subdirectory'))
    end

    it 'includes files in hidden subdirectories' do
      @files.should include(File.join(@tmp_dir, '.subdirectory', 'subfile'))
    end

    it 'does not include files under .git' do
      @files.should_not include(File.join(@tmp_dir, '.git', 'subfile'))
    end

    after(:all) do
      FileUtils.rm_rf(@tmp_dir)
    end

  end

  describe '#safe_environment_name' do

    it 'truncates long application names' do
      safe_environment_name('01234567890123456789', 'foo').should == '0123456789-dev-foo'
    end

    it 'truncates long version labels' do
      safe_environment_name('foo', '01234567890123456789').should == 'foo-dev-01234567'
    end

    it 'ensures that the name never ends with a dash' do
      safe_environment_name('foo', '').should == 'foo-dev'
      safe_environment_name('foo', '0-').should == 'foo-dev-0'
    end

  end
end


