#/bin/bash
echo "bundle install"
bundle install
echo "rake db:migrate"
rake db:migrate

echo "Starting rails app background"
rails s -b 0.0.0.0 &

/bin/bash