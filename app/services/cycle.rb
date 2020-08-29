module Cycle

  cycles = {
    drain: %i[ drain ],
    flush: %i[ drain water ],
    water: %i[ pump drain ],
    air: %i[ air drain pause ],
    cleaner: %i[ pump cleaner cleaner_return water ],
    sani: %i[ pump sani sani_return water ],
    co2: %i[ co2 drain ],
  }

  routine = [
    :drain,
    :flush,
    :water,
    :air,
    :cleaner,
    :air,
    :sani,
    :air,
    :co2,
  ]

  # step
  # close all
  # step
  # close all

  module_function

  def run
    redis.set("start_time", Time.now)
    routine.each_with_index do |s, i|
      redis.set("current_step", i)
      step(s)
    end
  end

  def step(instructions)
  end

  def settings
    @_s ||= JSON.parse(redis.get('cycle_settings'), symbolize_names: true)
  end

  def redis
    @r ||= Redis.new
  end
end
