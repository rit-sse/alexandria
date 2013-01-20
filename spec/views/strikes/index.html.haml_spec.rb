require 'spec_helper'

describe "strikes/index" do
  before(:each) do
    assign(:strikes, [
      stub_model(Strike,
        :user => "",
        :distributor => "",
        :message => ""
      ),
      stub_model(Strike,
        :user => "",
        :distributor => "",
        :message => ""
      )
    ])
  end

  it "renders a list of strikes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
