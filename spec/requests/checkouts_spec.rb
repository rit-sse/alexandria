require 'spec_helper'

describe 'Checkouts' do
  describe 'GET /checkouts' do
    it 'works! (now write some real specs)' do
      get checkouts_path
      response.status.should be(200)
    end
  end
end
