# Copyright (c) 2010 Slippy Douglas & Michael Dvorkin
#
# Awesome Dump is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module AwesomeDumpActiveRecord

  # Format ActiveRecord instance object.
  def awesome_active_record_instance(object)
    data = object.class.column_names.inject(ActiveSupport::OrderedHash.new) do |hash, name|
      hash[name.to_sym] = object.send(name) if object.has_attribute?(name) || object.new_record?
      hash
    end
    "#{object} " + awesome_hash(data)
  end

  # Format ActiveRecord class object.
  def awesome_active_record_class(object)
    if object.respond_to?(:columns)
      data = object.columns.inject(ActiveSupport::OrderedHash.new) do |hash, c|
        hash[c.name.to_sym] = c.type
        hash
      end
      "class #{object} < #{object.superclass} " << awesome_hash(data)
    else
      object.inspect
    end
  end
  
end

AwesomeDump.send(:include, AwesomeDumpActiveRecord)
