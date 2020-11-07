class CreateResults < ActiveRecord::Migration[6.0]
  def change
    create_table :results do |t|

      t.timestamps
      t.string :result
    end
  end
end
