class CustomizeOrderPage < SBDPage

text_field(:order_name, :id => "textInput")
select_list(:select_bread_list, :id => "select_3888")
select_list(:add_drink_list, :id => "select_3963")
select_list(:add_chips_list, :id => "select_3882")
select_list(:add_cookie_list, :id => "select_3992")
select_list(:add_pickle_list, :id => "select_3943")
link(:add_to_order_button, :xpath => "/html/body/div[1]/section/div/div/div[3]/div[2]/div/a[1]")

  # Name: form_field_order
  # Input: No input is needed.
  # Purpose: Fills the details of the various fields in required order

  def form_field_order
    %w{
        order_name
        select_bread_list
        add_drink_list
        add_chips_list
        add_cookie_list
        add_pickle_list
    }

  end

  # Name: data_class
  # Input:  No input is needed.
  # Purpose: Return the data class for the page

  def self.data_class
    CustomizeOrderPageData
  end

  # Name: page_title_validation_value
  # Input: none
  # Purpose: return the validation value for the page title

  def self.page_title_validation_value
    /CUSTOMIZE YOUR ORDER/
  end

  # Name: page_url_validation_value
  # Input: none
  # Purpose: return the validation value for the page url

  def self.page_url_validation_value
    /additem/
  end

end





