defmodule Jobseeker9000.Floker.Poisoner do
  defp get_pracuj_url() do
    url = "https://www.pracuj.pl/praca?rw=true"
  end

  def get_body(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "404 - Page not found when invoking #{get_pracuj_url()}."}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
