require 'spec_helper'

describe "checkouts/index" do
  before(:each) do
    @
    assign(:checkouts, [
      stub_model(Checkout,
        :patron => "",
        :distributor => "",
        :book => "",
        :checked_out_at => "",
        :checked_in_at => ""
      ),
      stub_model(Checkout,
        :patron => "",
        :distributor => "",
        :book => "",
        :checked_out_at => "",
        :checked_in_at => ""
      )
    ])
  end

  it "renders a list of checkouts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
