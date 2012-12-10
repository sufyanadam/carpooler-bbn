class Initial < ActiveRecord::Migration
  def change
    create_table :riders do |t|
      t.decimal :current_lat,
      t.decimal :current_lng,
      t.timestamp :last_seen_at
      t.decimal :last_seen_lat,
      t.decimal :last_seen_lng,
      t.string  :available_for
      t.integer :reserving_driver_id
      t.integer :pickup_spot_id
      t.integer :destination_spot_id
      t.string :type

      t.timestamps
    end

    create_table :drivers do |t|
      t.decimal :current_lat,
      t.decimal :current_lng,
      t.timestamp :last_seen_at
      t.decimal :last_seen_lat,
      t.decimal :last_seen_lng,
      t.string  :available_for
      t.integer :pickup_spot_id
      t.integer :destination_spot_id
      t.string :type

      t.timestamps
    end

    create_table :pickup_spots do |t|
      t.string :name
      t.decimal :lat,
      t.decimal :lng,
      t.timestamps
    end

    create_table :destination_spots do |t|
      t.string :name
      t.timestamps
    end
  end
end
