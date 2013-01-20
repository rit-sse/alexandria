require 'spec_helper'

describe "checkouts/new" do
  before(:each) do
    assign(:checkout, stub_model(Checkout,
      :user => "",
      :distributor => "",
      :book => "",
      :checked_out_at => "",
      :checked_in_at => ""
    ).as_new_record)
  end

  it "renders new checkout form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => checkouts_path, :method => "post" do
      assert_select "input#checkout_user", :name => "checkout[user]"
      assert_select "input#checkout_distributor", :name => "checkout[distributor]"
      assert_select "input#checkout_book", :name => "checkout[book]"
      assert_select "input#checkout_checked_out_at", :name => "checkout[checked_out_at]"
      assert_select "input#checkout_checked_in_at", :name => "checkout[checked_in_at]"
    end
  end
end
