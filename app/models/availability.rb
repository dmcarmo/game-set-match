class Availability < ApplicationRecord
  belongs_to :user

  validates :start_time, :end_time, presence: true
  validate :end_time_after_start_time

  private

  def end_time_after_start_time
    errors.add(:end_time, "must be after the start time") if end_time <= start_time
  end
end
