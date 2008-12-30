begin
  Photo.sync_with_flickr(:user_id => APP_CONFIG['flickr_user_id'], :tag => APP_CONFIG['synchronise_tag'])
rescue
  # FIXME log an error when sync fails
  true
end
Bj.submit "./script/runner ./lib/jobs/synchronise.rb", :submitted_at => 20.minutes.from_now