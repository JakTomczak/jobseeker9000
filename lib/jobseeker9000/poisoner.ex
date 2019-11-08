defmodule Jobseeker9000.Poisoner do
  defp get_pracuj_url() do
    url = "https://www.pracuj.pl/praca?rw=true"
  end

  def poison_pracuj() do
    case HTTPoison.get( get_pracuj_url() ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body: body}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, reason: "404 - Page not found when invoking #{get_pracuj_url()}."}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason: reason}
    end
  end
end