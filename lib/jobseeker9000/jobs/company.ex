defmodule Jobseeker9000.Jobs.Company do
	alias Jobseeker9000.Repo
	import Ecto.Query, except: [update: 2]
	
	alias Jobseeker9000.Jobs.Offer

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
			has_many :offers, Offer.Schema, foreign_key: :company_id
		end

		@schema_fields [
			:name,
			:found_on,
			:url
		]
		
		def changeset(company, params) do
			company
			|> cast(params, @schema_fields)
			|> validate_required(@schema_fields)
			|> unique_constraint(:url, name: :url_of_the_company)
		end

		# def add_new_offers_changeset(company, offers) do
		# 	company
		# 	|> change()
		# 	|> put_assoc(:offers, offers ++ company.offers)
		# end
	end

	@type t :: %Schema{
		name: String.t(),
		found_on: String.t(),
		url: String.t(),
		offers: [Offer.t()]
	}

	@doc """
	Creates a Company from params.
	"""
	@spec create(map()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
	def create(params) do
		%Schema{}
		|> Schema.changeset(params)
		|> Repo.insert()
	end

	@doc """
	Gets the Company from id.
	"""
	@spec get(binary()) :: {:ok, t()} | {:error, :not_found} | {:error, :nil_given}
	def get(nil), do: {:error, :nil_given}

	def get(id) do
		Schema
		|> Repo.get(id)
		|> case do
			nil -> {:error, :not_found}

			company -> {:ok, company}
		end
	end

	@doc """
	List all Companies.
	"""
	@spec list() :: [t()]
	def list() do
		Schema
		|> Repo.all()
	end

	# @doc """
	# Make given list of Offers children of given Company.
	# """
	# @spec add_new_offers(t(), [Ecto.Schema.t()]) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
	# def add_new_offers(%Schema{} = company, offers) when is_list(offers) do
	# 	company
	# 	|> Repo.preload(:offers)
	# 	|> Schema.add_new_offers_changeset(offers)
	# 	|> Repo.update()
	# end
end