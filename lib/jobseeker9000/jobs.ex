defmodule Jobseeker9000.Jobs do
  import Ecto.Query

  alias Jobseeker9000.Repo
  alias Jobseeker9000.Jobs.Offer
  alias Jobseeker9000.Jobs.Flag

# Offers

  def get_offer(id) do
    Repo.get(Offer, id)
  end

  def get_offer_by(params) do
    Repo.get_by(Offer, params)
  end

	def list_offers do
		Offer |> order_by(asc: :from) |> Repo.all()
	end

	def change_offer(%Offer{} = offer, params) do
		Offer.changeset(offer, params)
		|> Repo.update()
	end

	def create_offer(params \\ %{}) do
		%Offer{}
		|> Offer.changeset(params)
		|> Repo.insert()
	end

# Flags

  def get_flag(id) do
    Repo.get(Flag, id)
  end

  def get_flag_by(params) do
    Repo.get_by(Flag, params)
  end

	def list_flags do
		Flag |> Repo.all()
	end

	def change_flag(%Flag{} = flag, params) do
		Flag.changeset(flag, params)
		|> Repo.update()
	end

	def create_flag(params \\ %{}) do
		%Flag{}
		|> Flag.changeset(params)
		|> Repo.insert()
	end
end