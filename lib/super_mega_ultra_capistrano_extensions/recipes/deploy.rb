Capistrano::Configuration.instance(:must_exist).load do
  set :default_run_options, {:pty => true}
  set :deploy_to,           "/var/www/apps/#{application}"
  set :default_environment, {:environment => "#{shared_path}/config/environment"}
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
        * starts app server
    DESC
    task :start do
      app_server.start
    end

    desc <<-DESC
      Stop the web application. This task currently:
        * stops app server
    DESC
    task :stop do
      app_server.stop
    end

    desc <<-DESC
      Restart the web application. This task currently:
        * restarts app server
    DESC
    task :restart do
      app_server.restart
    end
  end
end
