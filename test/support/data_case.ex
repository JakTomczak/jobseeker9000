defmodule Jobseeker9000.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Jobseeker9000.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Jobseeker9000.DataCase

      import Jobseeker9000.Factory

      @remote %{
        name: "Remote",
        type: "remote"
      }

      @poznan %{
        name: "Poznań",
        type: "place",
        latitude: 52.406374,
        longitude: 16.925168100000064,
        radius: 5
      }

      @warszawa %{
        name: "Warszawa",
        type: "place",
        latitude: 52.2296756,
        longitude: 21.012228700000037,
        radius: 10
      }

      @berlin %{
        name: "Berlin",
        type: "place",
        latitude: 52.52000659999999,
        longitude: 13.404953999999975,
        radius: 15
      }

      @programming %{
        calls: %{
          "default" => "Programming",
          "pracuj" => "programowanie;cc,5016003"
        },
        type: "category"
      }

      @elixir %{
        name: "Elixir",
        type: "keyword"
      }

      @matlab %{
        name: "Matlab",
        type: "keyword"
      }

      @full_time %{
        name: "Full time",
        type: "employment_type"
      }

      @part_time %{
        name: "Part time",
        type: "employment_type"
      }

      @dollars_2000 %{
        name: "More than $2000",
        type: "salary",
        calls: %{
          "default" => 2000,
          "pracuj" => 7500
        }
      }

      @euro_2500 %{
        name: "More than 2500 €",
        type: "salary",
        calls: %{
          "default" => 2750,
          "pracuj" => 1150
        }
      }
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Jobseeker9000.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Jobseeker9000.Repo, {:shared, self()})
    end

    :ok
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
