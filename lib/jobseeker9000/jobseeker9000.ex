defmodule Jobseeker9000.Jobseeker9000 do
  def big_search(what) do
    context = %{options: [{:include, :remote}]}
    Jobseeker9000.Floker.run(what, context)
  end
end