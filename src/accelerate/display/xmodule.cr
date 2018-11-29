require "io"
require "x11"

module Accelerate
  module Display
    module XModule
      extend self

      include X11
      include X11::C
      alias KEYS_DOWN = Hash(Int32 | UInt64, Bool)
      class_getter keys_down : KEYS_DOWN = {XK_Left => false, XK_Right => false, XK_Up => false, XK_Down => false} of Int32 | UInt64 => Bool

      class_getter display = Display.new
      class_getter fd = IO::FileDescriptor.new(display.connection_number, blocking: true)

      WM_DELETE_WINDOW_STR = "WM_DELETE_WINDOW"

      def initialize
        wm_delete_window = display.intern_atom(WM_DELETE_WINDOW_STR, false)
        # grab_keyboard
        s = display.default_screen_number

        # fd.read_timeout = 1.nanosecond

        root_win = display.root_window s

        # win = display.create_simple_window root_win, 10, 10, 400_u32, 300_u32, 1_u32, black_pix, white_pix
        win = root_win

        display.select_input win,
          ButtonPressMask | ButtonReleaseMask | ButtonMotionMask |
          ExposureMask | EnterWindowMask | LeaveWindowMask |
          KeyPressMask | KeyReleaseMask

        display.map_window win
        display.set_wm_protocols win, [wm_delete_window]
      end

      def grab_keyboard
        X.grab_keyboard(display, X.default_root_window(display), X::True, GrabModeAsync, GrabModeAsync, CurrentTime)
      end

      def ungrab_keyboard
        X.ungrab_keyboard(display, CurrentTime)
      end

      def get_key
        loop do
          while display.pending == 0
            Fiber.yield
          end
          event = display.next_event
          case event
          when KeyEvent
            kcode = event.lookup_keysym event.state & ShiftMask ? 1 : 0
            @@keys_down[kcode] ||= false
            case event.type
            when KeyRelease
              if display.pending == 1
                next_event = display.peek_event
                if next_event.is_a?(KeyEvent) && next_event.time == event.time
                  # Throw away repeat keys because the repeat delay changes based on OS
                  display.next_event
                  next
                end
              end
              @@keys_down[kcode] = false
            when KeyPress
              case kcode
              # Quit buttons
              when XK_Escape, XK_Q
                BlackVeil.cleanup { }
              end
              @@keys_down[kcode] = true
            end
            return {event.type, kcode}
          else
            Log.debug "#{event.class}"
            next
          end
        end
      end

      def close_display
        ungrab_keyboard
        X.close_display(display)
      end
    end
  end
end
