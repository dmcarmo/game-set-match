class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships
  has_many :owned_groups, class_name: "Group", foreign_key: "owner_id", dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :availabilities, dependent: :destroy

  attr_accessor :invitation_token

  after_create :process_pending_invitation

  private

  def process_pending_invitation
    return unless invitation_token.present?

    group = Group.find_by(invitation_token:)
    Membership.create(user: self, group: group) if group
  end
end
