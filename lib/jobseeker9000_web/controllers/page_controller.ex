defmodule Jobseeker9000Web.PageController do
  use Jobseeker9000Web, :controller
  alias Jobseeker9000.Jobseeker9000
  # import Enum

  defp test() do
    y = 2
    case 7 do
      1 -> "Math is broken"
      x -> y = x
    end
    IO.puts "ok"
    IO.puts y
  end

  def index(conn, _params) do
    # IO.puts "starting"
    render(conn, "index.html", res: Jobseeker9000.big_search(:pracuj))
  end
end
