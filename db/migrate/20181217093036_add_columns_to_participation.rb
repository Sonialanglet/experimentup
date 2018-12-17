class AddColumnsToParticipation < ActiveRecord::Migration[5.1]
  def change
    add_monetize :participations, :amount, currency: { present: false }
    add_column :participations, :payment, :jsonb
  end
end
