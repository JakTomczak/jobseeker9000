defmodule Jobseeker9000.Floker.OfferScrapper do
  defstruct state: :ok,
            full_html: {},
            head_html: {},
            offer: %{},
            error_text: "",
            context: nil,
            module: nil

  alias Jobseeker9000.Floker
  alias Jobseeker9000.Floker.FlokerHelpers

  def run(%__MODULE__{} = scrapper) do
    scrapper
    |> init()
    |> get_header()
    |> basic_info()
  end

  def test_run(what, context, offer) do
    %__MODULE__{
      module: Jobseeker9000.Floker.Websites.module(what),
      offer: offer,
      context: context
    }
    |> run()
    |> inspect()
  end

  defp init(%__MODULE__{offer: %{full_link: full_link}} = scrapper) do
    %{
      scrapper
      | full_html: Floker.poison!(full_link)
    }
  end

  defp get_header(%__MODULE__{state: :error} = scrapper), do: scrapper

  defp get_header(%__MODULE__{} = scrapper) do
    header_selector = apply(scrapper.module, :header_selector, [])

    case Floki.find(scrapper.full_html, header_selector) do
      [] ->
        %{
          scrapper
          | state: :error,
            error_text: "No selector '#{header_selector}'"
        }

      [head] ->
        %{scrapper | head_html: head}

      [_one, _two | _more] ->
        %{
          scrapper
          | state: :error,
            error_text: "Too many selectors '#{header_selector}'"
        }
    end
  end

  defp basic_info(%__MODULE__{state: :error} = scrapper) do
    {:error, scrapper.error_text}
  end

  defp basic_info(%__MODULE__{} = scrapper) do
    name_selector = apply(scrapper.module, :name_selector, [])
    [{_h1, _options, offer_name}] = Floki.find(scrapper.head_html, name_selector)

    employer_url = apply(scrapper.module, :offer_employer_url, [scrapper.full_html])

    {offer_status, offer_from, offer_ending} =
      apply(scrapper.module, :offer_status, [scrapper.head_html])

    address_text = apply(scrapper.module, :offer_address_text, [scrapper.head_html])

    # TODO: address

    actual_offer_selector = apply(scrapper.module, :actual_offer_selector, [])

    [actual_offer_div] = Floki.find(scrapper.full_html, actual_offer_selector)

    offer = %{
      name: offer_name,
      employer_url: employer_url,
      status: offer_status,
      from: offer_from,
      ending: offer_ending,
      address_text: address_text,
      offer_div: actual_offer_div
    }

    {:ok, offer}
  end
end
