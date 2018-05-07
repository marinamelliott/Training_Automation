class TargetWomensClothingPage < SBDPage

  link(:bikini_show_button, :xpath => "//*[@id='mainContainer']/div[3]/div/div[2]/div/div[1]/div[1]/div/div/a")
  link(:juniors_clothing_button, :xpath => "//*[@id='mainContainer']/div[5]/div/div/ul/li[2]/a" )

  # Name: form_field_order
  # Input: No input is needed.
  # Purpose: Fills the details of the various fields in required order

  def form_field_order
    %w{
      bikini_show_button
      juniors_clothing_button
    }

  end

  # Name: data_class
  # Input:  No input is needed.
  # Purpose: Return the data class for the page

  def self.data_class
    TargetWomensClothingPageData
  end

  # Name: page_title_validation_value
  # Input: none
  # Purpose: return the validation value for the page title

  def self.page_title_validation_value
    /Women's Clothing/
  end

  # Name: page_url_validation_value
  # Input: none
  # Purpose: return the validation value for the page url

  def self.page_url_validation_value
    /women-s-clothing/
  end

end





