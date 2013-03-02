require 'spec_helper'

describe "authors/edit" do
  before(:each) do
    @author = assign(:author, stub_model(Author,
      :first_name => "MyString",
      :last_name => "MyString",
      :middle_initial => "MyString"
    ))
  end

  it "renders the edit author form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => authors_path(@author), :method => "post" do
      assert_select "input#author_first_name", :name => "author[first_name]"
      assert_select "input#author_last_name", :name => "author[last_name]"
      assert_select "input#author_middle_initial", :name => "author[middle_initial]"
    end
  end
end
