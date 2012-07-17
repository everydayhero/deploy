Capistrano::Configuration.instance(:must_exist).load do
  set :unicorn_init_script, fetch(:unicorn_init_script) { "/etc/init.d/#{application}" }

  namespace :unicorn do
    desc <<-DESC
      Start the unicorn workers. This operation is able to be called \
      even if there are currently active workers. It will fail \
      gracefully.
    DESC
    task :start, :roles => :web do
      run "#{unicorn_init_script} start"
    end

    desc <<-DESC
      Stop the unicorn workers. This operation is able to be called \
      even if there are no active workers. It will fail gracefully.
    DESC
    task :stop, :roles => :web do
      run "#{unicorn_init_script} stop"
    end

    desc <<-DESC
      Restart the unicorn workers. This operation can be called \
      regardless of active / inactive workers. It will spin up new \
      workers if non exist or will restart the current active ones.
    DESC
    task :restart, :roles => :web do
      run "#{unicorn_init_script} restart"
    end
  end
end
