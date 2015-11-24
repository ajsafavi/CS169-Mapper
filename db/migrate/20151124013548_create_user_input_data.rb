class CreateUserInputData < ActiveRecord::Migration
  def change
    create_table :user_input_data do |t|

      t.timestamps null: false
    end
  end
end
