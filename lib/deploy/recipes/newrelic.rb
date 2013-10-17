Capistrano::Configuration.instance(:must_exist).load do
  set :announce_to_newrelic?, fetch(:announce_to_newrelic) { false }

  if announce_to_newrelic?
    after 'deploy', 'newrelic:deploy'
  end

  namespace :newrelic do
    desc 'Notify NewRelic of a new deploy'
    task :deploy, roles: [:app], except: {no_release: true} do
      environment   = fetch(:environment)
      app_name      = "#{fetch(:application)} (#{environment})"
      user          = ENV.fetch 'USER', fetch(:user)
      from_revision = source.next_revision(current_revision)
      log_command   = "git log --no-color --pretty=format:'  * %an: %s' --abbrev-commit --no-merges #{previous_revision}..#{real_revision}"
      changelog     = `#{log_command}`
      revision      = source.query_revision(source.head) do |cmd|
        `#{cmd}`
      end

      run %{
        cd #{latest_release} && RAILS_ENV=#{rails_env} #{rake} newrelic:deploy ENV=#{rails_env} APP_NAME="#{app_name}" REVISION="#{revision}" CHANGELOG="#{changelog}" DEPLOYER="#{user}"
      }
    end
  end
end
