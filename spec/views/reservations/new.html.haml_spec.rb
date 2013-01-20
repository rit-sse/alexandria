require 'spec_helper'

describe "reservations/new" do
  before(:each) do
    assign(:reservation, stub_model(Reservation,
      :user => "",
      :book => "",
      :reserve_at => "",
      :fuffiled => false,
      :expires_at => ""
    ).as_new_record)
  end

  it "renders new reservation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => reservations_path, :method => "post" do
      assert_select "input#reservation_user", :name => "reservation[user]"
      assert_select "input#reservation_book", :name => "reservation[book]"
      assert_select "input#reservation_reserve_at", :name => "reservation[reserve_at]"
      assert_select "input#reservation_fuffiled", :name => "reservation[fuffiled]"
      assert_select "input#reservation_expires_at", :name => "reservation[expires_at]"
    end
  end
end
