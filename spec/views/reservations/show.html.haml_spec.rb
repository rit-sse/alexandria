require 'spec_helper'

describe "reservations/show" do
  before(:each) do
    @reservation = assign(:reservation, stub_model(Reservation,
      :user => "",
      :book => "",
      :reserve_at => "",
      :fuffiled => false,
      :expires_at => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(/false/)
    rendered.should match(//)
  end
end
