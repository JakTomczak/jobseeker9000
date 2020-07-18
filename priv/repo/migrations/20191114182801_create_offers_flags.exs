defmodule Jobseeker9000.Repo.Migrations.CreateOffersFlags do
  use Ecto.Migration

  def change do
    create table(:offers_flags) do
      add :offer_id, references(:offer)
      add :flag_id, references(:flag)
    end

    create unique_index(:offers_flags, [:offer_id, :flag_id], name: :flag_for_offer)
  end
end
