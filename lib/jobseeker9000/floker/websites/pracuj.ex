defmodule Jobseeker9000.Floker.Websites.Pracuj do
  alias Jobseeker9000.Floker.FlokerHelpers

  def index() do
    "https://www.pracuj.pl/praca"
  end
  
  def offer_base() do
    "https://www.pracuj.pl"
  end

  def include(:remote) do
    "rw=true"
  end
  
  @doc """
  The html marker that holds all information needed for scrapping.
  """
  def bigcontainer() do
    "div#results ul.results__list-container"
  end
  
  @doc """
  The html selector, that each of corresponding markers hold all information about one offer.
  """
  def one_result_container() do
    "li.results__list-container-item"
  end

  def search_atom() do
    "div.offer-details__text"
  end

  def search_item_a() do
    "offer-details__title-link"
  end

  @doc """
  Finds internal id of a pracuj.pl offer.
  """
  def id_from_relative_href(relative_link) do
    [_, string_id] = String.split(relative_link, ",oferta,")
    {id, ""} = Integer.parse(string_id)
    id
  end

  def header_selector() do
    "[data-test=section-offerHeader]"
  end

  def name_selector() do
    "[data-test=text-positionName]"
  end

  def offer_employer_url(html) do
    # IO.inspect html
    [div] = 
      Floki.find(html, "[data-test=section-employer-profile]")
    IO.puts inspect(div)
    FlokerHelpers.get_href(div)
  end

  def offer_status(div) do
    [small_div] =
      Floki.find(div, "[data-test=sections-benefit-expiration]")
    both_texts = Floki.text(small_div, sep: ";")
    case String.split(both_texts, ";") do
      [_offer_expired] ->
        {:expired, nil, nil}

      [_open_through, open_until] ->
        ending_date = polish_date_parser(open_until)
        opened_date = Date.add(ending_date, -30)
        {:open, opened_date, ending_date}
    end
  end

  def polish_date_parser(date_text) do
    polish_months = %{
      "styczeń" => 1,
      "luty" => 2,
      "marzec" => 3,
      "kwiecień" => 4,
      "maj" => 5,
      "czerwiec" => 6,
      "lipiec" => 7,
      "sierpień" => 8,
      "wrzesień" => 9,
      "październik" => 10,
      "listopad" => 11,
      "grudzień" => 12,
      "stycznia" => 1,
      "lutego" => 2,
      "marca" => 3,
      "kwietnia" => 4,
      "maja" => 5,
      "czerwca" => 6,
      "lipca" => 7,
      "sierpnia" => 8,
      "września" => 9,
      "października" => 10,
      "listopada" => 11,
      "grudnia" => 12,
    }
    [day, month, year] = String.split(date_text, " ")
    month = String.downcase(month)
    month = polish_months[month]
    {day, ""} = Integer.parse(day)
    {year, ""} = Integer.parse(year)
    {:ok, date} = Date.from_erl({year, month, day})
    date
  end

  def offer_address_text(div) do
    [address_selector] = Floki.find(div, "[data-test=sections-benefit-workplaces]")
    Floki.text(address_selector, sep: ";")
  end

  def actual_offer_selector() do
    "[data-test=section-desktopOfferContent]"
  end
end