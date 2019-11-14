defmodule Jobseeker9000.Jobs do

  alias Jobseeker9000.Repo
  alias Jobseeker9000.Jobs.Offer
  import Ecto.Query

  def get_offer(id) do
    Repo.get(Offer, id)
  end

  def get_offer_by(params) do
    Repo.get_by(Offer, params)
  end

	def list_Offers do
		Offer |> order_by(desc: :id) |> Repo.all()
	end

	# def change_offer(%Offer{} = project, params) do
	# 	Offer.changeset(project, params)
	# 	|> Repo.update()
	# end

	# def create_offer(params \\ %{}) do
	# 	%Offer{}
	# 	|> Offer.changeset(params)
	# 	|> Repo.insert()
	# end
end