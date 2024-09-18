class Invitation < ApplicationRecord
  belongs_to :user
  belongs_to :group
  belongs_to :invited_by, class_name: "User"

  enum :status, { pending: "pending", accepted: "accepted", declined: "declined" }
end
