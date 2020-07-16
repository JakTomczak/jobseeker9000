defmodule Jobseeker9000.Factory do
  use ExMachina.Ecto, repo: Jobseeker9000.Repo

  def company_factory do
    %Jobseeker9000.Jobs.Company.Schema{
      name: "factory built name",
		  found_on: "factory built found_on",
		  url: sequence(:company_url, &"factory built url #{&1}")
    }
  end

  def flag_factory do
    %Jobseeker9000.Jobs.Flag.Schema{
      name: "factory built name",
		  calls: "factory built calls",
		  offers: []
    }
  end

  def offer_factory do
    %Jobseeker9000.Jobs.Offer.Schema{
      company: build(:company),
      name: "factory built name",
			from: Date.utc_today(),
			ending: Date.utc_today() |> Date.add(30),
			found_on: "pracuj",
			url: sequence(:offer_url, &"factory built url #{&1}"),
			state: "closed"
    }
  end
end