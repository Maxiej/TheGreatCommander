class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :login,                     :string
      t.column :email,                     :string
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime   
      
      t.column :gender,                    :string
      t.column :date_of_birth,             :date
      t.column :avatar,                    :binary, :limit => 64.kilobytes
      t.column :avatar_content_type,       :string 
      t.column :no_of_wins,                :integer
      t.column :no_of_losses,              :integer
      t.column :scores,                    :integer
      t.column :last_time_online,          :datetime
    end
  end

  def self.down
    drop_table "users"
  end
end
