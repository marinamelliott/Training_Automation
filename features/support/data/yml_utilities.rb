# Name of the module:  YmlUtilities
# Purpose: This module consists of following definitions: get_data_from_yml_file.

module YmlUtilities

  # Name: get_data_from_yml_file
  # Input: String (file path where the data is located)
  # Purpose: Returns the data in the file path given.

  def get_data_from_yml_file(file_path)
    begin
      #To use dynamic data, put the ruby to be evaluated within <%=  %>, ie
      # <%= 5+3 %>
      YAML.load(ERB.new(File.read(File.dirname(__FILE__) + "/data_source/" + file_path)).result) || Hash.new( {} )
    rescue Errno::ENOENT => e
      Hash.new({})
    end
  end

  # Name: single_value_helper
  # Input: Array (array of values, can be empty)
  #        Value - the default value that will be used in case no parameters are in the array
  #        Match - regexp that will be used to extract the value; if the match is nil, the default will be used instead

  def single_value_helper(params, match, default)
    params[:param_string] =~ match
    value = $1 ? $1 : default
    p "HERE:"
    p params
    p value
    value =~ /blank/i ? "" : value
  end

  def yes_no_blank_helper(params)
    case params
      when /^NOT?/i
        "No"
      when /^BLANK/i
        ""
      else
        "Yes"
    end
  end

  def get_value_from_list_of_keys(h, keys)
    [keys].flatten.inject(h) {|search_hash, key| search_hash[key] || {} }
  end

  # Name: include
  # Input: String (file path where the data is located)
  # Purpose: Returns the data in the file path given. Main use is to import yaml data into other yaml files.

  def self.include(file_path)
    begin
      ERB.new(IO.read(File.dirname(__FILE__) + file_path)).result
    rescue Errno::ENOENT => e
      p e.to_s
    end
  end

end

World YmlUtilities
