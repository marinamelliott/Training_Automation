class SBDData
  include YmlUtilities

  # Name: set_bol_object
  # Input: String (data value)
  # Purpose: Work around for exposing @bol for use in data YML

  def self.set_sbd_object(sbd)
    @@sbd = sbd
  end

  # Name: retrieve_data_for
  # Input: String (data value)
  # Purpose: Returns the data value for the page

  def retrieve_data_for(data_value)
    @data[data_value.gsub(" ","_").upcase]
  end

  # Name: override_data_for
  # Input: String (name of the data class), String (value to be overridden)
  # Purpose: Overrides the current data value with the given value

  def override_data_for(data_value, override_value)
    @data[data_value.gsub(" ","_").upcase] = override_value
  end

  # Name: initialize
  # Input: String (e.g.- default data for the page)
  # Purpose: Initializes the data for the page based on the data in the yml file

  def initialize(data = self.class.default_data, default_number = nil, fixed_field_offsets = [])
    if self.class.does_old_data_key_exist?(data.gsub(" ","_").upcase)
      @data = merged_with_default("input_data/" + self.class.file_name, data.gsub(" ","_").upcase)

      @data.keys.each do |key|
        next unless @data[key] =~ /^\s*lambda/i
        @data[key] = eval(@data[key]).call(@@sbd)
      end
    else
      data = data.gsub(" ", "_").upcase

      input_collection = (merged_with_default("input_data/" + self.class.file_name).keys.include?("DEFAULTS") ?
          merged_with_default("input_data/" + self.class.file_name, ["DEFAULTS", default_number.to_i], false).clone :
          {} )

      mandatory = (get_value_from_list_of_keys(get_data_from_yml_file("future_merging_functionality/" + "input_data/" + self.class.file_name), "MANDATORY") || {} )

      input_collection.merge!(mandatory)

      repeatable_fields = merged_with_default("input_data/" + self.class.file_name, "REPEATABLE_FIELD_SETS", false)

      matched_fields = []
      matched_inputs = {}

      repeatable_defaults = input_collection.select{ |key| key =~ /(_X$|_X_|X_)/ }
      input_collection = input_collection.select{ |key| key !~ /(_X$|_X_|X_)/ }

      fixed_field_offsets.each { |field, offset_by|
        repeatable_fields[field.upcase.gsub(" ","_")].each{|repeating_field|
          (offset_by.to_i - 1).times {
            matched_fields << repeating_field
          }
        }
      }

      page_input_keys = self.class.subkey_sort(merged_with_default("input_data/" + self.class.file_name, "INPUT_OPTIONS", false))

      page_input_keys.each do |input_option, fill_values|
        input_regexp = Regexp.compile("(" + input_option + ")","i")

        if data =~ input_regexp
          matched_string = $1

          matched_inputs.merge! data.index(matched_string) => [repeatable_defaults.merge( fill_values ), matched_string]

          data.sub! input_regexp, "*" * matched_string.length
          redo
        end
      end

      #ensure fields get entered in the order specified in the data
      matched_inputs.sort.each do |index, fill_values_and_matched_string|
        fill_values, matched_string = fill_values_and_matched_string
        fill_values.each do |field, value|
          matched_fields << field.clone
          field_count = nil
          p "replacing:"
          p field
          if field =~ /(_X$|_X_|X_)/
            field_offset = $1
            field_count = matched_fields.count(field)
            field = field.sub(field_offset, "#{field_offset.clone.sub("X", "#{field_count}")}")
          end
          p field
          p value
          input_collection.merge! field => ( value =~ /^lambda/ ?
                                             [value, matched_string, field_count] :
                                             value )
        end
      end

      @data = input_collection
    end
    if @data.size == 0
      raise "Data set is empty!"
    end
    @data
  end

  # Name: size
  # Input: None
  # Purpose: Returns the number of data elements

  def size
    @data.size
  end

  # Name: size_excluding_mandatory
  # Input: None
  # Purpose: Returns the number of data elements excluding mandatory fields

  def size_excluding_mandatory
    @data.size - @mandatory_fields.size
  end

  # Name: contains_all_the_fields
  # Input: List of fields
  # Return: True if all the fields exist in the data set, and all fields have non nil associated values

  def contains_all_the_fields(*fields)
    ( fields - @data.select{ |key| @data[key] }.keys ).size == 0
  end

  # Name: combine_fields_into
  # Input: target_field - upcase and with underscores in place of spaces, the field the other fields will be combined into
  #        delimiter - ("" is valid) character or string separating the fields (ie, "/" in case of birthday)
  #        fields - List of fields to combine, the will be combined in the order listed
  # Return: True if all the fields exist in the data set, and all fields have non nil associated values

  def combine_fields_into(target_field, delimiter, *fields)
    @data[target_field] = fields.map{ |f|
      value = @data[f]
      value = eval(@data[f][0]).call(:param_string => @data[f][1], :com => @@com) if @data[f][0] =~ /^\s*lambda/i
      @data.delete f
      value }.join delimiter
  end

  # Name: get_expected_data
  # Input: String (name of the data class), String (key for the data in the yml), Boolean (Error if key was not found)
  # Purpose: Gets the database expected value from the yml file.

  def self.get_expected_data(data_key, message_key = nil, error_on_no_data = true)
    data = merged_with_default("expected_data/" + self.file_name, data_key.gsub(" ","_").upcase, error_on_no_data)

    if message_key
      data = data[message_key.gsub(" ","_").upcase]
    end

    if (data =~ /^\s*lambda/i) != nil
      data = eval(data).call(@@com)
    elsif data.class.to_s == "Hash"
      data.each do |key, value|
        data[key] = eval(value).call(@@com) if (value =~ /^\s*lambda/i) != nil
      end
    end
    data
  end

  # Name: get_input_data
  # Input: String (name of the data class), String (key for the data in the yml)
  # Purpose: Gets the input value from the yml file.

  def self.get_input_data(data_key, message_key = nil)
    data = merged_with_default("input_data/" + self.file_name, data_key.gsub(" ","_").upcase)

    if message_key
      data = data[message_key.gsub(" ","_").upcase]
    end

    if (data =~ /^\s*lambda/i) != nil
      data = eval(data).call(@@com)
    elsif data.class.to_s == "Hash"
      data.each do |key, value|
        data[key] = eval(value).call(@@com) if (value =~ /^\s*lambda/i) != nil
      end
    end
    data
  end

  # Name: get_error_message
  # Input: String (current page name), String (key for the message in the yml)
  # Purpose: Get the expected error message for the current page from the yml file

  def self.get_error_message(message_key)
    self.get_expected_data("ERROR_MESSAGES", message_key)
  end

  # Name: get_warning_message
  # Input: String (current page name), String (key for the message in the yml)
  # Purpose: Get the expected warning message for the current page from the yml file

  def self.get_warning_message(message_key)
    self.get_expected_data("WARNING_MESSAGES", message_key)
  end

  # Name: get_success_message
  # Input: String (current page name), String (key for the message in the yml)
  # Purpose: Get the expected warning message for the current page from the yml file

  def self.get_success_message(message_key)
    self.get_expected_data("SUCCESS_MESSAGES", message_key)
  end

  # Name: get_text_message
  # Input: String (current page name), String (key for the message in the yml)
  # Purpose: Get the expected text message for the current page from the yml file

  def self.get_text_message(message_key)
    self.get_expected_data("TEXT", message_key)
  end

  # Name: get_labels
  # Input: String (current page name), String (key for the labels in the yml)
  # Purpose: Get the expected labels for the current page from the yml file

  def self.get_labels(key)
    label_values = self.get_expected_data("LABELS", key).split(",")
    label_values.map do |value|
      value.strip
    end
  end

  # Name: get_invalid_inputs
  # Input: String (key for the invalid input field)
  # Purpose: Get the invalid input data set for a field

  def self.get_invalid_inputs(input_key)
    self.get_expected_data("INVALID_INPUT", input_key)
  end

  # Name: get_mandatory_labels
  # Input: String (current page name), String (key for the message in the yml)
  # Purpose: Get the expected mandatory labels for the current page from the yml file.
  # The mandatory key is not required, hence we pass in false.

  def self.get_mandatory_labels(key)
    label_values = self.get_expected_data("MANDATORY_LABELS", key, false) || ""
    label_values.split(",").map do |value|
      value.strip
    end
  end

  # Name: get_pick_lists
  # Input: String (pick_list_set)
  # Purpose: Gets the expected pick lists of interest on a page
  #          Returns array of arrays. In the child array, there will be one or two elements.
  #          First element will be the pick list, second element will be any conditions

  def self.get_pick_lists(pick_list_key)
    self.get_expected_data("SELECT_LIST_SETS", pick_list_key)
  end

  # Name: get_pick_list_values
  # Input: String (current page name), String (key for the pick list values in the yml)
  # Purpose: Gets the expected pick list values for the current page from the yml file.

  def self.get_pick_list_values(message_key)
    pick_list_values =  self.get_expected_data("SELECT_LISTS", message_key).split(" | ")
    pick_list_values.map! do |value|
      value.strip
    end
    pick_list_values
  end

  # Name: get_pick_list_values
  # Input: String (current page name), String (key for the pick list values in the yml)
  # Purpose: Gets the expected pick list values for the current page from the yml file.

  def self.get_radio_group_values(message_key)
    pick_list_values =  self.get_expected_data("RADIO_GROUP", message_key).split(" | ")
    pick_list_values.map! do |value|
      value.strip
    end
    pick_list_values
  end

  # Name: get_pick_list_save_values
  # Input: String (current page name), String (key for the pick list values in the yml)
  # Purpose: Gets the expected pick list save values for the current page from the yml file

  def self.get_pick_list_save_values(message_key)
    p message_key
    pick_list_save_values = self.get_expected_data("SELECT_LIST_SAVE_VALUES", message_key).split(" | ")
    pick_list_save_values.map! do |value|
      value.strip
    end
    pick_list_save_values
  end

  # Name: get_url
  # Input: String (key for the name value pair in the yml)
  # Purpose: Gets url from the yml file.

  def self.get_url(message_key)
    self.get_expected_data("URL", message_key)
  end

  # Name: get_image_url
  # Input: String (key for the name value pair in the yml)
  # Purpose: Gets image url from the yml file.

  def self.get_image_url(message_key)
    self.get_expected_data("IMAGE_URLS", message_key)
  end

  def self.does_old_data_key_exist?(locator)
    data_files = (get_data_from_yml_file("data_files/input_data/" + self.file_name)[locator] || {} )
    (data_files.size) > 0
  end

  protected
  def merged_with_default(path_to_file, key=nil, error_on_no_data=true)
    if verbose_messages
      p "DEFAULTS MERGE:"
      p key
      p self.class.merged_with_default(path_to_file, key, error_on_no_data)
      p "END OF DEFAULTS MERGE!"
    end
    self.class.merged_with_default(path_to_file, key, error_on_no_data)
  end

  def self.merged_with_default(path_to_file, key=nil, error_on_no_data=true)
    all_states = {}
    mandatory = {}
    current_state = {}
    e2e_all_state = {}
    e2e_current_state ={}

    if key
      all_states = (get_value_from_list_of_keys(get_data_from_yml_file("data_files/" + path_to_file), key) || {} )
      mandatory = (get_value_from_list_of_keys(get_data_from_yml_file("future_merging_functionality/" + path_to_file), "MANDATORY") || {} )
      current_state = (get_value_from_list_of_keys(get_data_from_yml_file("future_merging_functionality/" + path_to_file), key) || {} )
    else
      all_states = (get_data_from_yml_file("data_files/" + path_to_file) || {} )
      current_state = (get_data_from_yml_file("future_merging_functionality/" + path_to_file) || {} )
    end

    merged_data = all_states.clone.merge(mandatory){ |key, v1, v2|
          recursively_merge_hashes(key, v1, v2)
        }.merge(current_state){ |key, v1, v2|
          recursively_merge_hashes(key, v1, v2)
        }.merge(e2e_all_state){ |key, v1, v2|
          recursively_merge_hashes(key, v1, v2)
        }.merge(e2e_current_state){ |key, v1, v2|
          recursively_merge_hashes(key, v1, v2)
        }

    if error_on_no_data and (merged_data.size - mandatory.size) <= 0
      raise "No data elements found; is there a matching key in the YAML for the following key: \n#{key}"
    end

    merged_data
  end

  def self.recursively_merge_hashes(key, value1, value2)
    if value1.class == Hash and value2.class == Hash
      value1.merge(value2){|k, v1, v2| recursively_merge_hashes(k, v1, v2) }
    elsif value1.class != Hash and value2.class != Hash
      value2
    else
      raise "Both elements must either be hashes or something else! #{value1.inspect} vs #{value2.inspect}"
    end
  end

  # Name: subkey_sort
  # Input: arrayofarrays containing two elements (subkey, and hash)
  # Purpose: Sort the subkey array, giving specific subkeys priority over more generic ones that match them
  #          Only the subkey name (index 0 of the array in the array) is used to determine sort order

  def self.subkey_sort(array)
    #array should contain arrays with two elements; first element is the subkey, second is hash of values
    working_array = array.sort{ |a, b| b[0].size <=> a[0].size }

    array_size = working_array.size
    fence = 0

    while fence < array_size
      current_subkey = working_array[fence][0]
      #If subkey is a regexp, see if there are more specific subkeys that match after it
      if current_subkey.index(/[^\\][()|+]/) or current_subkey.index(/(^|[^\\])\\[a-zA-Z]/)
        temp_array = []
        pointer = fence + 1
        while pointer < array_size - temp_array.size
          if /#{Regexp.compile("^#{current_subkey}$","i")}/ =~ working_array[pointer][0]
            temp_array << working_array.delete_at(pointer)
          else
            pointer += 1
          end
        end
        working_array.insert(fence, *temp_array)
        fence += temp_array.size
      end
      fence += 1
    end
    p working_array
    p "returning"
    working_array
  end

  #This method returns the last value given a list of keys, from highest to lowest order, ie
  #["TOP","MID","BOT"]  is the list to get ":STUFF => BLAH"
  #in YML
  #TOP:
  #  MID:
  #    BOT:
  #      STUFF: "BLAH"
  # If key is just a string, converts key to an array

  def self.get_value_from_list_of_keys(h, keys)
    [keys].flatten.inject(h) {|search_hash, key| search_hash[key] || {} }
  end

end