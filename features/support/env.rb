$:.unshift File.join(File.dirname(__FILE__), "..", 'pages')

require 'page-object'
require 'page-object/page_factory'
require 'date'
require 'win32ole'

require File.dirname(__FILE__) + '/data/yml_utilities.rb'
require File.dirname(__FILE__) + '/data/data_classes/sbd_data.rb'
require File.dirname(__FILE__) + '/data/data_helper.rb'
require File.dirname(__FILE__) + '/../../features/pages/page_helper.rb'

require 'sbd_page'

ENV['TIMESTAMP'] ||= Time.now.strftime "%Y-%m-%d_%H-%M-%S"

total_passed = 0
total_failed = 0

Before do |scenario|
    $start_time = Time.now

    #ActiveRecord::Base.establish_connection(
    #        :adapter => "oracle_enhanced",
    #        :database => database_region,
    #        :username => database_login,
    #        :password => database_password)

    keep_trying_to_set(2) {
        @sbd = SBD.new()
        @browser = @sbd.browser
    }
    SBDData.set_sbd_object(@sbd)

end

After do |scenario|

  #ActiveRecord::Base.remove_connection()

  output_folder = (ENV["output_folder"] || "features/output") + "/" + ENV['TIMESTAMP'][0,10]
  scenario_folder = output_folder + '/' + 'failure screenshots' + '/'

  script_name = scenario.name

  screenshot_file = scenario_folder + script_name.gsub(/[\/\\| <>\n\r]+/, "_")[0..90] + ".png"
  current_path = ''

  if scenario.failed?
    begin
      total_failed += 1

      screenshot_file.split(/\//).map{|m| m.split(/\\/)}.flatten.each {|folder|
        next if folder =~ /\.png/
        current_path += folder + "/"
        next if folder.downcase =~ /:/
        Dir.mkdir(current_path) unless File.exists?(current_path)
      }

      @browser.screenshot.save screenshot_file
      embed screenshot_file, 'image/png'

    rescue Exception => e
      p e.message
      p "Could not capture screenshot"
    end
  else
    total_passed +=1
  end

  @sbd.browser.quit if close_browser_when_finished and @sbd.browser
end

World(PageObject::PageFactory)
