defmodule Jobseeker9000.Jobs.Flag do
	use Jobseeker9000.Model
	
	schema "flag" do
		field :name, :string
		field :calls, :string
		many_to_many :offers, Jobseeker9000.Jobs.Offer, join_through: "offers_flags"
	end
	
	def changeset(flag, params) do
		flag
		|> cast(params, [:name, :calls])
		|> validate_required([:name, :calls])
	end
end