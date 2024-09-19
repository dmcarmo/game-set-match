class AddInvitationTokenToGroups < ActiveRecord::Migration[7.1]
  def up
    add_column :groups, :invitation_token, :string
    add_index :groups, :invitation_token, unique: true

    # Generate tokens for existing groups
    Group.reset_column_information
    Group.find_each do |group|
      group.update_column(:invitation_token, SecureRandom.urlsafe_base64)
    end
  end

  def down
    remove_index :groups, :invitation_token
    remove_column :groups, :invitation_token
  end
end
