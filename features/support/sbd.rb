require "watir-webdriver"
include Selenium
PageObject.javascript_framework = :jquery

class SBD
  attr_accessor :browser,
                :fill_step_hash,
                :current_user,
                :current_page,
                :ie

  # Name: initialize
  # Input: No input is needed.
  # Purpose: Initializes the webdriver using the correct settings

  def initialize
    self.create_browser
    self.set_browser_experience
    page_object_array = []
    Dir["#{File.dirname(__FILE__)}/../pages/*.rb"].each { |f|
      page_name = f.gsub(/(.*\/)/, "").gsub(".rb","").split("_").collect { |a| (a =~ /SBD\b/i ? a.upcase : a.capitalize ) }.join("")
      page_object_array.push(page_name)
    }
    self.fill_step_hash = {}
    page_object_array.each{|x| self.fill_step_hash[x] = false}

    if DataHelper.environment_browser_type.downcase == "ie" then
      self.ie = true
    end

  end

  def create_browser
    environment_browser_type == 'chrome' ? (self.browser = Watir::Browser.new environment_browser_type.downcase.to_sym, :switches => ["--disable-extensions"]) :
      (self.browser = Watir::Browser.new environment_browser_type.downcase.to_sym)
  end

  def set_browser_experience()
    screen_width = self.browser.execute_script("return screen.width;")
    screen_height = self.browser.execute_script("return screen.height;") - 30

    browser_sizes = {
        "desktop" => [screen_width,screen_height],
        "tablet" => [775,screen_height],
        "mobile" => [400,screen_height]
    }
    raise "Unknown browser_size:'#{ENV["browser_size"]}'" if ENV["browser_size"] and browser_sizes[ENV["browser_size"]].nil?
    width, height = browser_sizes[ENV["browser_size"].nil? ? "desktop" : ENV["browser_size"].downcase]
    self.browser.window.resize_to(width, height)
    self.browser.window.move_to(0,0)
  end

  # Name: return_page_load_state
  # Input: No input is needed.
  # Purpose: It waits until the page is fully loaded, main purpose is for Internet Explorer
  def return_page_load_state()
    @browser.execute_script("return document.readyState") == "complete" ? true : false
  end
end