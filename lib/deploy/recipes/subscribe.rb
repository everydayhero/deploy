Capistrano::Configuration.instance(:must_exist).load do
  set :subscribe_init_script, fetch(:subscribe_init_script) { "/etc/init.d/#{application}_subscribe" }

  namespace :subscribe do
    desc <<-desc
      Start the job runner. this operation can be called even if the \
      job runner is currently running. it will fail gracefully.
    desc
    task :start, :roles => :subscribe do
      sudo "#{subscribe_init_script} start"
    end

    desc <<-desc
      Stop the job runner. this operation can be called even if the \
      job runner is currently running. it will fail gracefully.
    desc
    task :stop, :roles => :subscribe do
      sudo "#{subscribe_init_script} stop"
    end

    desc <<-desc
      Restart the job runner. this operation can be called regardless \
      if the job runner is currently running or not.
    desc
    task :restart, :roles => :subscribe do
      sudo "#{subscribe_init_script} restart"
    end

    desc <<-desc
      Check the status of the job runner. this operation will report \
      on all the workers.
    desc
    task :status, :roles => :subscribe do
      sudo "#{subscribe_init_script} status"
    end
  end
end
