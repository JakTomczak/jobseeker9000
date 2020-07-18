defmodule Jobseeker9000.Jobs.FlagTest do
  use Jobseeker9000.DataCase

  alias Jobseeker9000.Jobs.Flag
  alias Jobseeker9000.Jobs.Flag.Schema

  @dummy_name "dummy"

  @flag %{
    "name" => @dummy_name,
    "calls" => "some calls"
  }

  describe "Flag create/1" do
    test "with valid data" do
      params = @flag

      assert {:ok, %Schema{name: @dummy_name}} = Flag.create(params)
    end

    test "with invalid data" do
      params = Map.delete(@flag, "name")
      assert {:error, _changeset} = Flag.create(params)

      params = Map.delete(@flag, "calls")
      assert {:error, _changeset} = Flag.create(params)
    end
  end

  describe "Flag get/1" do
    test "when company exists" do
      %{id: id} = insert(:flag)

      assert {:ok, %Schema{id: ^id}} = Flag.get(id)
    end

    test "with unknown id" do
      assert {:error, :not_found} = Flag.get(Ecto.UUID.generate())
    end

    test "when nil given" do
      assert {:error, :nil_given} = Flag.get(nil)
    end
  end

  describe "Flag list/0" do
    test "when companies exist" do
      insert_pair(:flag)

      assert [%Schema{}, %Schema{}] = Flag.list()
    end

    test "when no company exists" do
      assert [] = Flag.list()
    end
  end
end
