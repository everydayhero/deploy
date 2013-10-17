Capistrano::Configuration.instance(:must_exist).load do
  set :maintenance_init_script, fetch(:maintenance_init_script) { "/etc/init.d/#{application}-maintenance" }

  namespace :deploy do
    namespace :web do
      desc <<-DESC
        Display a maintenance page to external users instead of routing requests \
        through to the application. The application will still be visible from \
        the EDH office.

          $ cap deploy:web:disable
      DESC
      task :disable, roles: :web, except: {no_release: true} do
        sudo "#{maintenance_init_script} start"
      end

      desc <<-DESC
        Makes the application web-accessible again for external users.

          $ cap deploy:web:enable
      DESC
      task :enable, roles: :web, except: {no_release: true} do
        sudo "#{maintenance_init_script} stop"
      end
    end
  end
end
