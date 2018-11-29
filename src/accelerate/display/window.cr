require "crystglfw"

module Accelerate
  module Display
    module Window
      def self.initialize!(title : String, monitor : Bool, share = nil, width = 640, height = 480)
        LibGLFW.init

        # Create a window and its associated OpenGL context.
        window_handle = LibGLFW.create_window(width, height, title, monitor, share)

        # Render new frames until the window should close.
        until LibGLFW.window_should_close(window_handle)
          LibGLFW.swap_buffers(window_handle)
        end

        sleep 5
        # Destroy the window along with its context.
        LibGLFW.destroy_window(window_handle)

        # Terminate GLFW
        LibGLFW.terminate
      end
    end
  end
end
