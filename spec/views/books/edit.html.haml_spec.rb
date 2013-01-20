require 'spec_helper'

describe "books/edit" do
  before(:each) do
    @book = assign(:book, stub_model(Book,
      :ISBN => "MyString",
      :title => "MyString",
      :author => "MyString",
      :publish_date => "",
      :UUID => "MyString"
    ))
  end

  it "renders the edit book form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => books_path(@book), :method => "post" do
      assert_select "input#book_ISBN", :name => "book[ISBN]"
      assert_select "input#book_title", :name => "book[title]"
      assert_select "input#book_author", :name => "book[author]"
      assert_select "input#book_publish_date", :name => "book[publish_date]"
      assert_select "input#book_UUID", :name => "book[UUID]"
    end
  end
end
