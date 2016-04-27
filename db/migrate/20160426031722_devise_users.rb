class DeviseUsers < ActiveRecord::Migration
  def up
    password = '12345678'
    new_hashed_password = User.new(password: password).encrypted_password

    result = ActiveRecord::Base.connection.execute "SELECT nickname, email, id, created_at, updated_at, home_visited_at FROM old_users"
    result.each do |row|
      if (Rails.env.production? or Rails.env.staging?)
        nickname = row[0]
        email = row[1]
        id = row[2]
        created_at = row[3].to_s(:db)
        updated_at = row[4].to_s(:db)
        home_visited_at = row[5].to_s(:db)
      else
        nickname = row['nickname']
        email = row['email']
        id = row['id']
        created_at = row['created_at']
        updated_at = row['updated_at']
        home_visited_at = row['home_visited_at']
      end
      confirmed_at = DateTime.now.to_s(:db)
      query = "INSERT INTO
        users (id, email, uid, encrypted_password, nickname, home_visited_at, created_at, updated_at, confirmed_at)
        VALUES(#{id}, '#{email}', '#{email}', '#{new_hashed_password}', '#{nickname}', '#{home_visited_at}', '#{created_at}', '#{updated_at}', '#{confirmed_at}')"
      ActiveRecord::Base.connection.execute query
      say query
    end

    change_column_null :users, :uid, false
  end

  def down
    raise "unimplemented"
  end
end
