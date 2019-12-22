defmodule Jobseeker9000.Floker.Websites.Pracuj do

  def index() do
    "https://www.pracuj.pl/praca"
  end
  
  def offer_base() do
    "https://www.pracuj.pl/praca"
  end

  def include(:remote) do
    "rw=true"
  end
  
  """
  bigcontainer - The html marker that holds all information needed for scrapping.
  one_result_container - The html markers pattern,
    that each of corresponding markers hold all information about one offer.
  """

  def bigcontainer() do
    "div#results ul.results__list-container"
  end

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
end