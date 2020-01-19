defmodule Jobseeker9000.Floker do
  defstruct state: :unset,
            full_html: {},
            all_the_lis: [],
            results: [],
            error_text: "",
            error_values: %{},
            context: nil,
            module: nil

  alias Jobseeker9000.Floker.Poisoner
  alias Jobseeker9000.Floker.Websites
  alias Jobseeker9000.Floker.Search
  alias Jobseeker9000.Floker.OfferScrapper

  def poison_wrapper()

  def run(what, context) do
    init(what, context)
    |> get_index()
    |> Search.run()
  end

  def poison!(url) do
    case Poisoner.get_body(url) do
      {:ok, body} ->
        body
      {:error, reason} ->
        raise RuntimeError, message: "Error occured with reason: #{reason}"
    end
  end

  defp init(what, context) do
    %__MODULE__{
      state: :ok,
      context: context,
      module: Websites.module(what),
    }
  end

  defp get_index(%__MODULE__{} = floker) do
    url = Websites.search_url(floker.context, floker.module)
    body = poison!(url)
    %{floker | full_html: body}
  end

  defp offer_scrapper(%__MODULE__{results: []} = floker), do: :ok   
  defp offer_scrapper(%__MODULE__{results: [offer | tail]} = floker) do
    %OfferScrapper{
      offer: offer,
      context: floker.context,
      module: floker.module
    }
    |> OfferScrapper.run()
  end
end