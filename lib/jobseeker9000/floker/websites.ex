defmodule Jobseeker9000.Floker.Websites do
  alias Jobseeker9000.Floker.Context

  @modules %{
    pracuj: Jobseeker9000.Floker.Websites.Pracuj
  }
  def module(what) do
    @modules[what]
  end

  def available_websites() do
    [
      :pracuj
    ]
  end

  def search_url(%Context{} = context, module) do
    not_empty = Context.get_not_empty(context)

    do_search_url(context, module, not_empty)
  end

  defp do_search_url(_context, module, []) do
    apply(module, :index, [])
  end

  defp do_search_url(context, module, not_empty) do
    not_empty = [:question_mark | not_empty]

    index_url = apply(module, :index, [])

    order =
      apply(module, :url_order, [])
      |> Enum.filter(fn atom -> Enum.member?(not_empty, atom) end)

    order =
      if List.last(order) == :question_mark do
        List.delete_at(order, length(order) - 1)
      else
        order
      end

    order
    |> Enum.map(fn atom ->
      apply(module, :url_query, [atom, Map.get(context, atom)])
    end)
    |> Enum.reduce(index_url, fn part, acc ->
      acc <> part
    end)
  end
end
