require "spec_helper"

describe StrikesController do
  describe "routing" do

    it "routes to #index" do
      get("/strikes").should route_to("strikes#index")
    end

    it "routes to #new" do
      get("/strikes/new").should route_to("strikes#new")
    end

    it "routes to #show" do
      get("/strikes/1").should route_to("strikes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/strikes/1/edit").should route_to("strikes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/strikes").should route_to("strikes#create")
    end

    it "routes to #update" do
      put("/strikes/1").should route_to("strikes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/strikes/1").should route_to("strikes#destroy", :id => "1")
    end

  end
end
