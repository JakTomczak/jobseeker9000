defmodule Jobseeker9000.Factory do
  use ExMachina.Ecto, repo: Jobseeker9000.Repo

  def company_factory do
    %Jobseeker9000.Jobs.Company.Schema{
      name: "factory built name",
		  found_on: "factory built found_on",
		  url: sequence(:company_url, &"factory built url #{&1}")
    }
  end
end