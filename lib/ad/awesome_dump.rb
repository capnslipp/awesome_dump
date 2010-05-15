# Copyright (c) 2010 Slippy Douglas & Michael Dvorkin
#
# Awesome Dump is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require "shellwords"

class AwesomeDump
  AD = :__awesome_dump__
  
  def initialize(options = {})
    @options = { 
      :multiline => true,
      :plain     => false,
      :indent    => 4,
      :color     => { 
        :array      => :white,
        :bigdecimal => :blue,
        :class      => :yellow,
        :date       => :greenish,
        :falseclass => :red,
        :fixnum     => :blue,
        :float      => :blue,
        :hash       => :pale,
        :struct     => :pale,
        :nilclass   => :red,
        :string     => :yellowish,
        :symbol     => :cyanish,
        :time       => :greenish,
        :trueclass  => :green
      }
    }
    
    # Merge custom defaults and let explicit options parameter override them.
    merge_custom_defaults!
    merge_options!(options)
    
    @indentation = @options[:indent].abs
    Thread.current[AD] ||= []
    
    @formatter = Formatter.new(self.method(:awesome), @options)
    
    extend Util
  end
  
  private
  
  ## Dispatcher that detects data nesting and invokes object-aware formatter.
  def awesome(object)
    if Thread.current[AD].include?(object.object_id)
      nested(object)
    else
      begin
        Thread.current[AD] << object.object_id
        @formatter.send(declassify(object).to_sym, object)
      ensure
        Thread.current[AD].pop
      end
    end
  end
  
  class Formatter
    def initialize(awesome_method, options = {})
      @awesome = awesome_method
      @options = options
    end
    
    ## Format an array.
    def array(a)
      return [] if a == []
      
      return a.inject([]) { |arr, item| arr << @awesome.call(item) }
    end
    
    ## Format a hash. If @options[:indent] if negative left align hash keys.
    def hash(h)
      return {} if h == {}
      return h.keys.inject({}) do |hash, key|
        hash.store @awesome.call(key), @awesome.call(h[key])
        hash
      end
    end
    
    def fixnum(f)
      return f.to_s if @options[:escape] == :quote
      return f
    end
    
    def nilclass(n)
      return 'nil' if @options[:escape] == :quote
      return nil
    end
    
    def trueclass(n)
      return 'true' if @options[:escape] == :quote
      return true
    end
    
    def falseclass(n)
      return 'false' if @options[:escape] == :quote
      return false
    end
    
    def symbol(s)
      return s.to_s.include?(':') ? %{:"#{s}"} : %{:#{s}} if [:quote, :safe].include?(@options[:escape])
      return s
    end
    
    def string(s)
      return %{"#{s}"} if @options[:escape] == :quote
      return s
    end
    
    ## Format a Struct. If @options[:indent] if negative left align hash keys.
    def struct(s)
      h = {}
      s.each_pair {|k,v| h[k] = v }
      return hash(h)
    end
    
    ## Format Class object.
    def class(c)
      if [:quote, :safe].include?(@options[:escape])
        sc = c.superclass
        return %{#{c} < #{sc}} if sc && sc != Object
        return c.to_s
      end
      return c
    end
    
    ## Format File object.
    def file(f)
      ls = File.directory?(f) ? `ls -adlF #{f.path.shellescape}` : `ls -alF #{f.path.shellescape}`
      return self[f] #, :with => ls.empty? ? nil : "\n#{ls.chop}")
    end
    
    ## Format Dir object.
    def dir(d)
      ls = `ls -alF #{d.path.shellescape}`
      return self[d] #, :with => ls.empty? ? nil : "\n#{ls.chop}")
    end
    
    ## Format BigDecimal and Rational objects by convering them to Float.
    def bigdecimal(n)
      return self[n.to_f] #, :as => :bigdecimal
    end
    alias :rational :bigdecimal
    
    ## Format an arbitrary object.
    ## Method name is an operator overload to avoid potential naming conflicts with class names that have been converted to method names.
    def [](object)
      return object.inspect #<< appear[:with].to_s #, appear[:as] || declassify(object)
    end
    
    ## Catch-all method to format an arbitrary object.
    def method_missing(method_id, object)
      return self[object]
    end
    
  end
  
  module Util
    ## Format nested data, for example:
    ##   arr = [1, 2]; arr << arr
    ##   => [1,2, [...]]
    ##   hsh = { :a => 1 }; hsh[:b] = hsh
    ##   => { :a => 1, :b => {...} }
    def nested(object)
      case declassify(object)
        when :array  then ['...']
        when :hash   then {'...' => '...'}
        when :struct then {'...' => '...'}
        else "...#{object.class}..."
      end
    end
    
    ## Turn class name into symbol, ex: Hello::World => :hello_world.
    def declassify(object)
      if object.is_a?(Struct)
        :struct
      else
        object.class.to_s.gsub(/:+/, "_").downcase.to_sym
      end
    end
  end
  
  ## Update @options by first merging the :color hash and then the remaining keys.
  def merge_options!(options = {})
    @options[:color].merge!(options.delete(:color) || {})
    @options.merge!(options)
  end
  
  ## Load ~/.adrc file with custom defaults that override default options.
  def merge_custom_defaults!
    dotfile = File.join(ENV["HOME"], ".adrc")
    if File.readable?(dotfile)
      load dotfile
      merge_options!(self.class.defaults)
    end
  rescue => e
    $stderr.puts "Could not load #{dotfile}: #{e}"
  end
  
  ## Class accessors for custom defaults.
  def self.defaults
    @@defaults ||= {}
  end
  
  def self.defaults=(args = {})
    @@defaults = args
  end
  
end
