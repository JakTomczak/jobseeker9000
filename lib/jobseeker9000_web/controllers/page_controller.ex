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
    y = 2
    case 7 do
      1 -> "Math is broken"
      x -> y = x
    end
    IO.puts "ok"
    IO.puts y
  end

  def index(conn, _params) do
    IO.puts "starting"
    render(conn, "index.html", res: run())
  end
end
