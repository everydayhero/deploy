Capistrano::Configuration.instance(:must_exist).load do
  set :default_run_options, {:pty => true}
  set :deploy_to,           "/var/www/apps/#{application}"
  set :default_environment, "#{shared_path}/config/environment"
  set :deploy_via,          :remote_cache
  set :keep_releases,       2
  set :port,                1022
  set :scm,                 :git
  set :user,                'edhdev'
  set :use_sudo,            false
  set :rake,                "bundle exec rake"
  set :config_files,        fetch(:config_files) { [] }

  namespace :deploy do
    desc <<-DESC
      Start the web application. This task currently:
        * starts unicorn
    DESC
    task :start do
      unicorn.start
    end

    desc <<-DESC
      Stop the web application. This task currently:
        * stops unicorn
    DESC
    task :stop do
      unicorn.stop
    end

    desc <<-DESC
      Restart the web application. This task currently:
        * restarts unicorn
    DESC
    task :restart do
      unicorn.restart
    end
  end
end
