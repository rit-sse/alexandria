require 'spec_helper'

describe "books/index" do
  before(:each) do
    assign(:books, [
      stub_model(Book,
        :ISBN => "Isbn",
        :title => "Title",
        :author => "Author",
        :publish_date => "",
        :UUID => "Uuid"
      ),
      stub_model(Book,
        :ISBN => "Isbn",
        :title => "Title",
        :author => "Author",
        :publish_date => "",
        :UUID => "Uuid"
      )
    ])
  end

  it "renders a list of books" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Isbn".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Author".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Uuid".to_s, :count => 2
  end
end
