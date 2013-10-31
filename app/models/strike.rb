# Strike Model
class Strike < ActiveRecord::Base
  belongs_to :patron, class_name: 'User'
  belongs_to :distributor, class_name: 'User'
  belongs_to :reason

  validates :reason_id, :patron_id, :distributor_id, presence: true

  def message
    string = reason.message
    unless other_info.blank?
      string = "#{string}: #{other_info}"
    end
    string
  end
end
