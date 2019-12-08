defmodule Jobseeker9000.Jobs.Company do
	use Ecto.Schema
	import Ecto.Changeset
	
	schema "company" do
		field :name, :string
		field :found_on, :string
		field :url, :string
		has_many :offers, Jobseeker9000.Jobs.Offer
	end
	
	def changeset(company, params) do
		company
		|> cast(params, [:name, :found_on, :url])
		|> validate_required([:name, :found_on, :url])
	end

	def changeset_updating_offer(company, offers) do
		company
		|> changeset(%{})
		|> put_assoc(:offers, offers ++ company.offers)
	end
end