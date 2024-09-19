class Group < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :invitations, dependent: :destroy

  before_create :generate_invitation_token

  def member_count
    users.count
  end

  def member_availabilities
    Availability.where(user_id: users.pluck(:id))
  end

  private

  def generate_invitation_token
    self.invitation_token = SecureRandom.urlsafe_base64
  end
end
