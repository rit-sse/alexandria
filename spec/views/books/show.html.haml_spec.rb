require 'spec_helper'

describe "books/show" do
  before(:each) do
    @book = assign(:book, stub_model(Book,
      :ISBN => "Isbn",
      :title => "Title",
      :author => "Author",
      :publish_date => "",
      :UUID => "Uuid"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Isbn/)
    rendered.should match(/Title/)
    rendered.should match(/Author/)
    rendered.should match(//)
    rendered.should match(/Uuid/)
  end
end
