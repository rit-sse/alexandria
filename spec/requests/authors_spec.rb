require 'spec_helper'

describe "Authors" do
  describe "GET /authors" do
    it "works! (now write some real specs)" do
      get authors_path
      response.status.should be(200)
    end
  end
end
