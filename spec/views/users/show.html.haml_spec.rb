require 'spec_helper'

describe "users/show" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :user_name => "User Name",
      :banned => false,
      :role => "Role"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/User Name/)
    rendered.should match(/false/)
    rendered.should match(/Role/)
  end
end
