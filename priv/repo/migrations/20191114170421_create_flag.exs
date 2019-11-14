defmodule Jobseeker9000.Repo.Migrations.CreateFlag do
  use Ecto.Migration

  def change do
    create table(:flag) do
      add :name, :string, null: false
      add :calls, :string, null: false
    end
  end
end
