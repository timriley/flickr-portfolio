begin
  require 'flickraw'
  FlickRaw.api_key = 'c6dd75f50c46aeb23918d4dd857220fe'
  FlickRaw.shared_secret = '5f1baac675b760c3'
rescue => e
  # FIXME "logger" does not exist here.
  # logger.error "flickraw init: could not connect to flickr: #{e}"    
end

# Only start the syncs if we're in dev or production.
# Bj.submit "./script/runner ./lib/jobs/synchronise.rb" if %w{development production}.include?(Rails.env)