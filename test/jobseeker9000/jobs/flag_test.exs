defmodule Jobseeker9000.Jobs.FlagTest do
  use Jobseeker9000.DataCase

  alias Jobseeker9000.Jobs
  alias Jobseeker9000.Jobs.Flag

  @dummy_name "dummy"
  @calls1 "dummy calls"
  @calls2 "Dummy Calls"

  @valid_attrs %{
    name: @dummy_name, 
    calls: @calls1
  }
  @change_attrs %{
    calls: @calls2
  }
  @invalid_attrs %{
    name: nil
  }

  describe "without relational fields' tests" do
    test "create/2 and change/2 flag with valid data" do
      assert {:ok, %Flag{} = flag} = Jobs.create(:flag, @valid_attrs)
      assert flag.calls == @calls1
      assert {:ok, %Flag{} = flag} = Jobs.change(flag, @change_attrs)
      assert flag.calls == @calls2
    end

    test "create/2 flag with invalid data" do
      assert {:error, %Ecto.Changeset{}} = Jobs.create(:flag, @invalid_attrs)
    end

    test "change/2 flag with invalid data" do
      assert {:ok, %Flag{} = flag} = Jobs.create(:flag, @valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Jobs.change(flag, @invalid_attrs)
    end

    test "list/1 flag" do
      assert [] = Jobs.list(:flag)
      assert {:ok, %Flag{} = flag} = Jobs.create(:flag, @valid_attrs)
      assert [%Flag{}] = Jobs.list(:flag)
    end

    test "get/2 flag" do
      assert nil == Jobs.get(:flag, 1)
      assert {:ok, %Flag{} = flag} = Jobs.create(:flag, @valid_attrs)
      assert %Flag{} = Jobs.get(:flag, flag.id)
    end

    test "get_by/2 flag" do
      assert nil == Jobs.get_by(:flag, @change_attrs)
      assert {:ok, %Flag{} = flag} = Jobs.create(:flag, @valid_attrs)
      assert %Flag{} = Jobs.get_by(:flag, calls: flag.calls)
    end
  end
end