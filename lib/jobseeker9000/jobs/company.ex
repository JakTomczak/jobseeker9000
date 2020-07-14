defmodule Jobseeker9000.Jobs.Company do
	alias Jobseeker9000.Repo
	import Ecto.Query, except: [update: 2]

	@moduledoc """
	Company which makes a job offer.
	Company may have many offers.
	"""

	defmodule Schema do
		use Jobseeker9000.Model
		
		schema "company" do
			field :name, :string
			field :found_on, :string
			field :url, :string
			has_many :offers, Jobseeker9000.Jobs.Offer, foreign_key: :company_id
		end

		@schema_fields [
			:name,
			:found_on,
			:url
		]
		
		def changeset(company, params) do
			company
			|> cast(params, @fields])
			|> validate_required(@fields)
		end

		def add_new_offers_changeset(company, offers) do
			company
			|> change()
			|> put_assoc(:offers, offers ++ company.offers)
		end
	end

	@type t :: %Schema{
		name: :string,
		found_on: :string,
		url: :string
	}

	@spec create(map()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
	def create(params) do
		%Schema{}
		|> Schema.changeset(params)
		|> Repo.insert()
	end
end