defmodule Jobseeker9000.Floker.Context do
  defstruct place: nil,
            radius: nil,
            remote: false,
            categories: [],
            keywords: [],
            employment_type: nil,
            salary_min: nil

  def make(list_of_flags) do
    %__MODULE__{}
    |> make(list_of_flags)
  end

  def make(%__MODULE__{} = context, []), do: context

  def make(%__MODULE__{} = context, [flag | the_rest]) do
    context = 
      case flag.type do
        "remote" -> add_remote(context, flag)

        "place" -> add_place(context, flag)

        "category" -> add_category(context, flag)

        "keyword" -> add_keyword(context, flag)

        "employment_type" -> add_employment_type(context, flag)

        "salary" -> add_salary(context, flag)
      end
    
    make(context, the_rest)
  end

  def get_not_empty(%__MODULE__{} = context) do
    map = %{
      place: not is_nil(context.place),
      radius: not is_nil(context.place),
      remote: context.remote,
      categories: [] != context.categories,
      keywords: [] != context.keywords,
      employment_type: not is_nil(context.employment_type),
      salary_min: not is_nil(context.salary_min)
    }
    :maps.filter(fn _key, value -> value end, map)
    |> Map.keys()
  end

  defp add_remote(context, flag) do
    %{
      context |
      remote: true
    }
  end

  defp add_place(context, flag) do
    %{
      context |
      place: flag.name,
      radius: flag.radius
    }
  end

  defp add_category(context, flag) do
    %{
      context |
      categories: [
        flag.calls | 
        context.categories
      ]
    }
  end

  defp add_keyword(context, flag) do
    %{
      context |
      keywords: [
        flag.name | 
        context.keywords
      ]
    }
  end

  defp add_employment_type(context, flag) do
    %{
      context |
      employment_type: flag.name
    }
  end

  defp add_salary(context, flag) do
    %{
      context |
      salary_min: flag.calls
    }
  end
end