require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Shortly" do
  
  #tests for client googl
  describe "Googl" do
    before(:all) do
      @long_url = "http://bagwanpankaj.com/"
      @invalid_url = "bagwanpankaj.com"
      @short_url = "http://goo.gl/17pbM"
      @googl = Shortly::Clients::Googl
      @uri = @googl.base_uri + @googl.send(:relative_path)
    end
    
    it ".shorten" do
      mock_request_for(@uri, :method => :post, :fixture => "googl_shorten")
      res = @googl.shorten(@long_url)
      res.shortUrl.should_not be_empty
      res.shortUrl.should == @short_url
    end
    
    it ".shorten should respond_with OpenStruct" do
      res = @googl.shorten(@long_url)
      res.should be_an_instance_of(OpenStruct)
    end
    
    it ".expand" do
      mock_request_for(@uri + "?shortUrl=#{CGI.escape(@short_url)}", :method => :get, :fixture => "googl_expand")
      res = @googl.expand(@short_url)
      res.longUrl.should_not be_empty
      res.longUrl.should == @long_url
    end
    
    it ".expand should respond_with OpenStruct" do
      res = @googl.expand(@short_url)
      res.should be_an_instance_of(OpenStruct)
    end
    
    it ".analytics" do
      mock_request_for(@uri + "?shortUrl=#{CGI.escape(@short_url)}&projection=FULL",
        :fixture => "googl_analytics")
      
      res = @googl.analytics(@short_url)
      res.analytics.should_not be_empty
      res.analytics.should be_an_instance_of(Hash)
      res.analytics["week"].should be_an_instance_of(Hash)
      res.analytics["day"].should be_an_instance_of(Hash)
    end
    
    it "InvalidURIError" do
      lambda do
        @googl.shorten(@invalid_url)
      end.should raise_error(Shortly::Errors::InvalidURIError)
    end
    
  end
  
  #tests for client isgd
  describe "Isgd" do
    before(:all) do
      @isgd = Shortly::Clients::Isgd
      @long_url = "http://bagwanpankaj.com"
      @shorturl = "http://is.gd/bs9smw"
      @invalid_url = "bagwanpankaj.com"
      @uri = @isgd.base_uri
    end
    
    it ".shorten" do
      mock_request_for(@uri + "/create.php?url=#{CGI.escape(@long_url)}&format=json",
        :fixture => "isgd_shorten")
      
      res = @isgd.shorten(@long_url)
      res.shorturl.should_not be_empty
      res.shorturl.should == @shorturl
    end
    
    it ".shorten should respond_with OpenStruct" do
      res = @isgd.shorten(@long_url)
      res.should be_an_instance_of(OpenStruct)
    end
    
    it "InvalidURIError" do
      lambda do
        @isgd.shorten(@invalid_url)
      end.should raise_error(Shortly::Errors::InvalidURIError)
    end
    
    it "MethodNotAvailableError" do
      lambda do
        @isgd.expand(@long_url)
      end.should raise_error(Shortly::Errors::MethodNotAvailableError)
    end
  end
  
  #tests for client vgd
  describe "Vgd" do
    before(:all) do
      @vgd = Shortly::Clients::Vgd
      @long_url = "http://bagwanpankaj.com"
      @invalid_url = "bagwanpankaj.com"
      @uri = @vgd.base_uri
    end
  
    it ".shorten" do
      mock_request_for(@uri + "/create.php?url=#{CGI.escape(@long_url)}&format=json", 
      :fixture => "vgd_shorten")
     
      res = @vgd.shorten(@long_url)
      res.shorturl.should_not be_empty
      res.shorturl.should == @vgd.shorten(@long_url).shorturl
    end
  
    it ".shorten should respond_with OpenStruct" do
      res = @vgd.shorten(@long_url)
      res.should be_an_instance_of(OpenStruct)
    end
  
    it "InvalidURIError" do
      lambda do
        @vgd.shorten(@invalid_url)
      end.should raise_error(Shortly::Errors::InvalidURIError)
    end
  
    it "MethodNotAvailableError" do
      lambda do
        @vgd.expand(@long_url)
      end.should raise_error(Shortly::Errors::MethodNotAvailableError)
    end
  end
  
  #tests for client bitly
  describe "Bitly" do
    
    before(:all) do
      @bitly = Shortly::Clients::Bitly
      @bitly.login = "TEST_LOGIN"
      @bitly.apiKey = "R_TEST_API_KEY"
      @long_url = "http://bagwanpankaj.com"
      @invalid_url = "bagwanpankaj.com"
      @short_url = "http://bit.ly/dUdiIJ"
      @uri = @bitly.base_uri + "/v3"
    end
    
    it ".shorten" do
      mock_request_for(@uri + "/shorten?longUrl=#{CGI.escape(@long_url)}&format=json&login=#{@bitly.login}&apiKey=#{@bitly.apiKey}", 
       :fixture => "bitly_shorten")
       
      res = @bitly.shorten(@long_url)
      res.url.should_not be_empty
      res.url.should == @short_url
    end
    
    it ".shorten should respond_with OpenStruct" do
      res = @bitly.shorten(@long_url)
      res.should be_an_instance_of(OpenStruct)
    end
    
    it "InvalidURIError" do
      lambda do
        @bitly.shorten(@invalid_url)
      end.should raise_error(Shortly::Errors::InvalidURIError)
    end
    
    it ".expand" do
      mock_request_for(@uri + "/expand?shortUrl=#{CGI.escape(@short_url)}&format=json&login=#{@bitly.login}&apiKey=#{@bitly.apiKey}", 
       :fixture => "bitly_expand")
       
      res = @bitly.expand("http://bit.ly/dUdiIJ")
      res.long_url.should == @long_url
    end
    
  end
  
  #tests for client jmp
  describe "Jmp" do
    
    before(:all) do
      @jmp = Shortly::Clients::Jmp
      @jmp.login = "TEST_LOGIN"
      @jmp.apiKey = "R_TEST_API_KEY"
      @long_url = "http://bagwanpankaj.com"
      @invalid_url = "bagwanpankaj.com"
      @short_url = "http://j.mp/dUdiIJ"
      @uri = @jmp.base_uri + '/v3'
    end
    
    it ".shorten" do
      mock_request_for(@uri + "/shorten?longUrl=#{CGI.escape(@long_url)}&format=json&login=#{@jmp.login}&apiKey=#{@jmp.apiKey}", 
       :fixture => "jmp_shorten")
       
      res = @jmp.shorten(@long_url)
      res.url.should_not be_empty
      res.url.should == @short_url
    end
    
    it ".shorten should respond_with OpenStruct" do
      res = @jmp.shorten(@long_url)
      res.should be_an_instance_of(OpenStruct)
    end
    
    it "InvalidURIError" do
      lambda do
        @jmp.shorten(@invalid_url)
      end.should raise_error(Shortly::Errors::InvalidURIError)
    end
    
    it ".expand" do
      mock_request_for(@uri + "/expand?shortUrl=#{CGI.escape(@short_url)}&format=json&login=#{@jmp.login}&apiKey=#{@jmp.apiKey}", 
       :fixture => "jmp_expand")
       
      res = @jmp.expand(@short_url)
      res.long_url.should == @long_url
    end
    
  end
  
  #tests for client tinyurl
  describe "TinyUrl" do
    before(:all) do
      @long_url = "http://bagwanpankaj.com"
      @invalid_url = "bagwanpankaj.com"
      @uri = Shortly::Clients::Tinyurl.base_uri
    end
    
    it ".shorten" do
      mock_request_for(@uri + "/api-create.php", :method => :post,
       :fixture => "tinyurl_shorten", :content_type => "text/plain")
       
      res = Shortly::Clients::Tinyurl.shorten(@long_url)
      res.shorturl.should_not be_empty
      res.shorturl.should == "http://tinyurl.com/6jt3pjr"
    end
    
    it ".shorten should respond_with OpenStruct" do
      res = Shortly::Clients::Tinyurl.shorten(@long_url)
      res.should be_an_instance_of(OpenStruct)
    end
    
    it "InvalidURIError" do
      lambda do
        Shortly::Clients::Tinyurl.shorten(@invalid_url)
      end.should raise_error(Shortly::Errors::InvalidURIError)
    end
    
    it "should raise MethodNotAvailableError" do
      lambda do
        Shortly::Clients::Tinyurl.expand(@long_url)
      end.should raise_error(Shortly::Errors::MethodNotAvailableError)
    end
  end
  
  #tests for client ShortSwitch
  describe "ShortSwitch" do
    
    before(:all) do
      @ss = Shortly::Clients::ShortSwitch
      Shortly::Clients::ShortSwitch.apiKey = "TESTKEY"
      @long_url = "http://bagwanpankaj.com"
      @invalid_url = "bagwanpankaj.com"
      @short_url = "http://demo.shortswitch.com/t"
      @uri = @ss.base_uri
    end

    it ".shorten" do
      mock_request_for(@uri + "/shorten?longUrl=#{CGI.escape(@long_url)}&format=json&apiKey=TESTKEY",
       :fixture => "shortswitch_shorten")
    
      res = Shortly::Clients::ShortSwitch.shorten(@long_url)
      res.shortUrl.should_not be_empty
      res.shortUrl.should == @short_url
    end
    
    it ".shorten should respond_with OpenStruct" do
      res = Shortly::Clients::ShortSwitch.shorten(@long_url)
      res.should be_an_instance_of(OpenStruct)
    end
    
    it "InvalidURIError" do
      lambda do
        Shortly::Clients::ShortSwitch.shorten(@invalid_url)
      end.should raise_error(Shortly::Errors::InvalidURIError)
    end
    
  end
  
  #tests for client sn.im
  describe "Snim" do
    before(:all) do
      @snim = Shortly::Clients::Snim
      @snim.apiKey = "TESTKEY"
      @snim.login = "TESTER"
      @long_url = "http://bagwanpankaj.com/"
      @invalid_url = "bagwanpankaj.com"
      @short_url = "http://sn.im/1wvkof"
      @uri = @snim.base_uri
    end
    
    it ".shorten" do
      mock_request_for(@uri + "/getsnip", :method => :post,
       :fixture => "snim_shorten")
    
      res = @snim.shorten(@long_url)
      res.shortUrl.should_not be_empty
      res.shortUrl.should == @short_url
    end
    
    it ".analytics" do
      mock_request_for(@uri + "/getsnipdetails", :method => :post,
       :fixture => "snim_analytics")
    
      res = @snim.analytics("1wvkof")
      res.url.should_not be_empty
      res.clicks.should_not be_nil
      res.clicks.should == 10000
    end
    
    it ".expand" do
      mock_request_for(@uri + "/getsnipdetails", :method => :post,
       :fixture => "snim_analytics")
    
      res = @snim.expand(@short_url)
      res.url.should_not be_empty
      res.url.should == @long_url
    end
  end
  
  describe "Client" do
    
    before(:all) do
      @valid_uri = "http://bagwanpankaj.com"
      @invalid_uri = "someinveliduri" 
    end
    
    it "includes HTTParty" do
      Shortly::Client.included_modules.should include HTTParty
    end
    
    it "includes Shortly::Errors" do
      Shortly::Client.included_modules.should include Shortly::Errors
    end
    
    it "includes Shortly::Helper" do
      Shortly::Client.included_modules.should include Shortly::Helper
    end
    
    it ":@@registered" do
      Shortly::Client.class_variables.should include :"@@registered"
    end
    
    it ".register/.valid_uri?/.registered" do
      Shortly::Client.should respond_to :register!
      Shortly::Client.should respond_to :registered
      Shortly::Client.should respond_to :valid_uri?
    end
    
    it ".valid_uri" do
      Shortly::Client.valid_uri?(@valid_uri).should be true
      Shortly::Client.valid_uri?(@invalid_uri).should_not be true
    end
    
  end
  
  describe "Misc" do
    
    describe "Errors" do
      
      it "CustomErrors" do
        Shortly::Errors::ShortlyError.superclass.name.should == "StandardError"
        Shortly::Errors::ShortlyArgumentError.superclass.name.should == "ArgumentError"
        Shortly::Errors::InvalidURIError.superclass.name.should == "Shortly::Errors::ShortlyError"
        Shortly::Errors::NotAuthorizedError.superclass.name.should == "Shortly::Errors::ShortlyArgumentError"
        Shortly::Errors::MethodNotAvailableError.superclass.name.should == "Shortly::Errors::ShortlyError"
      end
      
    end
    
    describe "Shortly" do
      it ".version" do
        Shortly.version.should == File.read(File.join(File.dirname(__FILE__), '..', 'VERSION'))
      end
      
      it ".active_services" do
        Shortly.active_services.should == Shortly::Client.registered
      end
      
    end
  end
  
end
