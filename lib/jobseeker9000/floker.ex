defmodule Jobseeker9000.Floker do
  alias Jobseeker9000.Floker.Pracuj

  def floking(:pracuj, html) do
    Pracuj.run(html)
  end
end