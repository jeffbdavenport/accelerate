require "./screen_buffer"

module Accelerate
  module Display
    struct GameScreen
      getter rows, cols, window
      getter top_border, bottom_border, left_border, right_border = true, true, true, true
      @border : String?
      @buffer = ""

      # @char_width is the amount of Terminal columns the character will take up
      def initialize(@rows : Int32, @cols : Int32, @border_char : GameChar? = nil, row_offset = 0, col_offset = 0, @char_padding = 1, hide = false, @background : Background = Background.new(background: 255))
        border_size = @border_char.nil? ? 0 : 2
        cols = (cols * char_width) + (border_size * char_width)
        rows = rows + border_size
        @window = Window.new(rows, cols, row_offset + 1, col_offset + 1, hide)
        self.top_border = false
        print "#{border}#{fill_game_screen(@background)}"
      end

      def hide=(hide)
        window.hide = hide
      end

      def border?
        !@border_char.nil?
      end

      def top
        window.top + add_border
      end

      def left
        window.left + add_border + @char_padding
      end

      def last_col
        window.last_col - @char_padding
      end

      def last_row
        window.last_row
      end

      def screen_last_col
        last_col - add_border
      end

      def screen_last_row
        last_row - add_border
      end

      def char_width
        @char_padding + 1
      end

      def border_icon
        border_char = @border_char
        return "" if border_char.nil?
        "#{border_char.icon}#{spaces}"
      end

      def spaces
        " " * @char_padding
      end

      def print(char : AnyGameChar, row = 0, col = 0)
        print("#{char.icon}#{spaces}", row, col)
      end

      def print(string : String, row = 0, col = 0)
        raise ArgumentError.new("GameScreen starts at 0,0") unless row >= 0 && col >= 0
        row += window.row
        row *= char_width
        col += window.col
        raise "Out of GameScreen bounds" if row > window.last_row || col > window.last_col
        ScreenBuffer.print("#{Terminal.move_cursor(row, col)}#{string}")
      end

      def border : String
        return "" unless border?
        @border ||= begin
          border = ""
          # border = Terminal.move_cursor(window.top, window.left)
          # border += border_icon
          (cols + 2).times do |i|
            border += Terminal.move_cursor(window.top, window.left + (i * char_width))
            border += border_icon
          end
          (top).upto(screen_last_row) do |i|
            border += Terminal.move_cursor(i, window.left)
            border += border_icon
            border += Terminal.move_cursor(i, last_col)
            border += border_icon
          end
          # border += Terminal.move_cursor(window.last_row, window.left)
          # border += border_icon # * (cols + 2)
          (cols + 2).times do |i|
            border += Terminal.move_cursor(window.last_row, window.left + (i * char_width))
            border += border_icon
          end
          border += Terminal::RESET_FORMAT
        end
      end

      def fill_game_screen(char : AnyGameChar)
        fill = ""
        (top).upto(screen_last_row) do |i|
          fill += Terminal.move_cursor(i, left)
          fill += "#{char.icon}#{spaces}" * cols
        end
        fill
      end

      def top_border=(bool : Bool)
        @border = nil
        @top_border = bool
      end

      def left_border=(bool : Bool)
        @border = nil
        @left_border = bool
      end

      def right_border=(bool : Bool)
        @border = nil
        @right_border = bool
      end

      def bottom_border=(bool : Bool)
        @border = nil
        @bottom_border = bool
      end

      private def add_border
        border? ? 1 : 0
      end
    end
  end
end
