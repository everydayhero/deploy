Capistrano::Configuration.instance(:must_exist).load do
  set :app_server_init_script, fetch(:app_server_init_script) { "/etc/init.d/#{application}" }

  namespace :app_server do
    desc <<-DESC
      Start the app server. This operation can be called even if the \
      app server is currently running. It will fail gracefully.
    DESC
    task :start, :roles => :web do
      sudo "#{app_server_init_script} start"
    end

    desc <<-DESC
      Stop the app server. This operation can be called even if the \
      app server is stopped. It will fail gracefully.
    DESC
    task :stop, :roles => :web do
      sudo "#{app_server_init_script} stop"
    end

    desc <<-DESC
      Restart the app server. This operation can be called regardless \
      if the app server is currently up or down.
    DESC
    task :restart, :roles => :web do
      sudo "#{app_server_init_script} restart"
    end
  end
end
