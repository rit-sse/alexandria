class AddPatronToStrike < ActiveRecord::Migration
  def change
    add_reference :strikes, :patron, index: true
  end
end
