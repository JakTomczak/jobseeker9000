defmodule Jobseeker9000.Floker.Context do
  defstruct place: %{type: nil},
            keys: [],
            employment_type: nil,
            salary_min: %{currency: nil}

  alias Jobseeker9000.Floker.Websites 

  def make(list_of_flags) do
    make(%__MODULE__{}, list_of_flags)
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

  defp add_remote(context, flag) do
    %{
      context |
      place: %{type: :remote}
    }
  end

  defp add_place(context, flag) do
    %{
      context |
      place: %{
        type: :place,
        name: flag.name,
        latitude: flag.latitude,
        longitude: flag.longitude,
        radius: flag.radius
      }
    }
  end

  defp add_category(context, flag) do
    %{
      context |
      keys: [
        %{type: :category, name: flag.name} | 
        context.keys
      ]
    }
  end

  defp add_keyword(context, flag) do
    %{
      context |
      keys: [
        %{type: :keyword, calls: flag.calls} | 
        context.keys
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
      salary_min: %{
        amount: flag.amount,
        currency: flag.currency
      }
    }
  end
end