class ChangeVisitsCommentColumntype < ActiveRecord::Migration
  def change
    change_column(:visits, :comment, :text)
  end
end
