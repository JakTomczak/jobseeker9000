defmodule Jobseeker9000.Floker.Pracuj.Search do
  alias Jobseeker9000.Floker.Pracuj
  
  """
  bigcontainer - The html marker that holds all information needed for scrapping.
  one_result_container - The html markers pattern,
    that each of corresponding markers hold all information about one offer.
  """
  @bigcontainer "div#results ul.results__list-container"
  @one_result_container "li.results__list-container-item"

  defp unpack!({_, _, [inside]}), do: inside
  defp unpack!([value]), do: value

  @doc """
  Scraps full html to find bigcontainer and than changes scope to this marker.
  If bigcontainer is not found, returns an error.
  """
  defp get_results(%Pracuj{state: :error} = pracuj), do: pracuj
  defp get_results(%Pracuj{state: :ok, full_html: html} = pracuj) do
    case Floki.find(html, @bigcontainer) do
      [] -> %{pracuj | state: :error, error_text: "Bigcontainer node: '" <> @bigcontainer <> "' not found."}
      div -> %{pracuj | full_html: div}
    end
  end

  @doc """
  Scraps bigcontainer to find list of one_result_container-s.
  """
  defp find_lis(%Pracuj{state: :error} = pracuj), do: pracuj
  defp find_lis(%Pracuj{state: :ok, full_html: html} = pracuj) do
    %{ pracuj | all_the_lis: Floki.find(html, @one_result_container) }
  end

  @doc """
  Test function to perform actions only on the first one_result_container.
  """
  defp test_on_first(%Pracuj{state: :error} = pracuj), do: pracuj
  defp test_on_first(%Pracuj{state: :ok, all_the_lis: []} = pracuj), do: pracuj
  defp test_on_first(%Pracuj{state: :ok, all_the_lis: [h | _]} = pracuj) do
    %{pracuj | all_the_lis: [h]}
  end

  @doc """
  Recursive function to perform actions on each one_result_container.
  When stumbled across an error, stops the recursion and returns this error.
  """
  defp li_crawler(%Pracuj{state: :error} = pracuj), do: pracuj
  defp li_crawler(%Pracuj{state: :ok, all_the_lis: []} = pracuj), do: pracuj
  defp li_crawler(%Pracuj{state: :ok, all_the_lis: [head | tail], results: results} = pracuj) do
    case for_each_li(head) do
      %{error: nil, value: nil, relative_link: relative_link, full_link: full_link, id: id} ->
        offer = %{relative_link: relative_link, full_link: full_link, id: id}
        li_crawler( %{ pracuj | all_the_lis: tail, results: [offer | results] } )
      %{error: error_text, value: value} ->
        %{ pracuj | state: :error, error_text: error_text, error_values: value }
    end
  end

  @doc """
  Performs list of actions on every one_result_container.
  """
  defp for_each_li({_, _, [inside]}) do
    case Floki.find(inside, "div.offer-details__text") do
      [] -> %{error: "No div with class 'offer-details__text' found.", value: %{parent_tree: inside}}
      [div | _] -> extract_basic_info_from_div(div)
    end
  end

  @doc """
  Scraps every marker to find the actual data.
  """
  defp extract_basic_info_from_div(div) do
    %{error: nil, value: nil, relative_link: "", full_link: "", id: -1}
    |> href_given_class(div, "offer-details__title-link")
    |> full_link_from_relative()
    |> id_from_relative()
  end

  @doc """
  Finds the url of the offer.
  Returns error if no hyperlink is found within given marker
    or if more than one such hyperlink is found.
  """
  defp href_given_class(%{error: error} = values, _, _) when is_binary(error), do: values
  defp href_given_class(%{error: nil} = values, html, class) do
    nodes = Floki.attribute(html, "a.#{class}", "href")
    case length(nodes) do
      0 -> %{values | error: "No a with class '#{class}' found", value: %{parent_tree: html}}
      1 -> %{values | relative_link: unpack!(nodes)}
      _ -> %{values | error: "There exists more than one a with class '#{class}'", value: %{parent_tree: html, as: nodes}}
    end
  end

  @doc """
  Changes relative link to a full one.
  """
  defp full_link_from_relative(%{error: error} = values) when is_binary(error), do: values
  defp full_link_from_relative(%{error: nil, relative_link: relative_link} = values) do
    %{values | full_link: Pracuj.website() <> relative_link}
  end

  @doc """
  Finds internal id of a pracuj.pl offer. What for? Idunno.
  """
  defp id_from_relative(%{error: error} = values) when is_binary(error), do: values
  defp id_from_relative(%{error: nil, relative_link: relative_link} = values) do
    splitted = String.split(relative_link, ",oferta,")
    if length(splitted) != 2 do
      %{values | error: "Spliting by ',oferta,' unsuccessful", value: %{relative_link: relative_link, result: splitted}}
    else
      [_, string_id] = splitted
      case Integer.parse(string_id) do
        {id, ""} -> %{values | id: id}
        _ ->  %{values | error: "ID couldn't be decoded", value: %{string_id: string_id}}
      end
    end
  end

  @test """
 <body><div id="results" class="example"><li class="results__list-container-item"><a class="lol" href="abba">abba</a></li><li class="results__list-container-item"><a href="ojcze">ojcze</a></li></div></body>
 """

  def run(html) do
    %Pracuj{state: :ok, full_html: html}
    |> get_results()
    |> find_lis()
    |> test_on_first()
    |> li_crawler()
    # |> IO.inspect
    "ok"
  end
end