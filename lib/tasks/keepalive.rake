desc "Called by the Heroku cron add-on to keep dyno awake"
task :call_page => :environment do
   uri = URI.parse('http://www.shouldifollow.com/404.html')
   Net::HTTP.get(uri)
 end