defmodule NjuusWeb.Router do
  use NjuusWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Njuus.TrackerPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/", NjuusWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/admin", AdminController, :index
  end

  scope "/api", NjuusWeb do
    pipe_through :api

    post "/vote_add", APIController, :vote_add
    post "/vote_add", APIController, :vote_add
    post "/update_user_settings", APIController, :update_user_settings
    post "/add_user_filter", APIController, :add_user_filter
  end
end
