Photo.sync_with_flickr_by_user_and_tag(APP_CONFIG['flickr_user_id'], APP_CONFIG['synchronise_tag'])
Bj.submit "./script/runner ./lib/jobs/synchronise.rb", :submitted_at => 20.minutes.from_now
# Bj.submit "./script/runner ./lib/jobs/synchronise.rb", :submitted_at => 20.minutes.from_now