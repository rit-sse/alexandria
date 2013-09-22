require 'spec_helper'

describe "Reservations" do
  describe "GET /reservations" do
    it "works! (now write some real specs)" do
      get reservations_path
      response.status.should be(200)
    end
  end
end
