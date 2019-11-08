defmodule Jobseeker9000.Floker.Pracuj do

  def test_on_first([]), do: nil
  def test_on_first([h | _]), do: [h]

  defp encode({_, _, [inside]}) do
    IO.inspect inside
  end

  defp get_results(html) do
    Floki.find(html, "div#results")
  end

  defp for_each_li({_, _, [inside]}) do
    Floki.find(inside, "div.offer-details__text")
    |> extract_basic_info_from_div()
  end

  defp href_given_class(html, class) do
    [href | more_than_one] = Floki.attribute(html, "a.#{class}", "href")
    if more_than_one != [] do
      IO.puts "There exists more_than_one."
      IO.inspect more_than_one
    end
    href
  end

  defp full_link_from_relative(link) do
    "https://www.pracuj.pl" <> link
  end

  defp id_from_relative(link) do
    [_, string_id] = String.split(link, ",oferta,")
    case Integer.parse(string_id) do
      {id, ""} -> id
      _ -> raise "ID couldn't be decoded: #{link}"
    end
  end

  defp extract_basic_info_from_div(div) do
    # [relative_link] = Floki.attribute( Floki.find(div, "a.offer-details__title-link"), "href" )
    relative_link = href_given_class(div, "offer-details__title-link")
    full_link = full_link_from_relative(relative_link)
    id = id_from_relative(relative_link)
    # [_, string_id] = String.split(relative_link, ",oferta,")
    # {id, _} = Integer.parse(string_id)
    IO.inspect [full_link, id] 
    IO.inspect relative_link
    # offer-company__name
  end

  def run(html) do
    get_results(html)
    |> Floki.find("li.results__list-container-item")
    |> test_on_first()
    |> Enum.each(&for_each_li/1)
    # "ok"
    |> IO.inspect
    "ok"
  end
end