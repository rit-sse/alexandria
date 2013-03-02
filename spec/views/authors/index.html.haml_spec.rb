require 'spec_helper'

describe "authors/index" do
  before(:each) do
    assign(:authors, [
      stub_model(Author,
        :first_name => "First Name",
        :last_name => "Last Name",
        :middle_initial => "Middle Initial"
      ),
      stub_model(Author,
        :first_name => "First Name",
        :last_name => "Last Name",
        :middle_initial => "Middle Initial"
      )
    ])
  end

  it "renders a list of authors" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => "Middle Initial".to_s, :count => 2
  end
end
