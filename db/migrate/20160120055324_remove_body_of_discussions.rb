class RemoveBodyOfDiscussions < ActiveRecord::Migration
  def change

    reversible do |dir|
      dir.up do
        Opinion.record_timestamps = false

        Canoe.all.each do |canoe|
          canoe.discussions.each do |discussion|
            unless discussion.body.blank?
              discussion.opinions.create({
                body: discussion.body,
                user: discussion.user,
                created_at: discussion.created_at,
                updated_at: discussion.created_at
              })
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
