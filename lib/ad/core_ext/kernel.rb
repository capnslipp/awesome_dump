# Copyright (c) 2010 Slippy Douglas & Michael Dvorkin
#
# Awesome Dump is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module Kernel

  def ad(options = {})
    ad = AwesomeDump.new(options)
    ad.send(:awesome, self)
  end
  alias :awesome_dump :ad
end
