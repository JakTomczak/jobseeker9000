defmodule Jobseeker9000.Floker.Search do
  alias Jobseeker9000.Floker
  alias Jobseeker9000.Floker.FlokerHelpers

  @test """
 <body><div id="results" class="example"><li class="results__list-container-item"><a class="lol" href="abba">abba</a></li><li class="results__list-container-item"><a href="ojcze">ojcze</a></li></div></body>
 """

  def run(%Floker{} = floker) do
    floker
    |> get_results()
    |> find_lis()
    |> FlokerHelpers.test_on_first()
    |> li_crawler()
    # "ok"
  end

  @doc """
  Scraps full html to find bigcontainer and than changes scope to this marker.
  If bigcontainer is not found, returns an error.
  """
  defp get_results(%Floker{state: :error} = floker), do: floker
  defp get_results(%Floker{full_html: html} = floker) do
    bigcontainer = apply(floker.module, :bigcontainer, [])

    case Floki.find(html, bigcontainer) do
      [] -> 
        %{
          floker | 
          state: :error, 
          error_text: "Bigcontainer node: '#{bigcontainer}' not found."
        }
      div -> 
        %{floker | full_html: div}
    end
  end

  @doc """
  Scraps bigcontainer to find list of one_result_container-s.
  """
  defp find_lis(%Floker{state: :error} = floker), do: floker
  defp find_lis(%Floker{full_html: html} = floker) do
    one_result_container = apply(floker.module, :one_result_container, [])

    %{ floker | all_the_lis: Floki.find(html, one_result_container) }
  end

  @doc """
  Recursive function to perform actions on each one_result_container.
  When stumbled across an error, stops the recursion and returns this error.
  """
  defp li_crawler(%Floker{state: :error} = floker), do: floker
  defp li_crawler(%Floker{all_the_lis: []} = floker), do: floker
  defp li_crawler(%Floker{all_the_lis: [head | tail]} = floker) do

    case for_each_li(floker.module, head) do
      {:ok, offer} ->
        li_crawler( 
          %{ 
            floker | 
            all_the_lis: tail, 
            results: [offer | floker.results] 
          } 
        )

      {:error, error_text} ->
        %{ 
          floker | 
          state: :error, 
          error_text: error_text, 
          error_values: %{scope: head}
        }
    end
  end

  @doc """
  Performs list of actions on every one_result_container.
  """
  defp for_each_li(module, {_, _, [inside]}) do
    search_atom = apply(module, :search_atom, [])
    case Floki.find(inside, search_atom) do
      [] -> 
        {
          :error, 
          "No div with class '#{search_atom}' found."
        }

      [div] -> 
        extract_basic_info_from_div(module, div)
    end
  end

  @doc """
  Scraps marker to find the actual data.
  """
  defp extract_basic_info_from_div(module, div) do
    search_item_a = apply(module, :search_item_a, [])

    relative_link = FlokerHelpers.get_href( 
      div, 
      %{a_class: search_item_a} 
    )
    
    full_link = 
      FlokerHelpers.full_link_from_relative(
        module,
        relative_link
      )
    
    id = apply(module, :id_from_relative_href, [relative_link])

    {:ok, %{
      relative_link: relative_link, 
      full_link: full_link, 
      id: id
    }}
  rescue 
    e in RuntimeError ->
      {:error, e}
  end
end