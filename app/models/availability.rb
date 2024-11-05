class Availability < ApplicationRecord
  belongs_to :user

  validates :start_time, presence: true
  validate :end_time_after_start_time, if: :end_time

  private

  def end_time_after_start_time
    errors.add(:end_time, "must be after the start time") if end_time < start_time
    # TODO: - if we change to use time, end_time should be <= start_time,
    # for now it's < because we're only checking the date
  end
end
