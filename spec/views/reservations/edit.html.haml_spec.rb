require 'spec_helper'

describe "reservations/edit" do
  before(:each) do
    @reservation = assign(:reservation, stub_model(Reservation,
      :user => "",
      :book => "",
      :reserve_at => "",
      :fuffiled => false,
      :expires_at => ""
    ))
  end

  it "renders the edit reservation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => reservations_path(@reservation), :method => "post" do
      assert_select "input#reservation_user", :name => "reservation[user]"
      assert_select "input#reservation_book", :name => "reservation[book]"
      assert_select "input#reservation_reserve_at", :name => "reservation[reserve_at]"
      assert_select "input#reservation_fuffiled", :name => "reservation[fuffiled]"
      assert_select "input#reservation_expires_at", :name => "reservation[expires_at]"
    end
  end
end
