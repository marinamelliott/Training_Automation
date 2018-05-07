include YmlUtilities

module DataHelper

  # Name: environment_url
  # Input: No input is needed.
  # Purpose: Returns the url of the environment

  def environment_url
    url = get_data_from_yml_file("environment_urls.yml")[application_environment]
    raise "Unknown Environment: \"#{application_environment}\"" unless url
    url
  end

  # Name: login_url
  # Input: No input is needed.
  # Purpose: Returns the url of the Login page

  def login_url
    environment_url + get_data_from_yml_file("environment_urls.yml")["LOGIN_URL"]
  end

  # Name: base_url
  # Input: No input is needed.
  # Purpose: Returns the environments base url

  def base_url
    get_data_from_yml_file("environment_urls.yml")["#{application_environment}_BASE_URL"]
  end

  # Name: application_environment
  # Input: No input is needed.
  # Purpose: Returns the name of the environment (e.g. - IT, Dev)

  def application_environment
    ENV['app_env'].nil? ? "JJ" : ENV['app_env'].gsub(" ","_").upcase
  end

  # Name: database_region
  # Input: No input is needed.
  # Purpose: Returns the region information for the environment

  def database_region
    get_data_from_yml_file("database_credentials.yml")[application_environment.upcase]["REGION"]
  end

  # Name: database_login
  # Input: No input is needed.
  # Purpose: Returns the login information for the environment

  def database_login
    get_data_from_yml_file("database_credentials.yml")[application_environment.upcase]["USERNAME"]
  end

  # Name: database_password
  # Input: No input is needed.
  # Purpose: Returns the password for the environment

  def database_password
    get_data_from_yml_file("database_credentials.yml")[application_environment.upcase]["PASSWORD"]
  end

  # Name: environment_browser_type
  # Input: No input is needed.
  # Purpose: Returns the browser to be used

  def environment_browser_type
    ENV['browser_type'].nil? ? "firefox" : ENV['browser_type']
  end

  # Name: close_browser_when_finished
  # Input: No input is needed.
  # Purpose: Returns whether the browser must be used after the test is finished

  def close_browser_when_finished
    ENV['close_browser'].nil? ? true : ENV['close_browser']
  end

  # Name: verbose
  # Input: No input is needed.
  # Purpose: Returns wether or not to print out messages for what is happening under the hood

  def verbose_messages
    ENV['verbose'].nil? ? false : ENV['verbose'] == "true"
  end

end

World DataHelper