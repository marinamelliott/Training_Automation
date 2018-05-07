When /^the user navigates to the example1 testing website$/ do
  visit_page(Example1TestingPage)
  sleep 1
  step "the application navigates to the example1 testing page"
end

When /^the user navigates to the example2 testing website$/ do
  visit_page(Example2TestingPage)
  sleep 1
  step "the application navigates to the example2 testing page"
end

When /^(?:a|the) user navigates to the Kforce website$/ do
  visit_page(KforcePage)
  step "the application navigates to the Kforce page"
end

When /^(?:a|the) user navigates to the JJ website$/ do
  visit_page(JimmyJohnsPage)
  step "the application navigates to the Jimmy Johns page"
end

When /^(?:a|the) user navigates to the Target website$/ do
  visit_page(TargetHomePage)
  step "the application navigates to the Target Home page"
end

When /^the user closes the last browser window$/ do
  begin
    @browser.windows.last.use.close
  rescue Exception => e
    p e if verbose_messages
  ensure
    @browser.windows.use
  end
end

When /^the user switches windows$/ do
  p @browser.windows.length
  p @browser.windows.first
  p @browser.windows.last
  @browser.window(:url => /salesforce/).use
end

When /^the application (?:navigates to|remains on) the (.+?(?: or .+?)*?) page$/ do |page_names|
  application_is_on_page?(page_names).should be_true
end

When /^the user clicks(?: the| a)? (.+)$/ do |page_element|
  Watir::Wait.until(timeout: 10) {@current_page.send(page_element.gsub(" ","_").downcase + "_element").exists?}
  field_type = @current_page.send(page_element.gsub(" ","_").downcase + "_element").class.to_s
  if field_type =~ /link|button/i
    @current_page.send(page_element.gsub(" ","_").downcase)
  else
    @current_page.send(page_element.gsub(" ","_").downcase + "_element").click
  end
end

When /^take a screenshot( after closing the dialog window)?$/ do |close_modal|
  @browser.windows.last.use

  output_folder = (ENV["output_folder"] || "features/output") + "/" + ENV['TIMESTAMP'][0,10]
  scenario_folder = output_folder + '/' + 'success screenshots' + '/'
  screenshot_file = scenario_folder + Time.now.strftime("%Y-%m-%d_%H-%M-%S") + ".png"
  current_path = ''

  screenshot_file.split(/\//).map{|m| m.split(/\\/)}.flatten.each {|folder|
    next if folder =~ /\.png/
    current_path += folder + "/"
    next if folder.downcase =~ /:/
    Dir.mkdir(current_path) unless File.exists?(current_path )
  }

  @browser.screenshot.save screenshot_file
  embed screenshot_file, 'image/png'
end

When /^a new browser window opens$/ do
  @browser.windows.last.use
end

When /^the user (confirms|cancels) on the alert box$/ do |action|
  Watir::Wait.until(timeout: 10) {@browser.alert.exists?}
  if action == "confirms"
    @browser.alert.ok
  else
    @browser.alert.close
  end
end

When /^the user waits until(?: the| a)? (.+) element is displayed$/ do |page_element|
  Watir::Wait.until(timeout: 10) {@current_page.send(page_element.gsub(" ","_").downcase + "_element").exists?}
end

When /^the user uploads the file for (.+?)$/ do |message_key|
  message_key = message_key.gsub(" ", "_").upcase
  file_path = @current_page.class.data_class.get_input_data(message_key)["FILE_PATH"]
  @current_page.file_upload(file_path)
end

When /^the user drags (.+) and drops on (.+)$/ do |element1, element2|
  @current_page.send(element1.gsub(" ","_").downcase + "_element").drag_and_drop_on @current_page.send(element2.gsub(" ","_").downcase + "_element")
end

When /^the user opens the email with the following subject:$/ do |subject|
  subject.raw.flatten.each do |subject|
    @browser.div(:text => subject, :index => 0).when_present.click
  end
end

When /^the user captures the verification code$/ do
  email = @current_page.email_body_element.text
  find_verification_code = email.match(/Verification Code: \d{5}/)[0]
  SalesforceVerifyIdentityPage.save_verification_code(find_verification_code[-5..-1])
end

When /^the user opens a new browser$/ do
  keep_trying_to_set(2){
    p 'opening a new browser'
    @browser = @sbd.create_browser
  }
  @browser.windows.last.use
end
