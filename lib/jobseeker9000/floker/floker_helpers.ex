defmodule Jobseeker9000.Floker.FlokerHelpers do
  alias Jobseeker9000.Floker

  def unpack!({_, _, [inside]}), do: inside
  def unpack!([value]), do: value

  @doc """
  Test function to perform actions only on the first one_result_container.
  """
  def test_on_first(%Floker{state: :error} = floker), do: floker
  def test_on_first(%Floker{all_the_lis: []} = floker), do: floker

  def test_on_first(%Floker{all_the_lis: [h | _]} = floker) do
    %{floker | all_the_lis: [h]}
  end

  @doc """
  Finds the url.
  Returns error if no hyperlink is found within given marker
    or if more than one such hyperlink is found.
  """
  def get_href(html, %{a_class: a_class}) do
    Floki.attribute(html, "a.#{a_class}", "href")
    |> get_one_href(" with class #{a_class}")
  end

  def get_href(html) do
    Floki.attribute(html, "a", "href")
    |> get_one_href("")
  end

  defp get_one_href(nodes, custom_message) do
    case length(nodes) do
      0 ->
        raise RuntimeError, message: "No 'a'#{custom_message} found"

      1 ->
        unpack!(nodes)

      _more ->
        raise RuntimeError, message: "There exists more than one 'a'#{custom_message}"
    end
  end

  @doc """
  Changes relative link to a full one.
  """
  def full_link_from_relative(module, relative_link) do
    apply(module, :offer_base, []) <> relative_link
  end
end
