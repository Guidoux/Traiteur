generate :controller, 'welcome', 'home'
gsub_file 'config/routes.rb', "  get 'welcome/home'", "  root 'welcome#home'"