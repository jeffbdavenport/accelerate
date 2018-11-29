module Accelerate
  module Display
    module Terminal
      extend self
      RESET_FORMAT = format("0")

      # How long to wait after terminal dimentions have been changed
      WINDOW_DELAY = 60.milliseconds

      SPACE = ' '
      CLEAR = "\033c"
      # Cursor
      C = %w(s u K 2J A B C D)
      # Movement
      enum M
        SAVE
        RESTORE
        ERASE
        CLEAR
        UP
        DOWN
        FORWARD
        BACKWARD
      end

      TEXT = [1, 4, 9]
      enum DEC
        BOLD
        UNDERLINE
        STRIKE_THROUGH
      end

      class_getter to_print = [] of String | Char

      def resize_terminal(rows, cols)
        clear_screen
        print "\e[8;#{rows};#{cols}t"
        sleep WINDOW_DELAY
      end

      def cols
        `tput cols`.to_i
      end

      def rows
        `tput lines`.to_i
      end

      def clear_screen
        # print "#{CLEAR}"
        `clear`
        print "\e[3J"
      end

      def format(string : String)
        "\e[#{string}m"
      end

      # Foreground is colored if background is false
      # TODO : Change to dec : Enum? = nil
      def color(background = false, highcontrast = false, color = 1, dec = nil | Enum)
        raise "Invalid color" unless (0..8).covers?(color)
        ground = if highcontrast
                   background ? "10" : "9"
                 else
                   background ? '4' : '3'
                 end
        format("#{ground}#{color}#{decoration(dec)}")
      end

      def color256(background = false, color = 1, dec : Enum? = nil)
        raise "Invalid color" unless (0..255).covers?(color)
        ground = background ? '4' : '3'
        format("#{ground}8;5;#{color.to_s}#{decoration(dec)}")
      end

      def decoration(decoration : Enum?)
        return if decoration.nil?
        raise "Invalid decoration" unless TEXT[decoration]
        decoration = ";#{TEXT[decoration.to_i]}"
      end

      def cursor(str : String, i = nil)
        "\033[#{i}#{str}"
      end

      def move_cursor(line = 1, col = 1)
        cursor("#{line};#{col}H")
      end

      def reset_cursor(minus = 0)
        move_cursor(rows - minus, 1)
      end

      def s_print(value : String | Char)
        @@to_print.push(value)
      end
    end
  end
end
