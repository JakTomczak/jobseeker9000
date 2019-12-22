defmodule Jobseeker9000.JobsHelpers do
  alias Jobseeker9000.Jobs

  @offer_defaults %{
    name: "default offer",
		from: ~N[2019-12-22 12:00:00],
	  ending: ~N[2020-01-22 12:00:00],
		found_on: "default.pl",
		url: "default.pl/praca/1",
    state: "default"
  }

  @flag_defaults %{
    name: "default offer",
    calls: "default;defaults"
  }
  @company_defaults %{
    name: "default offer",
		found_on: "default.pl",
		url: "default.pl/firma/1"
  }

  @defaults %{
    offer: @offer_defaults,
    flag: @flag_defaults,
    company: @company_defaults
  }

  def maybe_get_defaults(what), do: @defaults[what]
  def maybe_get_defaults(what, params) when params == %{}, do: maybe_get_defaults(what)
  def maybe_get_defaults(what, params) do
    for {key, default} <- @defaults[what], into: %{}, do: {key, params[key] || default}
  end

  def mock(what, params \\ %{}) do
    {:ok, object} = 
    maybe_get_defaults(what, params)
    |> Jobs.create(what)

    object
  end
end