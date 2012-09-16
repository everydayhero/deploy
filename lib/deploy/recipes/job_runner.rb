Capistrano::Configuration.instance(:must_exist).load do
  set :job_runner_init_script, fetch(:job_runner_init_script) { "/etc/init.d/#{application}_job_runner" }

  namespace :job_runner do
    desc <<-DESC
      Start the job runner. This operation can be called even if the \
      job runner is currently running. It will fail gracefully.
    DESC
    task :start, :roles => :web do
      sudo "#{job_runner_init_script} start"
    end

    desc <<-DESC
      Stop the job runner. This operation can be called even if the \
      job runner is currently running. It will fail gracefully.
    DESC
    task :stop, :roles => :web do
      sudo "#{job_runner_init_script} stop"
    end

    desc <<-DESC
      Restart the job runner. This operation can be called regardless \
      if the job runner is currently running or not.
    DESC
    task :restart, :roles => :web do
      sudo "#{job_runner_init_script} restart"
    end

    desc <<-DESC
      Check the status of the job runner. This operation will report \
      on all the workers.
    DESC
    task :status, :roles => :web do
      sudo "#{job_runner_init_script} status"
    end
  end
end
