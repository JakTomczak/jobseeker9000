defmodule Jobseeker9000Web.PageController do
  use Jobseeker9000Web, :controller
  alias Jobseeker9000.Jobseeker9000
  # import Enum

  defp test() do
    html = """
    <div>
      <div data-lol="abba">
        ojcze
      </div>
      <div data-lol="abba">
        lorem
      </div>
    </div>
    """

    Floki.find(html, "[data-lol=abba]")
    |> inspect()
  end

  def index(conn, _params) do
    # IO.puts "starting"
    render(conn, "index.html", res: Jobseeker9000.test_search(:pracuj))
    # render(conn, "index.html", res: test())
  end
end
