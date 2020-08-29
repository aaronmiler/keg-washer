class PollingWorker
  include Sidekiq::Worker

  def perform
    r = Redis.new
    colors = %w[ red green ]
    colors.each do |c|
      v = r.get("buttons:#{c}") == 'true'
      ButtonChannel.broadcast_to(c, { state: v })
    end
    sleep(0.33333)
    PollingWorker.perform_async
  end
end
