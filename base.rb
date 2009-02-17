run "echo TODO > README"

# Gems
gem "mislav-will_paginate", :lib => "will_paginate", :source => "http://gems.github.com"
gem "thoughtbot-shoulda", :version => ">= 2.9.1", :lib => "shoulda", :souce => "http://gems.github.com"
rake "gems:install", :sudo => true

# Hoptoad
if yes?("Do you want to use Hoptoad?")
  plugin "hoptoad_notifier", :git => "git://github.com/thoughtbot/hoptoad_notifier.git"
  initializer "hoptoad.rb",
  %q{HoptoadNotifier.configure do |config|
  config.api_key = 'REPLACE_ME'
end}
  
  file "app/controllers/application_controller.rb",
  %q{class ApplicationController < ActionController::Base
  include HoptoadNotifier::Catcher
end}
end

# Welcome controller
if yes?("Do you want to generate a welcome controller")
  generate :controller, "welcome index"
  route "map.root :controller => 'welcome'"
  run "rm public/index.html"
end

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

git :init
git :add => "."
git :commit => "-a -m 'initial commit'"
