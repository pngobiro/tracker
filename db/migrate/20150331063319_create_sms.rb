class CreateSms < ActiveRecord::Migration
  def change
    create_table :sms do |t|
      t.string :station
      t.string :number
      t.text :sentmessage
      t.string :status

      t.timestamps
    end
  end
end
