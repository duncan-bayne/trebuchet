def artifact_zip_from_git(git_url, git_sha)
  Dir.mktmpdir do |tmp_dir|
    git = Grit::Git.new('')
    git.clone({ quiet: true, progress: false }, git_url, tmp_dir)

    Dir.chdir(tmp_dir) do
      # can't use grit here because https://github.com/mojombo/grit/issues/166
      safe_system("git checkout #{git_sha} --quiet") if git_sha

      safe_system('bundle install')
      safe_system('bundle exec rake build')
    end

    zip_from_directory(tmp_dir)
  end
end

