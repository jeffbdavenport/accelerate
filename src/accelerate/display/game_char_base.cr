module Accelerate
  module Display
    alias AnyGameChar = GameChar | Background

    abstract struct GameCharBase
      getter color, background, char

      def icon : String
        "#{background}#{color}#{@char}"
      end

      def color
        color = @color
        return nil if color.nil?
        Terminal.color256(color: color)
      end

      def background
        background = @background
        return nil if background.nil?
        Terminal.color256(background: true, color: background)
      end
    end
  end
end
