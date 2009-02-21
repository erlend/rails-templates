run "echo TODO > README"

# Gems
gem "mislav-will_paginate", :lib => "will_paginate", :source => "http://gems.github.com"
gem "thoughtbot-shoulda", :lib => "shoulda", :souce => "http://gems.github.com"
gem "thoughtbot-factory_girl", :lib => "factory_girl", :souce => "http://gems.github.com"

if yes?("Install gems?")
  rake "gems:install", :sudo => true
end

# Git stuff
file ".gitignore",
%q{.DS_Store
config/database.yml
.*.swp
db/*.sqlite3*
log/*.log
tmp/**/*
public/*/cache/*}

run "touch {tmp,log,vendor}/.gitignore"
run "cp config/database.yml config/database_example.yml"
run "rm public/index.html"

gsub_file 'app/controllers/application_controller.rb', /#\s*(filter_parameter_logging :password)/, '\1'

git :init
git :add => "."
git :commit => "-a -m 'initial commit'"

# Plugins
run "braid add -p git://github.com/ntalbott/query_trace.git"

# Hoptoad
if yes?("Do you want to use Hoptoad?")
  run "braid add -p git://github.com/thoughtbot/hoptoad_notifier.git"
  key = ask("What is the projects API key?")
  initializer "hoptoad.rb", <<-EOF
HoptoadNotifier.configure do |config|
  config.api_key = \"#{key}\"
end
EOF
  
  gsub_file 'app/controllers/application_controller.rb', /(class ApplicationController.*)/, "\\1\n  include HoptoadNotifier"
  git :add => ".", :commit => "-m 'configured Hoptoad'"
end
