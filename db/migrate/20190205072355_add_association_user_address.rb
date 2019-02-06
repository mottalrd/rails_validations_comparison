class AddAssociationUserAddress < ActiveRecord::Migration[5.2]
  def change
    add_reference :addresses, :user
  end
end
