require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


require 'logger'
require 'ad/core_ext/logger'

describe "AwesomeDump logging extensions" do
  before(:all) do
    @logger = Logger.new('/dev/null')
  end

  describe "ad method" do
    it "should awesome_inspect the given object" do
      object = mock
      object.should_receive(:ai)
      @logger.ad object
    end
    
    describe "the log level" do
      before(:each) do
        AwesomeDump.defaults = { }
      end
      
      it "should fallback to the default :debug log level" do
        @logger.should_receive(:debug)
        @logger.ad(nil)
      end

      it "should use the global user default if no level passed" do
        AwesomeDump.defaults = { :log_level => :info }
        @logger.should_receive(:info)
        @logger.ad(nil)
      end

      it "should use the passed in level" do
        @logger.should_receive(:warn)
        @logger.ad(nil, :warn)
      end
    end
  end
end


