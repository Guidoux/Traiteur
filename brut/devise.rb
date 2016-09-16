gem 'devise'
run 'bundle install'
generate 'devise:install'
inject_into_file 'config/environments/development.rb', "	config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }\n", after: "Rails.application.configure do\n"
generate 'devise User'
rake 'db:migrate'