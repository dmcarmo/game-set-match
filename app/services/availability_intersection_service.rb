class AvailabilityIntersectionService
  def self.calculate(availabilities, member_count)
    events = []
    availabilities.each do |availability|
      events << { time: availability.start_time, type: :start }
      events << { time: availability.end_time, type: :end }
    end

    events.sort_by! { |e| e[:time] }

    intersections = []
    current_count = 0
    start_time = nil

    events.each do |event|
      if event[:type] == :start
        current_count += 1
        start_time = event[:time] if current_count >= member_count && start_time.nil?
      else # :end
        if current_count >= member_count && !start_time.nil?
          intersections << { start_time: start_time, end_time: event[:time], overlap_count: current_count }
          start_time = nil
        end
        current_count -= 1
      end
    end

    intersections
  end
end
