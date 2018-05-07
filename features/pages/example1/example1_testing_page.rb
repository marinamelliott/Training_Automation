class Example1TestingPage < SBDPage

  page_url(environment_url)

  link(:ab_testing, :href => "/abtest")
  link(:basic_auth, :href => "/basic_auth")
  link(:broken_images, :href => "/broken_images")
  link(:challenging_dom, :href => "/challenging_dom")
  link(:checkboxes, :href => "/checkboxes")
  link(:context_menu, :href => "/context_menu")
  link(:disappearing_elements, :href => "/disappearing_elements")
  link(:drag_and_drop, :href => "/drag_and_drop")
  link(:dropdown, :href => "/dropdown")
  link(:dynamic_content, :href => "/dynamic_content")


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
    Example1TestingPageData
  end

  # Name: page_title_validation_value
  # Input: none
  # Purpose: return the validation value for the page title

  def self.page_title_validation_value
    /Welcome to the Internet/
  end

  # Name: page_url_validation_value
  # Input: none
  # Purpose: return the validation value for the page url

  def self.page_url_validation_value
    /the-internet/
  end

end





