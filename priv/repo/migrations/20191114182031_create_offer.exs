defmodule Jobseeker9000.Repo.Migrations.CreateOffer do
  use Ecto.Migration

  def change do
    create table(:offer) do
      add :name, :string, null: false
      add :from, :naive_datetime, null: false
      add :ending, :naive_datetime
      add :found_on, :string, null: false
      add :url, :string, null: false
      add :state, :string
      add :company_id, references(:company)
    end
    create unique_index(:offer, [:url])
  end
end
