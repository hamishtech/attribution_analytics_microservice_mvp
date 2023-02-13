class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.string :fingerprint, null: false
      t.string :user_id, null: false
      t.datetime :created_at, null: false
    end

    # This prevents duplication of events with the same name (i.e. "signup") for a given user and improves performance on queries for events by user_id and name
    add_index :events, %i[user_id name], unique: true
  end
end
