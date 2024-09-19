# app/services/availability_intersection_service.rb
class AvailabilityIntersectionService
  def self.calculate(availabilities, total_members)
    return [] if availabilities.empty?

    min_required_members = (total_members / 2.0).ceil

    events = availabilities.flat_map do |a|
      [
        { time: a.start_time, type: :start, availability: a },
        { time: a.end_time, type: :end, availability: a }
      ]
    end.sort_by { |e| [e[:time], e[:type] == :end ? 0 : 1] }

    intersections = []
    current_availabilities = Set.new
    start_time = nil

    events.each do |event|
      if event[:type] == :start
        if current_availabilities.size > min_required_members
          intersections << {
            start_time: start_time,
            end_time: event[:time],
            overlap_count: current_availabilities.size
          }
        end
        current_availabilities.add(event[:availability])
        start_time = event[:time] if current_availabilities.size == min_required_members
      else
        if current_availabilities.size > min_required_members
          intersections << {
            start_time: start_time,
            end_time: event[:time],
            overlap_count: current_availabilities.size
          }
        end
        current_availabilities.delete(event[:availability])
        start_time = event[:time] if current_availabilities.size > min_required_members
      end
    end

    merge_adjacent_intersections(intersections)
  end

  def self.merge_adjacent_intersections(intersections)
    return [] if intersections.empty?

    merged = [intersections.first]
    intersections[1..-1].each do |intersection|
      last = merged.last
      if last[:end_time] == intersection[:start_time] && last[:overlap_count] == intersection[:overlap_count]
        last[:end_time] = intersection[:end_time]
      else
        merged << intersection
      end
    end
    merged
  end
end
