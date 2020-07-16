defmodule Jobseeker9000.Jobs.CompanyTest do
  use Jobseeker9000.DataCase

  alias Jobseeker9000.Jobs.Company
  alias Jobseeker9000.Jobs.Company.Schema

  @dummy_name "dummy"
  
  @company %{
    "name" => @dummy_name,
    "url" => "pracuj.pl/firma/1",
    "found_on" => "pracuj.pl"
  }

  describe "Company create/1" do
    test "with valid data" do
      params = @company

      assert {:ok, %Schema{name: @dummy_name}} = Company.create(params)
    end

    test "with invalid data" do
      params = Map.delete(@company, "name")
      assert {:error, _changeset} = Company.create(params)
      
      params = Map.delete(@company, "url")
      assert {:error, _changeset} = Company.create(params)
      
      params = Map.delete(@company, "found_on")
      assert {:error, _changeset} = Company.create(params)
    end

    test "with unique index violation" do
      params = @company
      Company.create(params)

      assert {:error, _changeset} = Company.create(params)
    end
  end

  describe "Company get/1" do
    test "when company exists" do
      %{id: id} = insert(:company)

      assert {:ok, %Schema{id: ^id}} = Company.get(id)
    end

    test "with unknown id" do
      assert {:error, :not_found} = Company.get(Ecto.UUID.generate())
    end

    test "when nil given" do
      assert {:error, :nil_given} = Company.get(nil)
    end
  end

  describe "Company list/0" do
    test "when companies exist" do
      insert_pair(:company)

      assert [%Schema{}, %Schema{}] = Company.list()
    end

    test "when no company exists" do
      assert [] = Company.list()
    end
  end
end