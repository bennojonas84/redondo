class ChangeVisitsColumns < ActiveRecord::Migration
  def up
    add_column :visits, :asset_id_array, :integer, array: true, default: []
    execute 'ALTER TABLE visits ALTER COLUMN visit_enthusiasm TYPE decimal USING (visit_enthusiasm::decimal)'
    execute 'ALTER TABLE visits ALTER COLUMN visit_quality TYPE decimal USING (visit_enthusiasm::decimal)'
    Visit.all.each do |visit|
      visit.update(visit_enthusiasm: visit.visit_enthusiasm.to_i)
    end
    Visit.all.each do |visit|
      visit.update(visit_quality: visit.visit_quality.to_i)
    end
    execute 'ALTER TABLE visits ALTER COLUMN visit_enthusiasm TYPE integer USING (visit_enthusiasm::integer)'
    execute 'ALTER TABLE visits ALTER COLUMN visit_quality TYPE integer USING (visit_enthusiasm::integer)'
  end

  def down
    execute 'ALTER TABLE visits ALTER COLUMN visit_enthusiasm TYPE text USING (visit_enthusiasm::text)'
    execute 'ALTER TABLE visits ALTER COLUMN visit_quality TYPE text USING (visit_enthusiasm::text)'
    remove_column :visits, :asset_id_array, :integer, array: true, default: []
  end
end
