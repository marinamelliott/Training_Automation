class ReviewOrderPage < SBDPage

select_list(:schedule_delivery_time, :id => "whenTime")
select_list(:schedule_delivery_day, :id => "whenDate")

  # Name: form_field_order
  # Input: No input is needed.
  # Purpose: Fills the details of the various fields in required order

  def form_field_order
    %w{
      schedule_delivery_time
      schedule_delivery_day
    }

  end

  # Name: data_class
  # Input:  No input is needed.
  # Purpose: Return the data class for the page

  def self.data_class
    ReviewOrderPageData
  end

  # Name: page_title_validation_value
  # Input: none
  # Purpose: return the validation value for the page title

  def self.page_title_validation_value
    /ORDER SUMMARY/
  end

  # Name: page_url_validation_value
  # Input: none
  # Purpose: return the validation value for the page url

  def self.page_url_validation_value
    /revieworder/
  end

end





