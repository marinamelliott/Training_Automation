When /^the (.*) value (?:defaults to|is)( not)? (.*)$/ do |page_element, is_not, value|
  field_type = @current_page.send((page_element.gsub(" ","_") + "_element").downcase).class.to_s
  expectation = (is_not.nil? ? be_true : be_false)
  case field_type
    when /radio/i
      @current_page.send((page_element + "_#{value}_radio_selected?").downcase.gsub(" ","_")).should expectation
    else
      value = (value == "blank" ? "" : value)
      (@current_page.send(page_element.gsub(" ","_").downcase).strip == value).should expectation
  end
end

When /^the field values are correct for (.*)$/ do |locator|
  @current_page.class.data_class.get_expected_data(locator).each do |page_element, expected_value|
    next if expected_value.nil?
    field_type = @current_page.send((page_element.gsub(" ","_") + "_element").downcase).class.to_s

    if (expected_value =~ /^\s*lambda/i) != nil
      expected_value = eval(expected_value).call(@sbd)
    end

    case field_type
      when /radio/i
        @current_page.send((page_element + "_#{expected_value}_selected?").gsub(" ","_").downcase).should be_true
      when /checkbox/i
        @current_page.send((page_element + "_checked?").gsub(" ","_").downcase).should(expected_value == "check" ? be_true : be_false)
      when /label/i
        parent_node = @current_page.send(page_element.gsub(" ","_").downcase + "_element").parent

        #If not a checkbox label nor radio button label, what label is it? This should error in this case
        if parent_node.element.checkbox.exists?
          parent_node.element.checkbox.checked?.should(expected_value == "check" ? be_true : be_false)
        elsif parent_node.radio.exists?
          if expected_value == "nil" or expected_value == ""
            step "the #{page_element} radio group has no selection"
          else
            @current_page.send((page_element + "_#{expected_value}_radio_selected?").gsub(" ","_").downcase).should be_true
          end
        else
          raise "Label associated with unexpected field type. Check the expected key/value"
        end
      else #assume straight up text comparison for text field or select list
        actual_data = @current_page.send(page_element.gsub(" ","_").downcase).strip
        (actual_data == expected_value).should be_true, page_element.to_s + "\nexpected #{actual_data} to be #{expected_value}"
    end
  end
end

When /^the (.*) radio group (has a|has no) selection$/ do |page_element, expectation|
  @current_page.radio_list_for_group(page_element).inject(0) { |sum, radio|
    sum += 1 if radio.set?
    sum
  }.should == (expectation == "has a" ? 1 : 0)
end

When /^the (.+) checkbox is (checked|unchecked|disabled|enabled)$/ do |checkbox_name, checkbox_status|
  @current_page.verify_checkbox_status(checkbox_name.gsub(" ", "_").downcase, checkbox_status).should be_true
end

When /^the page (displays|does not display) the (.*) (?:field|dialog|element|section|checkbox)$/ do |expectation, field|
  (@current_page.send(field.gsub(" ","_").downcase + "_element").exists? and
      @current_page.send(field.gsub(" ","_").downcase + "_element").visible?).should(expectation == "displays" ? be_true : be_false)
end

When /^the (select list|radio group) values for (.*) are correct(?: (?:for the |for )?(.+))?$/ do |field_type, field, condition|
  pick_list_key_for_yml = ( condition.nil? ? field : "#{condition}_#{field}").gsub(" ","_").upcase
  field_name = field.downcase.gsub(" ", "_")

  case field_type
    when "select list"
      expected_pick_list_values = @current_page.class.data_class.get_pick_list_values(pick_list_key_for_yml)
      actual_field_values = nil
      keep_trying_to_set(5) {
        actual_field_values = @current_page.send(field_name + "_element").element.elements.map{|option| (option.class.to_s == "String" ? option.strip : option.text.strip) }
      }
    when "radio group"
      expected_pick_list_values = @current_page.class.data_class.get_radio_group_values(pick_list_key_for_yml)
      actual_field_values = @current_page.labels_from_radio_group(field_name)
    else
      raise "Field type not supported in this step definition"
  end
  actual_field_values.should == expected_pick_list_values
end

When /^the page (displays|does not display) the following (?:element|field)(?:s)?(?: as (enabled|disabled))?:$/ do |expectation, status, table_of_fields|
  table_of_fields.raw.flatten.each do |field|
    p field
    field_type = @current_page.send((field.gsub(" ","_") + "_element").downcase).class.to_s
    if field_type =~ /select/i
      @current_page.send(field.gsub(" ","_").downcase + "_element").exists?
    else
      (@current_page.send(field.gsub(" ","_").downcase + "_element").exists? and
          @current_page.send(field.gsub(" ","_").downcase + "_element").visible?).should(expectation == "displays" ? be_true : be_false)
      @current_page.send(field.gsub(" ","_").downcase + "_element").enabled?.should(status == "enabled" ? be_true : be_false) unless status.nil?
    end
  end
end

When /^the (error message|warning message|success message|text) for (.+) is (not )?displayed(?: (?:in|as) the (.*))?$/ do |message_type, message_key, not_displayed, area|
  sleep 1
  message = case message_type
              when "error message"
                @current_page.class.data_class.get_error_message(message_key)
              when "warning message"
                @current_page.class.data_class.get_warning_message(message_key)
              when "success message"
                @current_page.class.data_class.get_success_message(message_key)
              when "text"
                @current_page.class.data_class.get_text_message(message_key)
            end
  message.gsub!(/\s+/, " ")
  candidate_text = if area
                     if @current_page.send(area.gsub(" ","_").downcase + "_element").exists?
                       @current_page.send(area.gsub(" ","_").downcase + "_element").text.gsub(/\s+/, " ").upcase
                     else
                       ""
                     end
                   else
                     @current_page.text.gsub(/\s+/, " ").upcase
                   end
  if message.length > 1 and message[0] == "/" and message[-1] == "/"
    if not_displayed
      candidate_text.should_not =~ /#{message[1,message.length-2]}/i
    else
      candidate_text.should =~ /#{message[1,message.length-2]}/i
    end
  else
    candidate_text.index(message.upcase).nil?.should( not_displayed.nil? ? be_false : be_true)
  end

end

When /^the (title|url) of the(?: new)? browser window (?:is|contains) (.*)$/ do |title_or_url,expected|
  Watir::Wait.until(timeout: 10) {@browser.title =~ Regexp.new(expected) or @browser.url =~ Regexp.new(expected)}
  if title_or_url == "url"
    @browser.url.should =~ Regexp.new(expected)
  else
    @browser.title.should =~ Regexp.new(expected)
  end
end

When /^the (.+) (?:button|drop down|text field) is (disabled|enabled)$/ do |element_name, element_status|
  @current_page.verify_element_status(element_name.gsub(" ", "_").downcase, element_status).should be_true
end

When /^an alert box opens with the text for (.*)$/ do |message_key|
  Watir::Wait.until(timeout: 10) {@browser.alert.exists?}
  message = @current_page.class.data_class.get_text_message(message_key)
  @browser.alert.text.upcase.include?(message.upcase).should be_true
end

Then(/^the user updates the date from (.*) to fill in (.*)$/) do |element1, element2|
  captured_date = @current_page.send(element1.gsub(" ","_").downcase + "_element").value
  modified_date = Time.strptime(captured_date, "%m/%d/%Y") - (3*24*60*60)
  modified_date = modified_date.strftime("%m/%d/%Y")
  step "the user fills in \"#{modified_date}\" for #{element2}"
end