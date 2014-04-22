class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
    	t.integer :user_id
    	t.string :action

    	t.integer :targetable_id
    	t.string  :targetable_type

    	t.timestamps
    end

    add_index :activities, :user_id
    # add_index :activities, [:targetable_id, :targetable_type]
    
  end
end
