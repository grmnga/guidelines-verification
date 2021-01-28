class CreateOpopTableHtmls < ActiveRecord::Migration[6.0]
  def change
    create_table :opop_table_htmls do |t|
      t.string :level
      t.string :html

      t.timestamps
    end
  end
end
