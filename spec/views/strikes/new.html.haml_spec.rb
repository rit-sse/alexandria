require 'spec_helper'

describe "strikes/new" do
  before(:each) do
    assign(:strike, stub_model(Strike,
      :user => "",
      :distributor => "",
      :message => ""
    ).as_new_record)
  end

  it "renders new strike form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => strikes_path, :method => "post" do
      assert_select "input#strike_user", :name => "strike[user]"
      assert_select "input#strike_distributor", :name => "strike[distributor]"
      assert_select "input#strike_message", :name => "strike[message]"
    end
  end
end
