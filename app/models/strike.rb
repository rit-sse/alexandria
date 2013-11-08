# Strike Model
class Strike < ActiveRecord::Base
  belongs_to :patron, class_name: 'User'
  belongs_to :distributor, class_name: 'User'
  belongs_to :reason

  validates :reason_id, :patron_id, :distributor_id, presence: true
  validate :is_distributor
  validate :other_has_info

  def message
    string = reason.message
    string = "#{string}: #{other_info}" unless other_info.blank?
    string
  end

  def is_distributor
    unless !distributor.nil? && (distributor.distributor? || distributor.librarian?)
      errors.add(:distributor, 'is not a distributor or librarian.')
    end
  end

  def other_has_info
    if reason == Reason.find_by_message('Other') && other_info.blank?
      errors.add(:strike, 'needs more information if "Other" is chosen for reason.')
    end
  end
end
