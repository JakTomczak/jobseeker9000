defmodule Jobseeker9000.Jobseeker9000 do
  alias Jobseeker9000.Jobs

  def test_search(what) do
    context = %{options: [{:include, :remote}]}
    Jobseeker9000.Floker.scrap_by_context(what, context)
    |> inspect()
  rescue 
    e in RuntimeError ->
      inspect(e)
  end

  def search_by_flag(%Jobs.Flag{} = flag) do
    
  end
end