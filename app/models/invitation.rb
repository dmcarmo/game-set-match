class Invitation < ApplicationRecord
  belongs_to :user
  belongs_to :group
  belongs_to :invited_by, class_name: "User"

  attr_accessor :email

  enum :status, { pending: "pending", accepted: "accepted", declined: "declined" }
end
