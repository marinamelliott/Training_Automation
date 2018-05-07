When /^the user (check|uncheck)s (.*)$/ do |action, check_boxes|
  check_boxes.split(", ").each do |check_box|
    @current_page.enter_element_value(check_box, action)
  end
end

When /^the user (?:selects|fills in) "(.+)" for (.+)$/ do |value, page_element|
  @current_page.enter_element_value(page_element, value)
end

When /^the user (?:fills|modifies) the (?:.+) page(?: (?:with|for|where) (.*))?$/ do |locator|

  if locator.nil?
    @current_page.instantiate_page_data_object()
  else
    @current_page.instantiate_page_data_object(locator.upcase.gsub(" ", "_"))
  end

  @current_page.fill_all_form_data()
  @sbd.fill_step_hash[@current_page.class.to_s] = true
end

When /^the user views the page(?: again)?$/ do
  sleep 4
end

When /^the user selects the (\d)(?:st|nd|rd|th)? (.*) radio button$/ do |index, page_element|
  index_option = index.to_i - 1
  radio_button_name =  @current_page.send(page_element.downcase.gsub(" ", "_")+ "_element").attribute("name")
  @browser.radio(:name => "#{radio_button_name}", :index => index_option).set
end

When /^the user selects the (\d+)(?:st|nd|rd|th) option from the (.*)$/ do |index, field_name|
  Watir::Wait.until{ @current_page.send(field_name.downcase.gsub(" ", "_")+ "_element").visible? }
  @current_page.enter_element_value(field_name.downcase.gsub(" ", "_"), @current_page.send(field_name.downcase.gsub(" ", "_") + "_element").options[index.to_i].text)
end

When /^the user presses the (.*) keyboard key$/ do |key|
  begin
    @browser.send_keys(key.to_sym)
  rescue => e
    p e.to_s
    p "Invalid key!"
  end
end

When /^the user enters "(.*)"$/ do |string|
  begin
    @browser.send_keys(string)
  rescue => e
    p e.to_s
    p "Invalid string!"
  end
end


