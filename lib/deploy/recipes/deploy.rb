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
  set :config_files,        fetch(:config_files)   { Array.new }
  set :job_runner?,         fetch(:job_runner)     { false }
  set :subscribe?,          fetch(:subscribe)      { false }
  set :branch,              fetch(:branch)         { 'master' }
  set :run_migrations?,     fetch(:run_migrations) { false }
  set :group_writable,      false
  set :server_mappings,     {
    'development' => fetch(:development_servers),
    'staging'     => fetch(:staging_servers),
    'production'  => fetch(:production_servers)
  }
  set :environment,         fetch(:environment, 'development')
  set :servers,             Array(server_mappings[environment])

  after "deploy:restart", "deploy:cleanup"
  after "deploy:finalize_update", "deploy:migrate" if run_migrations?

  role :subscribe,  servers.first
  role :web,        *servers
  role :app,        *servers
  role :db,         servers.first, :primary => true

  load 'deploy/assets' if fetch(:asset_pipeline) { true }

  on :start, 'deploy:confirmation', only: 'deploy'

  namespace :deploy do
    desc <<-DESC
      Override the default capistrano setup because folder structure \
      is taken care of by puppet. This task currently:
        * update code
        * symlink
        * bundle install
        * loads database schema
        * run any migrations
    DESC
    task :setup, :except => {:no_release => true} do
      set :latest_release, release_path

      transaction do
        update

        if run_migrations
          load_schema
          migrate
        end
      end

      restart
    end

    desc <<-DESC
      Start the web application. This task currently:
        * starts app server
        * starts job runner (if set)
    DESC
    task :start, :roles => :app do
      app_server.start
      job_runner.start if job_runner?
      subscribe.start if subscribe?
    end

    desc <<-DESC
      Stop the web application. This task currently:
        * stops app server
        * stops job runner (if set)
    DESC
    task :stop, :roles => :app do
      app_server.stop
      job_runner.stop if job_runner?
      subscribe.stop if subscribe?
    end

    desc <<-DESC
      Restart the web application. This task currently:
        * restarts app server
        * restarts job runner (if set)
    DESC
    task :restart, :roles => :app do
      app_server.restart
      job_runner.restart if job_runner?
      subscribe.restart if subscribe?
    end

    desc <<-DESC
      Load the database schema from db/schema.rb for the current \
      environment. This will give you the lastest schema without \
      running migrations.
    DESC
    task :load_schema, :roles => :db, :only => {:primary => true} do
      run "cd #{latest_release} && RAILS_ENV=#{rails_env} #{rake} db:schema:load"
    end

    desc 'Do you REALLY REALLY want to deploy?'
    task :confirmation do
      Capistrano::CLI.ui.tap do |ui|
        ui.say "\n"
        ui.say '********************** \m/ DEPLOYING \m/ ***********************'
        ui.say "APP: #{application}"
        ui.say "BRANCH: #{branch}"
        ui.say "ENV: #{environment}"
        ui.say "\n"
      end
      unless Capistrano::CLI.ui.agree("What say you? (y/n)")
        Capistrano::CLI.ui.say "Fine. I didn't want to play with you anyway."
        abort
      end
      Capistrano::CLI.ui.tap do |ui|
        ui.say '*********************** GIGGITY GIGGITY ************************'
        ui.say "\n"
      end
    end
  end
end
