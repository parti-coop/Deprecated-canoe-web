class RemoveBodyOfDiscussions < ActiveRecord::Migration
  def change

    reversible do |dir|
      dir.up do

        Canoe.all.each do |canoe|
          canoe.discussions.each do |discussion|
            unless discussion.body.blank?
              query = "INSERT INTO opinions(body, discussion_id, user_id, created_at, updated_at) VALUES(?, ?, ?, ?, ?)"
              # sanitized_sql = ActiveRecord::Base.sanitize_sql [query, discussion.body, discussion.id, discussion.user_id, discussion.created_at, discussion.created_at]
              # ActiveRecord::Base.connection.execute sanitized_sql

              st = ActiveRecord::Base.connection.raw_connection.prepare query
              st.execute discussion.body, discussion.id, discussion.user_id, discussion.created_at.to_s, discussion.created_at.to_s
              st.close
              say st.to_s
            end
          end
        end

        remove_column :discussions, :body
      end
      dir.down do
        add_column :discussions, :body, :text
      end
    end
  end
end
