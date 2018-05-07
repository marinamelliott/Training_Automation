class OrderMenuPage < SBDPage
  div(:store_closed_pop_up, :id => "popup_container")
  button(:reschedule_order_yes_button, :id => "btnConfirmationYes")
  button(:reschedule_order_cancel_button, :id => "btnConfirmationNo")
  span(:sub_sandwiches_button, :text => '8" Sub Sandwiches')
  link(:turkey_tom_button, :href => "#/additem/3691")

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
    OrderMenuPageData
  end

  # Name: page_title_validation_value
  # Input: none
  # Purpose: return the validation value for the page title

  def self.page_title_validation_value
    # /JJ'S MENU/
    //
  end

  # Name: page_url_validation_value
  # Input: none
  # Purpose: return the validation value for the page url

  def self.page_url_validation_value
    /menu/
  end

end





