defmodule Jobseeker9000.Jobs.Flag do
	use Ecto.Schema
	import Ecto.Changeset
	
	schema "flag" do
		field :name, :string
		field :calls, :string
		many_to_many :offers, Jobseeker9000.Jobs.Offer, join_through: "offers_flags"
	end
	
	# def changeset(offer, params) do
	# 	offer
	# 	|> cast(params, [:name, :from, :ending, :found_on, :url])
	# 	|> validate_required([:name, :from, :found_on, :url])
	# end
end