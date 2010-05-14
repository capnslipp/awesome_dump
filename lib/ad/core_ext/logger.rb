# Copyright (c) 2010 Michael Dvorkin
#
# Awesome Dump is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module AwesomeDumpLogger

  # Add ad method to logger
  #------------------------------------------------------------------------------
  def ad(object, level = nil)
    level ||= AwesomeDump.defaults[:log_level] || :debug
    send level, object.ai
  end

end

Logger.send(:include, AwesomeDumpLogger) if defined?(Logger)
ActiveSupport::BufferedLogger.send(:include, AwesomeDumpLogger) if defined?(::ActiveSupport::BufferedLogger)
