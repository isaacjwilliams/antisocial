class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
    	t.integer :user_id
    	t.string :action

    	t.timestamps
    end

    add_index :activities, :user_id
    
  end
end
