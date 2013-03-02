require 'spec_helper'

describe "authors/new" do
  before(:each) do
    assign(:author, stub_model(Author,
      :first_name => "MyString",
      :last_name => "MyString",
      :middle_initial => "MyString"
    ).as_new_record)
  end

  it "renders new author form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => authors_path, :method => "post" do
      assert_select "input#author_first_name", :name => "author[first_name]"
      assert_select "input#author_last_name", :name => "author[last_name]"
      assert_select "input#author_middle_initial", :name => "author[middle_initial]"
    end
  end
end
