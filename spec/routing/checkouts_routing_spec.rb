require "spec_helper"

describe CheckoutsController do
  describe "routing" do

    it "routes to #index" do
      get("/checkouts").should route_to("checkouts#index")
    end

    it "routes to #new" do
      get("/checkouts/new").should route_to("checkouts#new")
    end

    it "routes to #show" do
      get("/checkouts/1").should route_to("checkouts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/checkouts/1/edit").should route_to("checkouts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/checkouts").should route_to("checkouts#create")
    end

    it "routes to #update" do
      put("/checkouts/1").should route_to("checkouts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/checkouts/1").should route_to("checkouts#destroy", :id => "1")
    end

  end
end
