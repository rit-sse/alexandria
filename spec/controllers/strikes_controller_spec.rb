require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe StrikesController do

  # This should return the minimal set of attributes required to create a valid
  # Strike. As you add validations to Strike, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { "message" => "MyString" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # StrikesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all strikes as @strikes" do
      strike = Strike.create! valid_attributes
      get :index, {}, valid_session
      assigns(:strikes).should eq([strike])
    end
  end

  describe "GET show" do
    it "assigns the requested strike as @strike" do
      strike = Strike.create! valid_attributes
      get :show, {:id => strike.to_param}, valid_session
      assigns(:strike).should eq(strike)
    end
  end

  describe "GET new" do
    it "assigns a new strike as @strike" do
      get :new, {}, valid_session
      assigns(:strike).should be_a_new(Strike)
    end
  end

  describe "GET edit" do
    it "assigns the requested strike as @strike" do
      strike = Strike.create! valid_attributes
      get :edit, {:id => strike.to_param}, valid_session
      assigns(:strike).should eq(strike)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Strike" do
        expect do
          post :create, {:strike => valid_attributes}, valid_session
        end.to change(Strike, :count).by(1)
      end

      it "assigns a newly created strike as @strike" do
        post :create, {:strike => valid_attributes}, valid_session
        assigns(:strike).should be_a(Strike)
        assigns(:strike).should be_persisted
      end

      it "redirects to the created strike" do
        post :create, {:strike => valid_attributes}, valid_session
        response.should redirect_to(Strike.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved strike as @strike" do
        # Trigger the behavior that occurs when invalid params are submitted
        Strike.any_instance.stub(:save).and_return(false)
        post :create, {:strike => { "user" => "invalid value" }}, valid_session
        assigns(:strike).should be_a_new(Strike)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Strike.any_instance.stub(:save).and_return(false)
        post :create, {:strike => { "user" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested strike" do
        strike = Strike.create! valid_attributes
        # Assuming there are no other strikes in the database, this
        # specifies that the Strike created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Strike.any_instance.should_receive(:update).with({ "message" => "" })
        put :update, {:id => strike.to_param, :strike => { "message" => "" }}, valid_session
      end

      it "assigns the requested strike as @strike" do
        strike = Strike.create! valid_attributes
        put :update, {:id => strike.to_param, :strike => valid_attributes}, valid_session
        assigns(:strike).should eq(strike)
      end

      it "redirects to the strike" do
        strike = Strike.create! valid_attributes
        put :update, {:id => strike.to_param, :strike => valid_attributes}, valid_session
        response.should redirect_to(strike)
      end
    end

    describe "with invalid params" do
      it "assigns the strike as @strike" do
        strike = Strike.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Strike.any_instance.stub(:save).and_return(false)
        put :update, {:id => strike.to_param, :strike => { "user" => "invalid value" }}, valid_session
        assigns(:strike).should eq(strike)
      end

      it "re-renders the 'edit' template" do
        strike = Strike.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Strike.any_instance.stub(:save).and_return(false)
        put :update, {:id => strike.to_param, :strike => { "user" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested strike" do
      strike = Strike.create! valid_attributes
      expect do
        delete :destroy, {:id => strike.to_param}, valid_session
      end.to change(Strike, :count).by(-1)
    end

    it "redirects to the strikes list" do
      strike = Strike.create! valid_attributes
      delete :destroy, {:id => strike.to_param}, valid_session
      response.should redirect_to(strikes_url)
    end
  end

end
