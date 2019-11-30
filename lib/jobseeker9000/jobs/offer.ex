defmodule Jobseeker9000.Jobs.Offer do
	use Ecto.Schema
	import Ecto.Changeset
	
	schema "offer" do
		field :name, :string
		field :from, :naive_datetime
		field :ending, :naive_datetime
		field :found_on, :string
		field :url, :string
    field :state, :string
		belongs_to :company, Jobseeker9000.Jobs.Company
    many_to_many :flags, Jobseeker9000.Jobs.Flag, join_through: "offers_flags"
	end
	
	def changeset(offer, params) do
		offer
		|> cast(params, [:name, :from, :ending, :found_on, :url, :state, :company_id])
		|> validate_required([:name, :from, :found_on, :url])
	end

	def changeset_updating_flags(offer, flags) do
		offer
		|> changeset(%{})
		|> put_assoc(:flags, flags)
	end
end