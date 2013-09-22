require 'spec_helper'

describe "Strikes" do
  describe "GET /strikes" do
    it "works! (now write some real specs)" do
      get strikes_path
      response.status.should be(200)
    end
  end
end
