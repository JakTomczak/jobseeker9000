defmodule Jobseeker9000.Jobs.Offer do
	use Jobseeker9000.Model
  alias Jobseeker9000.Repo
	
	schema "offer" do
		field :name, :string
		field :from, :naive_datetime
		field :ending, :naive_datetime
		field :found_on, :string
		field :url, :string
    field :state, :string
		belongs_to :company, Jobseeker9000.Jobs.Company.Schema
    many_to_many :flags, Jobseeker9000.Jobs.Flag, join_through: "offers_flags", on_replace: :delete
	end
	
	def changeset(offer, params) do
		offer
		|> cast(params, [:name, :from, :ending, :found_on, :url, :state, :company_id])
		|> validate_required([:name, :from, :found_on, :url])
	end

	def changeset_setting_flags(offer, flags) do
		offer
		|> changeset(%{})
		|> put_assoc(:flags, flags)
	end

	def changeset_putting_new_flag(offer, flag) do
		offer
		|> change()
		|> put_assoc(:flags, [flag | offer.flags])
	end
end