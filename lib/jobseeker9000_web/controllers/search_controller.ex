defmodule Jobseeker9000Web.SearchController do
  use Jobseeker9000Web, :controller
  alias Jobseeker9000.Jobseeker9000

  def index(conn, _params) do
    render(conn, "index.html", res: Jobseeker9000.big_search(:pracuj))
  end
end
