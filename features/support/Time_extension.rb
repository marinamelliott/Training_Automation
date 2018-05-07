class Time

  # Returns a date relative to today based on the parameter hash
  #   :days - integer - number of days forward (or back) relative to today
  #   :years - integer - number of years forward (or back) relative to today
  # Sample usage:
  #   Time.warp(:days => 20)                   #twenty days from today
  #   Time.warp(:years => -55, :days => -1)    #fifty five years and one day ago

  def self.warp(params = {}, time = Time.now)
    #Gets the current Eastern Daylight Time (4 will change to 5 when daylight savings time ends)
    current_time = time.getutc - 5*60*60
    Time.local(current_time.year + params[:years].to_i,
               current_time.month,
               current_time.day,
               current_time.hour,
               current_time.min
    ) + params[:days].to_i*60*60*24
  end
end

