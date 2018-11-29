module Accelerate
  module System
    class Loop
      class_getter update_channel = Channel(String).new
      class_getter loops = 0
      getter channel : Channel(String)?
      @index = 0

      def initialize(channel : Symbol? = nil, wait : Bool = true, count = nil, &block)
        @index = (@@loops += 1)
        @channel = Channel(String).new unless channel.nil?
        spawn do
          self.class.game_loop(count, wait, &block)
        end
      end

      def self.game_loop(count = nil, wait : Bool = true, &block)
        iterator = if count.nil?
                     1.step
                   else
                     count.times
                   end
        iterator.each do |i|
          # s_print "#{Display::Terminal.reset_cursor(loops + 5)} #{i}"
          block.call
          # Only set wait to false if you will be customizing where the block yields
          Fiber.yield if wait
        end
      end

      def self.update_loop(count = nil, wait : Bool = true, &block)
        game_loop(count, wait, &block)
      end
    end
  end
end
