defmodule Jobseeker9000.Repo.Migrations.CreateOffer do
  use Ecto.Migration

  def change do
    create table(:offer) do
      add :name, :string, null: false
      add :from, :date, null: false
      add :ending, :date
      add :found_on, :string, null: false
      add :url, :string, null: false
      add :state, :string
      add :company_id, references(:company)
    end
    create unique_index(:offer, [:url], name: :url_of_the_offer)
  end
end
