require 'spec_helper'

describe "users/edit" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :user_name => "MyString",
      :banned => false,
      :role => "MyString"
    ))
  end

  it "renders the edit user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => users_path(@user), :method => "post" do
      assert_select "input#user_user_name", :name => "user[user_name]"
      assert_select "input#user_banned", :name => "user[banned]"
      assert_select "input#user_role", :name => "user[role]"
    end
  end
end
