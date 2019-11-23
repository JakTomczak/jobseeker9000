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
    test "create_flag/1 and change_flag/2 with valid data" do
      assert {:ok, %Flag{} = flag} = Jobs.create_flag(@valid_attrs)
      assert flag.calls == @calls1
      assert {:ok, %Flag{} = flag} = Jobs.change_flag(flag, @change_attrs)
      assert flag.calls == @calls2
    end

    test "create_flag/1 with invalid data" do
      assert {:error, %Ecto.Changeset{}} = Jobs.create_flag(@invalid_attrs)
    end

    test "change_flag/2 with invalid data" do
      assert {:ok, %Flag{} = flag} = Jobs.create_flag(@valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Jobs.change_flag(flag, @invalid_attrs)
    end

    test "list_flags/0" do
      assert [] = Jobs.list_flags
      assert {:ok, %Flag{} = flag} = Jobs.create_flag(@valid_attrs)
      assert [%Flag{}] = Jobs.list_flags
    end

    test "get_flag/1" do
      assert nil == Jobs.get_flag(1)
      assert {:ok, %Flag{} = flag} = Jobs.create_flag(@valid_attrs)
      assert %Flag{} = Jobs.get_flag(flag.id)
    end

    test "get_flag_by/1" do
      assert nil == Jobs.get_flag_by(@change_attrs)
      assert {:ok, %Flag{} = flag} = Jobs.create_flag(@valid_attrs)
      assert %Flag{} = Jobs.get_flag_by(calls: flag.calls)
    end
  end
end