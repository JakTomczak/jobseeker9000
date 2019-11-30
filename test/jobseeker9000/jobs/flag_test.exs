defmodule Jobseeker9000.Jobs.FlagTest do
  use Jobseeker9000.DataCase

  alias Jobseeker9000.Jobs
  alias Jobseeker9000.JobsHelpers

  @dummy_name "dummy"
  @calls1 "dummy;dummies"
  @calls2 "call;calls"
  @wrong_id 999
  @wrong_name "wrong"
  @invalid_attrs %{
    name: nil
  }

  describe "jobs . create/2 flag" do
    test "with valid data" do
      {:ok, %Jobs.Flag{} = flag} =
        %{name: @dummy_name}
        |> JobsHelpers.maybe_get_defaults(:flag)
        |> Jobs.create(:flag)
      assert flag.name == @dummy_name
    end

    test "with invalid data" do
      assert {:error, %Ecto.Changeset{valid?: false}} = Jobs.create(:flag)
    end
  end

  describe "jobs . change/2 flag" do
    setup do
      {:ok, %Jobs.Flag{} = flag} =
        JobsHelpers.maybe_get_defaults(:flag)
        |> Jobs.create(:flag)
      [flag: flag]
    end

    test "with valid data", context do
      assert {:ok, %Jobs.Flag{name: @dummy_name}}
        = Jobs.change(context[:flag], %{name: @dummy_name})
    end

    test "with invalid data", context do
      assert {:error, %Ecto.Changeset{valid?: false}} = Jobs.change(context[:flag], @invalid_attrs)
    end
  end

  describe "jobs . list/1 flag" do
    setup context do
      if context[:seed] == :yes do
        %{calls: @calls1}
        |> JobsHelpers.maybe_get_defaults(:flag)
        |> Jobs.create(:flag)
        %{calls: @calls2}
        |> JobsHelpers.maybe_get_defaults(:flag)
        |> Jobs.create(:flag)
      end
      :ok
    end

    @tag seed: :yes
    test "when two records exist" do
      assert [%Jobs.Flag{calls: @calls1}, %Jobs.Flag{calls: @calls2}]
        = Jobs.list(:flag)
    end

    @tag seed: :no
    test "when no records exist" do
      assert [] == Jobs.list(:flag)
    end
  end

  describe "jobs . get/2 flag" do
    setup do
      {:ok, %Jobs.Flag{} = flag} =
        JobsHelpers.maybe_get_defaults(:flag)
        |> Jobs.create(:flag)
      [id: flag.id, flag: flag]
    end

    test "by valid id", context do
      assert context[:flag] == Jobs.get(:flag, context[:id])
    end

    test "by invalid id", context do
      assert context[:id] != @wrong_id
      assert nil == Jobs.get(:flag, @wrong_id)
    end
  end

  describe "jobs . get_by/2 flag" do
    setup do
      {:ok, %Jobs.Flag{} = flag} =
        %{name: @dummy_name}
        |> JobsHelpers.maybe_get_defaults(:flag)
        |> Jobs.create(:flag)
      [flag: flag]
    end

    test "when matched", context do
      assert context[:flag] == Jobs.get_by(:flag, name: @dummy_name)
    end

    test "when wrongly matched" do
      assert is_nil( Jobs.get_by(:flag, name: @wrong_name) )
    end
  end
end