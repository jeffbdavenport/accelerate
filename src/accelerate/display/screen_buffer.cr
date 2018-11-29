module Accelerate
  module Display
    module ScreenBuffer
      extend self
      @@buffer = ""

      def print(string : String)
        @@buffer += string
      end

      def empty_buffer
        buffer = @@buffer
        @@buffer = ""
        buffer
      end
    end
  end
end
