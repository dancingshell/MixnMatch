require "rails_helper"


describe UserAccountsController, :type => :controller do
  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "loads all of the posts into @posts" do
      user_account1, user_account2 = UserAccount.create!, UserAccount.create!
      get :index

      expect(assigns(:user_accounts)).to match_array([user_account1, user_account2])
    end
  end
end