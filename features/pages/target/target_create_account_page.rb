class TargetCreateAccountPage < SBDPage

  text_field(:email_address, :id => "username")
  text_field(:first_name, :id => "firstname")
  text_field(:last_name, :id => "lastname")
  text_field(:create_password, :id => "password")

  # Name: form_field_order
  # Input: No input is needed.
  # Purpose: Fills the details of the various fields in required order

  def form_field_order
    %w{
      email_address
      first_name
      last_name
      create_password
    }

  end

  # Name: data_class
  # Input:  No input is needed.
  # Purpose: Return the data class for the page

  def self.data_class
    TargetCreateAccountPageData
  end

  # Name: page_title_validation_value
  # Input: none
  # Purpose: return the validation value for the page title

  def self.page_title_validation_value
    /create account/
  end

  # Name: page_url_validation_value
  # Input: none
  # Purpose: return the validation value for the page url

  def self.page_url_validation_value
    /login.target.com/
  end

end





