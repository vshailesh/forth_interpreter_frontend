defmodule ForthInterpreterFrontendWeb.PageController do
  use ForthInterpreterFrontendWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
