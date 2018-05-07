include DataHelper

class SBDPage
  include PageObject
  include PageHelper

  # HEADER
  link(:categories_link, :id => "categories")
  link(:clothing_button, :xpath => "//*[@id='5xtd3']/a")
  link(:womens_clothing_button, :xpath => "//*[@id='5xtcm']/a")
  link(:all_womens_clothing_button, :xpath => "/html/body/div[2]/div/div/ul/div/li[2]/a")

  text_field(:search_field, :id => "search")
  button(:go_button, :text => "go")

  span(:my_account_button, :text => "My Account")
  div( :create_account_button, :text => "Create account")

  # Name: wait_time
  # Input: No input is needed.
  # Purpose: waits for page load

  def wait_time
    sleep 3
  end

  # Name: page_title_is_correct
  # Input: No input is needed.
  # Purpose: Checks whether the page title is correct or not

  def page_title_is_correct
    # p text =~ self.class.page_title_validation_value
    ( text =~ self.class.page_title_validation_value ) !=nil
  end

  # Name: page_url_is_correct
  # Input: No input needed.
  # Purpose: Checks whether the page url is correct or not

  def page_url_is_correct
    # p current_url =~ self.class.page_url_validation_value
    ( current_url =~ self.class.page_url_validation_value ) !=nil
  end

  # Name: instantiate_page_data_object
  # Input: String (e.g.- default data)
  # Purpose: To set up an instance of page data object

  def instantiate_page_data_object(data_key = self.class.data_class.default_data)
    @fillable_form_fields = form_field_order()
    @current_page_data_object = self.class.data_class.new(data_key)
  end

  # Name: instantiate_page_data_object_using_partial_keys
  # Input: String containing partial keys
  # Purpose: To set up an instance of page data object

  def instantiate_page_data_object_using_partial_keys(partial_keys, number = nil, fixed_field_offsets = [])
    @fillable_form_fields = form_field_order()
    @current_page_data_object = self.class.data_class.new(partial_keys, number, fixed_field_offsets)
  end

  # Name: fill_all_form_data
  # Input: No input is needed.
  # Purpose: It fills all the required data fields of the form

  def fill_all_form_data()
    if verbose_messages
      p @fillable_form_fields
      p @current_page_data_object
    end

    @fillable_form_fields.each do |field|
      value = @current_page_data_object.retrieve_data_for(field)
      enter_element_value(field, value) if value and (value != "nil")
    end
  end

  # Name: enter_element_value
  # Input: String (e.g.- field), Int (e.g.- the value to enter)
  # Purpose: It enters a value to a field

  def enter_element_value(original_field, value)
    field = original_field.downcase.gsub(" ", "_")
    unless self.respond_to? field + "_element"
      warn "undefined method '#{field + '_element'}' for #{@current_page.class}"
      return
    end

    field_type = self.send(field + "_element").class.to_s

    if verbose_messages
      p field_type
      p field
      p value
    end

    if value.class.to_s == "Array"
      value = eval(value[0]).call(:param_string => value[1], :current_page => self, :repeatable_field_index => value[2])
    end

    if value =~ /^lambda/
      value = eval(value).call(:current_page => self)
    end

    formatted_value = value.to_s.downcase.gsub(" ", "_")

    p value if verbose_messages

    return if value.nil? or (value == "nil")

    keep_trying_to_set(1) do
      case field_type
        when /select/i
          Watir::Wait.until(timeout: 10) {self.send(field + "_element").exists?}
          return if self.send(field.downcase.gsub(" ", "_")) == value and value != "Please Select"
          self.send(field + "=", value)
        when /text|input/i
          Watir::Wait.until(timeout: 10) {self.send(field + "_element").exists?}
          return if self.send(field) == value and value != ""
          self.send(field + "=", value)
          self.send(field + "_element").send_keys(:tab)
        when /checkbox/i
          Watir::Wait.until(timeout: 10) {self.send(field + "_element").exists?}
          #value should be: "check" or "uncheck"
          self.send(value.downcase + "_" + field)
        when /radio/i
          Watir::Wait.until(timeout: 10) { self.send( field + "_" + formatted_value + "_element" ).exists? }
          self.send( "select_" + field + "_" + formatted_value )
        when /label/i
          if value =~ /check/
            if (value == "check" and not self.send( field + "_element" ).element.parent.checkbox.checked?) or
                (value == "uncheck" and self.send( field + "_element" ).element.parent.checkbox.checked?)
              self.send( field + "_element" ).click
            end
          else #radio button
            if ENV['browser_type'] == 'ie'
              self.send(field + "_" + formatted_value + "_element").click
            else
              self.send(field + "_" + formatted_value + "_element").focus
              self.send(field + "_" + formatted_value + "_element").fire_event "onclick"
            end
          end
        else
          raise("Unknown field type:" + field_type)
      end
    end
  end

  def get_select_list_options(select_list_name, ignore = "")
    self.send("#{select_list_name}_element").options.to_a.select {|option| option.text !~ /^(#{ignore})/i}
  end

  def radio_list_for_group(radio_label_name)
    self.send(radio_label_name.gsub(" ","_").downcase + "_element").parent.radios
  end

  def labels_from_radio_group(radio_label_name)
    p radio_label_name
    p self.send(radio_label_name.gsub(" ","_").downcase + "_element").parent.lis
    self.send(radio_label_name.gsub(" ","_").downcase + "_element").parent.lis.each{|r| p r.text}
    self.send(radio_label_name.gsub(" ","_").downcase + "_element").parent.lis.map{ |list_item| list_item.text}
  end

  # Name: verify_checkbox_status
  # Input: String (name of checkbox), String (status of the checkbox e.g. - checked)
  # Purpose: It waits until the following message: "Please wait while we are processing your request".

  def verify_checkbox_status(name, status)
    case status.upcase
      when "CHECKED"
        send("#{name}_element").parent.element.checkbox.checked?
      when "UNCHECKED"
        not send("#{name}_element").parent.element.checkbox.checked?
      when "DISABLED"
        send("#{name}_element").parent.element.checkbox.disabled?
      when "ENABLED"
        send("#{name}_element").parent.element.checkbox.enabled?
    end
  end

  # Name: verify_element_status
  # Input: String (name of element), String (status of the element e.g. - disabled)
  # Purpose: verify if an element is disabled or enabled

  def verify_element_status(name, status)
    case status.upcase
      when "DISABLED"
        send("#{name}_element").disabled?
      when "ENABLED"
        send("#{name}_element").enabled?
    end
  end

  def file_upload(file_path)
    wsh = WIN32OLE.new('Wscript.Shell')
    sleep 1
    wsh.SendKeys("#{file_path}")
    sleep 1
    wsh.SendKeys "~"
  end

end