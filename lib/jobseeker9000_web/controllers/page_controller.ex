defmodule Jobseeker9000Web.PageController do
  use Jobseeker9000Web, :controller
  alias Jobseeker9000.Poisoner
  alias Jobseeker9000.Floker
  # import Enum

  defp run() do
    case Poisoner.poison_pracuj() do
      {:ok, body: body} ->
        Floker.floking(:pracuj, body)
      {:error, reason: reason} ->
        IO.inspect reason
    end
  end

  defp test() do
    html = """
<body><div class="example"><a class="lol" href="abba">abba</a></div><div class="example"><a href="ojcze">ojcze</a></div></div></body>
    """
    # |> Floki.find(html, "body")
    # divs = test_on_first(Floki.find(html, "div.example"))
    # Enum.maps(divs, encode(divs))
    # Enum.map(divs, &encode/1)
    [href | more_than_one] = Floki.attribute(html, "a.lol", "href" )
    IO.puts href
    IO.puts (more_than_one == [])
    "ok"
    # |> Floki.raw_html
  end

  def index(conn, _params) do
    IO.puts "starting"
    render(conn, "index.html", res: run())
  end
end
