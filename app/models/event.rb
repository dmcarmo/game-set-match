class Event
  attr_reader :start_time, :end_time, :name, :type, :overlap_count

  def initialize(attributes = {})
    @start_time = attributes[:start_time]
    @end_time = attributes[:end_time]
    @name = attributes[:name]
    @type = attributes[:type]
    @overlap_count = attributes[:overlap_count]
  end
end
