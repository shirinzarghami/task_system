class CreateInvitation < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :invitor_id
      t.integer :invitee_id
      t.integer :community_id
      t.string :invitee_email

      t.timestamps
    end
  end
end
