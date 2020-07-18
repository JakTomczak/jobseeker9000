defmodule Jobseeker9000.Floker.Websites.Pracuj do
  alias Jobseeker9000.Floker.FlokerHelpers

  def any_found?(html) do
    html
    |> Floki.find(".results-header.results-header__no-offers")
    |> length()
    |> case do
      0 -> true
      _ -> false
    end
  end

  def url_order() do
    [
      :keywords,
      :place,
      :categories,
      :question_mark,
      :radius,
      :salary_min,
      :remote,
      :employment_type
    ]
  end

  def index() do
    "https://www.pracuj.pl/praca/"
  end

  def offer_base() do
    "https://www.pracuj.pl"
  end

  def url_include(:remote) do
    "rw=true"
  end

  def url_include(:place, place) do
    "rw=true"
  end

  def url_query(atom, context) when is_list(context) do
    url_query(atom, context, "")
  end

  def url_query(:keywords, [], url), do: url

  def url_query(:keywords, [keyword | the_rest], url) do
    url = url <> "#{keyword};kw/"

    url_query(:keywords, the_rest, url)
  end

  def url_query(:place, name) do
    "#{name};wp/"
  end

  def url_query(:categories, [], url), do: url

  def url_query(:categories, [calls | the_rest], url) do
    call = calls["pracuj"] || calls["default"]

    if is_nil(call) do
      url_query(:categories, the_rest, url)
    else
      url = url <> call <> "/"

      url_query(:categories, the_rest, url)
    end
  end

  def url_query(:question_mark, nil), do: "?"

  def url_query(:radius, radius) do
    "rd=#{radius}&"
  end

  def url_query(:salary_min, salary) do
    amount = salary["pracuj"] || salary["default"]

    if is_nil(amount) do
      ""
    else
      "sal=#{amount}&"
    end
  end

  def url_query(:remote, true) do
    "rw=true&"
  end

  def url_query(:employment_type, "Full time") do
    "ws=0&"
  end

  def url_query(:employment_type, "Part time") do
    "ws=1&"
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
    nil
  end

  def offer_status(div) do
    [small_div] = Floki.find(div, "[data-test=sections-benefit-expiration]")
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
      "grudnia" => 12
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
