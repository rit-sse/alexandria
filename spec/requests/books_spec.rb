require 'spec_helper'

describe 'Books' do
  describe 'GET /books' do
    it 'works! (now write some real specs)' do
      get books_path
      response.status.should be(200)
    end
  end
end
