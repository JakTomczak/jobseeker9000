defmodule Jobseeker9000.Jobs.Flag do
	alias Jobseeker9000.Repo
	import Ecto.Query, except: [update: 2]

	alias Jobseeker9000.Jobs.Offer

	@moduledoc """
	Flags represent parts of offers that users looks for.
	Presence of a given Flag for given Offer means that 
	this offer can be classified as being part od some category.
	"""

	defmodule Schema do
		use Jobseeker9000.Model
		
		schema "flag" do
			field :name, :string
			field :calls, :string
			many_to_many :offers, Offer.Schema, join_through: "offers_flags"
		end

		@schema_fields [
			:name,
			:calls
		]
		
		def changeset(flag, params) do
			flag
			|> cast(params, @schema_fields)
			|> validate_required(@schema_fields)
		end
	end

	@type t :: %Schema{
		name: String.t(),
		calls: String.t(),
		offers: [Offer.t()]
	}

	@doc """
	Creates a Flag from params.
	"""
	@spec create(map()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
	def create(params) do
		%Schema{}
		|> Schema.changeset(params)
		|> Repo.insert()
	end

	@doc """
	Gets the Flag from id.
	"""
	@spec get(binary()) :: {:ok, t()} | {:error, :not_found} | {:error, :nil_given}
	def get(nil), do: {:error, :nil_given}

	def get(id) do
		Schema
		|> Repo.get(id)
		|> case do
			nil -> {:error, :not_found}

			flag -> {:ok, flag}
		end
	end

	@doc """
	List all Flags.
	"""
	@spec list() :: [t()]
	def list() do
		Schema
		|> Repo.all()
	end

	# def list_offers(%Schema{} = flag) do
	# 	flag = Repo.preload(flag, :offers)
	# 	flag.offers
	# end
end