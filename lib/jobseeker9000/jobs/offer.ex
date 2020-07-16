defmodule Jobseeker9000.Jobs.Offer do
	alias Jobseeker9000.Repo
	import Ecto.Query, except: [update: 2]

	alias Jobseeker9000.Jobs.Company
	alias Jobseeker9000.Jobs.Flag

	@moduledoc """
	Job offer - central part of the application.
	Every Offer is child of a Company.
	Every Offer may have many Flags.
	"""

	defmodule Schema do
		use Jobseeker9000.Model
	
		schema "offer" do
			belongs_to :company, Company.Schema

			field :name, :string
			field :from, :date
			field :ending, :date
			field :found_on, :string
			field :url, :string
			field :state, :string

			many_to_many :flags, Flag.Schema, join_through: "offers_flags", on_replace: :delete
		end

		@schema_fields [
			:name,
			:from,
			:ending,
			:found_on,
			:url,
			:state
		]

		@required_fields [
			:company,
			:name,
			:from,
			:found_on,
			:url
		]
		
		def changeset(offer, company, params) do
			offer
			|> cast(params, @schema_fields)
			|> put_assoc(:company, company)
			|> validate_required(@required_fields)
			|> unique_constraint(:url, name: :url_of_the_offer)
		end

		# def changeset_setting_flags(offer, flags) do
		# 	offer
		# 	|> changeset(%{})
		# 	|> put_assoc(:flags, flags)
		# end

		# def changeset_putting_new_flag(offer, flag) do
		# 	offer
		# 	|> change()
		# 	|> put_assoc(:flags, [flag | offer.flags])
		# end
	end

	@type t :: %Schema{
		company: Company.t(),
		name: String.t(),
		from: Date.t(),
		ending: Date.t(),
		found_on: String.t(),
		url: String.t(),
		state: String.t(),
		flags: [Flag.t()]
	}

	@doc """
	Creates an Offer from params as a child of given Company.
	"""
	@spec create(Company.t(), map()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
	def create(company, params) do
		%Schema{}
		|> Schema.changeset(company, params)
		|> Repo.insert()
	end

	@doc """
	Gets the Offer from id.
	"""
	@spec get(binary()) :: {:ok, t()} | {:error, :not_found} | {:error, :nil_given}
	def get(nil), do: {:error, :nil_given}

	def get(id) do
		Schema
		|> Repo.get(id)
		|> case do
			nil -> {:error, :not_found}

			offer -> {:ok, offer}
		end
	end

	@doc """
	List all Offers.
	"""
	@spec list() :: [t()]
	def list() do
		Schema
		|> Repo.all()
	end

	# def set_flags(%Offer{} = offer, %Flag.Schema{} = flag), do: set_flags(offer, [flag])
	# def set_flags(%Offer{} = offer, flags) when is_list(flags) do
	# 	offer
	# 	|> Repo.preload(:flags)
	# 	|> Offer.changeset_setting_flags(flags)
	# 	|> Repo.update()
	# end

	# def put_new_flag(%Offer{} = offer, %Flag.Schema{} = flag) do
	# 	offer
	# 	|> Repo.preload(:flags)
	# 	|> Offer.changeset_putting_new_flag(flag)
	# 	|> Repo.update()
	# end
end