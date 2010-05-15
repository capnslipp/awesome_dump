# Copyright (c) 2010 Slippy Douglas & Michael Dvorkin
#
# Awesome Dump is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module AwesomeDumpActiveSupport

  # Format ActiveSupport::TimeWithZone as standard Time.
  def awesome_active_support_time(object)
    awesome_self(object, :as => :time)
  end

  # Format HashWithIndifferentAccess as standard Hash.
  #
  # NOTE: can't use awesome_self(object, :as => :hash) since awesome_self uses
  # object.inspect internally, i.e. it would convert hash to string.
  def awesome_hash_with_indifferent_access(object)
    awesome_hash(object)
  end

end

AwesomeDump.send(:include, AwesomeDumpActiveSupport)
