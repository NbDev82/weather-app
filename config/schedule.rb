require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.cron '0 7 * * *' do
  UserMailer.send_daily_weather_summary.deliver_now
end
