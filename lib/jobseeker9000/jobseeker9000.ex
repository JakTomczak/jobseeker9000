defmodule Jobseeker9000.Jobseeker9000 do
  alias Jobseeker9000.Jobs
  alias Jobseeker9000.Floker.Context

  def test_search(what) do
    context =
      Context.make([
        %{
          name: "Remote",
          type: "remote"
        }
      ])

    Jobseeker9000.Floker.scrap_by_context(what, context)
    |> inspect()
  rescue
    e in RuntimeError ->
      inspect(e)
  end

  def search_by_flag(%Jobs.Flag.Schema{} = flag) do
    context = Context.make([flag])
  end
end
