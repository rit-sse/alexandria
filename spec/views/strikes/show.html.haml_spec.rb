require 'spec_helper'

describe "strikes/show" do
  before(:each) do
    @strike = assign(:strike, stub_model(Strike,
      :user => "",
      :distributor => "",
      :message => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(//)
  end
end
