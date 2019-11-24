defmodule Jobseeker9000.Jobs do
  import Ecto.Query

  alias Jobseeker9000.Repo
  alias Jobseeker9000.Jobs.Offer
  alias Jobseeker9000.Jobs.Flag
  alias Jobseeker9000.Jobs.Company

	def get(:offer, id), do: Repo.get(Offer, id)
	def get(:flag, id), do: Repo.get(Flag, id)
	def get(:company, id), do: Repo.get(Company, id)

	def get_by(:offer, params), do: Repo.get_by(Offer, params)
	def get_by(:flag, params), do: Repo.get_by(Flag, params)
	def get_by(:company, params), do: Repo.get_by(Company, params)

	def list(:offer), do: Offer |> order_by(asc: :from) |> Repo.all()
	def list(:flag), do: Flag |> Repo.all()
	def list(:company), do: Company |> Repo.all()

	def change(%Offer{} = offer, params), do: Offer.changeset(offer, params) |> Repo.update()
	def change(%Flag{} = flag, params), do: Flag.changeset(flag, params) |> Repo.update()
	def change(%Company{} = company, params), do: Company.changeset(company, params) |> Repo.update()

	def create(nil, params \\ %{}), do: nil
	def create(:offer, params) do
		%Offer{}
		|> Offer.changeset(params)
		|> Repo.insert()
	end
	def create(:flag, params) do
		%Flag{}
		|> Flag.changeset(params)
		|> Repo.insert()
	end
	def create(:company, params) do
		%Company{}
		|> Company.changeset(params)
		|> Repo.insert()
	end
end