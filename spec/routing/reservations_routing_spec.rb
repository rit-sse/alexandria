require "spec_helper"

describe ReservationsController do
  describe "routing" do

    it "routes to #index" do
      get("/reservations").should route_to("reservations#index")
    end

    it "routes to #new" do
      get("/reservations/new").should route_to("reservations#new")
    end

    it "routes to #show" do
      get("/reservations/1").should route_to("reservations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/reservations/1/edit").should route_to("reservations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/reservations").should route_to("reservations#create")
    end

    it "routes to #update" do
      put("/reservations/1").should route_to("reservations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/reservations/1").should route_to("reservations#destroy", :id => "1")
    end

  end
end
