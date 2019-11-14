defmodule Jobseeker9000.Floker.Pracuj do
  defstruct state: :unset,
            full_html: {},
            all_the_lis: [],
            results: [],
            error_text: "",
            error_values: %{}
  
  def website() do
    "https://www.pracuj.pl"
  end

  def run(html) do
    Jobseeker9000.Floker.Pracuj.Search.run(html)
  end
end