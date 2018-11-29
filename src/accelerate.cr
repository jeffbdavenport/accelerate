# An advanced 3D game engine in development with the goal in mind of convention, speed, and high quality over configuration
require "./accelerate/*"
require "./accelerate/devices/*"
require "./accelerate/display/*"
require "./accelerate/system/*"
require "./accelerate/server/*"
require "logger"

module Accelerate
  VERSION = "0.0.1"
  Log     = System::Log
  alias Loop = System::Loop
end
