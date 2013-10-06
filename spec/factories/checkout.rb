FactoryGirl.define do
  factory :checkout do
    checked_out_at Date.new(2013, 2, 4)
    due_date Date.new(2013, 2, 11)
  end
end
