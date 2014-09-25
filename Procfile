web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker: bundle exec sidekiq -c 15 -v
faye: rackup private_pub.ru -s thin -p $PORT -e $RACK_ENV