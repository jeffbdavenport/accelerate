module Accelerate
  module Display
    module Terminal
      struct Window
        class_property windows = [] of Window
        getter rows, cols, row, col

        def self.resize_terminal
          rows, cols = 0, 0
          windows.select(&.display?).each do |window|
            rows = window.last_row if window.last_row > rows
            cols = window.last_col if window.last_col > cols
          end
          Terminal.resize_terminal(rows, cols)
        end

        def initialize(@rows : Int32, @cols : Int32, @row : Int32 = 1, @col : Int32 = 1, @hide = false, resize = true)
          self.class.windows.push(self)
          self.class.resize_terminal if resize
        end

        def top
          @row
        end

        def left
          @col
        end

        def hidden?
          @hide
        end

        def display?
          !@hide
        end

        # -1 to account for Terminal starting at 1 instead of 0
        def row_buffer
          row - 1
        end

        def col_buffer
          col - 1
        end

        def last_row
          rows + row_buffer
        end

        def last_col
          cols + col_buffer
        end
      end
    end
  end
end
