Capistrano::Configuration.instance(:must_exist).load do
  after "deploy:finalize_update", "app:permissions"

  namespace :app do
    desc <<-DESC
      Change application permissions.

      Because the user deploying the application is different to the user
      running the application we need to ensure that the permissions on
      directories are what we expect.
    DESC
    task :permissions, :except => {:no_release => true} do
      run "chmod -R g+w #{latest_release}/tmp"
    end
  end
end
