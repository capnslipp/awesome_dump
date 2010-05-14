require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require "bigdecimal"
require "rational"

describe "AwesomeDump" do
  before(:each) do
    stub_dotfile!
  end
  
  describe "Array" do
    before(:each) do
      @arr = [ 1, :two, "three", [ nil, [ true, false] ] ]
    end
    
    it "empty array" do
      [].ad.should == []
    end
    
    it "default" do
      @arr.ad.should == [ 1, :two, "three", [ nil, [ true, false ] ] ]
    end
    
    it "safe-escaped" do
      @arr.ad(:escape => :safe).should == [1, ':two', "three", [nil, [true, false]]]
    end
    
    it "quote-escape" do
      @arr.ad(:escape => :quote).should == ['1', ':two', '"three"', ['nil', ['true', 'false']]]
    end
  end
  
  #------------------------------------------------------------------------------
  describe "Nested Array" do
    before(:each) do
      @arr = [ 1, 2 ]
      @arr << @arr
    end
    
    it "default" do
      d = [1, 2, ['...']]
      @arr.ad.should == d
    end
    
    it "safe-escaped" do
      d = [1, 2, ['...']]
      @arr.ad(:escape => :safe).should == d
    end
    
    it "quote-escape" do
      d = ['1', '2', ['...']]
      @arr.ad(:escape => :quote).should == d
    end
  end
  
  #------------------------------------------------------------------------------
  describe "Hash" do
    before(:each) do
      @hash = { 1 => { :sym => { "str" => { [1, 2, 3] => { {:k => :v} => Hash } } } } }
    end
    
    it "empty hash" do
      {}.ad.should == {}
    end
    
    it "default" do
      d = { 1 => { :sym => { "str" => { [1, 2, 3] => { {:k => :v} => Hash } } } } }
      @hash.ad.should == d
    end
    
    it "safe-escaped" do
      d = { 1 => { ':sym' => { "str" => { [1, 2, 3] => { {':k' => ':v'} => 'Hash' } } } } }
      @hash.ad(:escape => :safe).should == d
    end
    
    it "quote-escape" do
      d = { '1' => { ':sym' => { '"str"' => { ['1', '2', '3'] => { {':k' => ':v'} => 'Hash' } } } } }
      @hash.ad(:escape => :quote).should == d
    end
    
  end
  
  #------------------------------------------------------------------------------
  describe "Nested Hash" do
    before(:each) do
      @hash = {}
      @hash[:a] = @hash
    end
    
    it "default" do
      d = { :a => {'...' => '...'} }
      @hash.ad.should == d
    end
    
    it "safe-escaped" do
      d = { ':a' => {'...' => '...'} }
      @hash.ad(:escape => :safe).should == d
    end
    
    it "quote-escape" do
      d = { ':a' => {'...' => '...'} }
      @hash.ad(:escape => :quote).should == d
    end
  end
  
  #------------------------------------------------------------------------------
  describe "Class" do
    it "shoud show superclass (default)" do
      Fixnum.ad.should == 'Fixnum < Integer'
      Class.ad.should == 'Class < Module'
    end
  end
  
  #------------------------------------------------------------------------------
  describe "File" do
    it "should display a file (default)" do
      File.open(__FILE__, 'r') do |f|
        f.ad.should == "#{f.inspect}\n" << `ls -alF #{f.path}`.chop
      end
    end
  end
  
  #------------------------------------------------------------------------------
  describe "Dir" do
    it "should display a directory (default)" do
      Dir.open(File.dirname(__FILE__)) do |d|
        d.ad.should == "#{d.inspect}\n" << `ls -alF #{d.path}`.chop
      end
    end
  end
  
  #------------------------------------------------------------------------------
  describe "BigDecimal and Rational" do
    it "should present BigDecimal object as Float scalar" do
      big = BigDecimal("2010.4")
      
      # @TODO: which?
      big.ad.should == 'BigDecimal("2010.4")'
      big.ad.should == "2010.4"
    end
    
    it "should present Rational object as Float scalar" do
      rat = Rational(2010, 2)
      
      # @TODO: which?
      rat.ad.should == "Rational(2010, 2)"
      rat.ad.should == "1005.0"
    end
  end
  
  #------------------------------------------------------------------------------
  describe "Utility methods" do
    it "should merge options" do
      ad = AwesomeDump.new
      ad.send(:merge_options!, { :color => { :array => :black }, :indent => 0 })
      options = ad.instance_variable_get("@options")
      options[:color][:array].should == :black
      options[:indent].should == 0
    end
  end
  
  
  #------------------------------------------------------------------------------
  describe "Struct" do
    before(:each) do
      @struct = unless defined?(Struct::SimpleStruct)
        Struct.new('SimpleStruct', :name, :address).new
      else
        Struct::SimpleStruct.new
      end
      @struct.name = 'Herman Munster'
      @struct.address = '1313 Mockingbird Lane'
    end
    
    it "empty struct" do
      Struct.new('EmptyStruct').ad.should ==  "Struct::EmptyStruct < Struct"
    end
    
    it "default" do
      d = {:address => '1313 Mockingbird Lane', :name => 'Herman Munster'}
      @struct.ad.should == d
    end
    
    it "safe-escaped" do
      d = {':address' => '1313 Mockingbird Lane', ':name' => 'Herman Munster'}
      @struct.ad(:escape => :safe).should == d
    end
    
    it "quote-escaped" do
      d = {':address' => '1313 Mockingbird Lane', ':name' => 'Herman Munster'}
      @struct.ad(:escape => :quote).should == d
    end
  end
  
  
end
