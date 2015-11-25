# Data formatting module. Should be not needed at all
module DateHelper
  # Sets the log timestamp
  def self.set_log_timestamp
    Time.now.strftime('%d.%m.%y-%H:%M:%S')
  end

  # Sets the output directory timestamp
  def self.set_directory_datestamp
    Time.now.strftime('%d.%m.%y')
  end

  # Set timestamp using the format 15-03-00
  def self.set_timestamp
    Time.now.strftime('%H:%M:%S')
  end

  # Create date stamp using the format 05-11-12
  def self.set_datestamp
    Time.now.strftime('%d.%m.%y')
  end

  # Create date and time stamp using the format 05-11-12 15:03:00
  def self.set_date_timestamp
    Time.now.strftime('%d.%m.%y-%H:%M:%S')
  end
end
