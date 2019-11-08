defmodule Jobseeker9000Web.PageController do
  use Jobseeker9000Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
