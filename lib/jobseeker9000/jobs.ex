defmodule Jobseeker9000.Jobs do
  import Ecto.Query

  alias Jobseeker9000.Repo
  alias Jobseeker9000.Jobs.Offer
  alias Jobseeker9000.Jobs.Flag
  alias Jobseeker9000.Jobs.Company

	# Common:

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

	def create(params \\ %{}, what)
	def create(params, :offer) do
		%Offer{}
		|> Offer.changeset(params)
		|> Repo.insert()
	end
	def create(params, :flag) do
		%Flag{}
		|> Flag.changeset(params)
		|> Repo.insert()
	end
	def create(params, :company) do
		%Company{}
		|> Company.changeset(params)
		|> Repo.insert()
	end

	# Offer specific:

	def set_flags(%Offer{} = offer, %Flag{} = flag), do: set_flags(offer, [flag])
	def set_flags(%Offer{} = offer, flags) when is_list(flags) do
		offer
		|> Repo.preload(:flags)
		|> Offer.changeset_setting_flags(flags)
		|> Repo.update()
	end

	def put_new_flag(%Offer{} = offer, %Flag{} = flag) do
		offer
		|> Repo.preload(:flags)
		|> Offer.changeset_putting_new_flag(flag)
		|> Repo.update()
	end

	def list_flags(%Offer{} = offer) do
		offer = Repo.preload(offer, :flags)
		offer.flags
	end

	def get_company(%Offer{} = offer) do
		offer = Repo.preload(offer, :company)
		offer.company
	end

	# Company specific:

	def link_offers(%Company{} = company, %Offer{} = offer), do: link_offers(company, [offer])
	def link_offers(%Company{} = company, offers) when is_list(offers) do
		company
		|> Repo.preload(:offers)
		|> Company.changeset_updating_offer(offers)
		|> Repo.update()
	end

	# Flag specific:

	def list_offers(%Flag{} = flag) do
		flag = Repo.preload(flag, :offers)
		flag.offers
	end
end