defmodule Jobseeker9000.Repo.Migrations.CreateCompany do
  use Ecto.Migration

  def change do
    create table(:company) do
      add :name, :string, null: false
      add :found_on, :string, null: false
      add :url, :string, null: false
    end

    create unique_index(:company, [:url], name: :url_of_the_company)
  end
end
