module Accelerate
  module System
    Log = Logger.new(File.new("debug.log", "w"))
    Log.level = Logger::DEBUG
    Log.formatter = Logger::Formatter.new do |severity, datetime, progname, message, io|
      label = severity.unknown? ? "ANY" : severity.to_s
      io << label[0] << " - " << datetime << " -- " << message
    end
  end
end
