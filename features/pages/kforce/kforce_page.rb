class KforcePage < SBDPage

  page_url(environment_url)

  text_field(:search_by_job_title_or_skill, :xpath => "//*[@id='main-search-generic']/div/div/div[2]/form/div/div[1]/div/input")
  # text_field(:city_state_or_zip, :xpath => "//*[@id='react-select-2--value']/div[2]/input")
  button(:search_button, :xpath => "//*[@id='main-search-generic']/div/div/div[2]/form/div/div[3]/div/input")
  button(:search_jobs_button, :xpath => "//*[@id='footer-menu']/div/div[1]/ul/li[1]/a")


  # Name: form_field_order
  # Input: No input is needed.
  # Purpose: Fills the details of the various fields in required order

  def form_field_order
    %w{

    }
  end

  # Name: data_class
  # Input:  No input is needed.
  # Purpose: Return the data class for the page

  def self.data_class
    KforcePageData
  end

  # Name: page_title_validation_value
  # Input: none
  # Purpose: return the validation value for the page title

  def self.page_title_validation_value
    //
  end

  # Name: page_url_validation_value
  # Input: none
  # Purpose: return the validation value for the page url

  def self.page_url_validation_value
    //
  end

end





