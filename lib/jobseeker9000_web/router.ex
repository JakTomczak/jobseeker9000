defmodule Jobseeker9000Web.Router do
  use Jobseeker9000Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Jobseeker9000Web do
    pipe_through :browser

    get "/", PageController, :index

    resources "/flag", FlagController#, only: [:index, :new, :create, :edit, :update]

    resources "/offer", OfferController, only: [:index, :edit, :update]

    post "/search", SearchController, :search
  end

  # Other scopes may use custom stacks.
  # scope "/api", Jobseeker9000Web do
  #   pipe_through :api
  # end
end
