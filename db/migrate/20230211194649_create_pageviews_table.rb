class CreatePageviewsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :pageviews do |t|
      # Fingerprint is the unique identifier of a visitor, its used to backtrack the users' activity pre-signup
      t.string :fingerprint, null: false
      t.string :user_id
      t.string :url, null: false
      t.string :referrer_url
      t.string :referrer_source

      # UTM columns are added if data is present, adds more context to the pageview
      t.string :utm_source
      t.string :utm_campaign
      t.string :utm_medium
      t.string :utm_content

      t.datetime :created_at, null: false
    end

    # Improves performance on queries for pageviews before an event by fingerprint and created_at, to find the pageviews before an event's date
    add_index :pageviews, %i[fingerprint created_at], unique: true
  end
end
