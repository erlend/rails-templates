run "echo TODO > README"

gem "mislav-will_paginate", :lib => "will_paginate", :source => "http://gems.github.com"
gem "thoughtbot-shoulda", :version => ">= 2.9.1", :lib => "shoulda", :souce => "http://gems.github.com"
rake "gems:install"

if yes?("Do you want to use Hoptoad?")
  plugin "hoptoad_notifier", :git => "git://github.com/thoughtbot/hoptoad_notifier.git"
  file "config/initializers/hoptoad.rb", <<-EOF
  HoptoadNotifier.configure do |config|
    config.api_key = 'REPLACE_ME'
  end
  EOF
  
end

if yes?("Do you want to generate a welcome controller")
  generate :controller, "welcome index"
  route "map.root :controller => 'welcome'"
  run "rm public/index.html"
end

git :init

file ".gitignore", <<-EOF
.DS_Store
config/database.yml
.*.swp
db/*.sqlite3*
log/*.log
tmp/**/*
public/*/cache/*
EOF

run "touch {tmp,log,vendor}/.gitignore"
run "cp config/database.yml config/database_example.yml"
git :add => ".", :commit => "-m 'initial commit'"
