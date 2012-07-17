Capistrano::Configuration.instance(:must_exist).load do
  after "deploy:finalize_update", "config:symlink"

  namespace :config do
    set :config_files, fetch(:config_files, [])

    desc <<-DESC
      Creates a symlink between the unversioned application \
      configuration files in our shared directory and our application.
    DESC
    task :symlink, except: {no_release: true} do
      config_files.each do |file|
        run "ln -nfs #{shared_path}/config/#{file} #{latest_release}/config/#{file}"
      end
    end
  end
end
