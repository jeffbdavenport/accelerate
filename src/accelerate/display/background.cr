require "./game_char_base"

module Accelerate
  module Display
    struct Background < GameCharBase
      @color : Nil

      def initialize(@background : Int32)
        @char = ' '
      end
    end
  end
end
