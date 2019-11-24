defmodule Jobseeker9000.Jobs.Companyest do
  use Jobseeker9000.DataCase

  alias Jobseeker9000.Jobs
  alias Jobseeker9000.Jobs.Company

  @dummy_name "dummy"
  @found_on "pracuj.pl"
  @dummy_url "pracuj.pl/firma/1"
  @changed_url "pracuj.pl/firma/2"

  @valid_attrs %{
    name: @dummy_name, 
    found_on: @found_on,
    url: @dummy_url
  }
  @change_attrs %{
    url: @changed_url
  }
  @invalid_attrs %{
    name: nil
  }

  describe "without relational fields' tests" do
    test "create/2 and change/2 company with valid data" do
      assert {:ok, %Company{} = company} = Jobs.create(:company, @valid_attrs)
      assert company.url == @dummy_url
      assert {:ok, %Company{} = company} = Jobs.change(company, @change_attrs)
      assert company.url == @changed_url
    end

    test "create/2 company with invalid data" do
      assert {:error, %Ecto.Changeset{}} = Jobs.create(:company, @invalid_attrs)
    end

    test "change/2 company with invalid data" do
      assert {:ok, %Company{} = company} = Jobs.create(:company, @valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Jobs.change(company, @invalid_attrs)
    end

    test "list/1 company" do
      assert [] = Jobs.list(:company)
      assert {:ok, %Company{} = company} = Jobs.create(:company, @valid_attrs)
      assert [%Company{}] = Jobs.list(:company)
    end

    test "get/2 company" do
      assert nil == Jobs.get(:company, 1)
      assert {:ok, %Company{} = company} = Jobs.create(:company, @valid_attrs)
      assert %Company{} = Jobs.get(:company, company.id)
    end

    test "get_by/2 company" do
      assert nil == Jobs.get_by(:company, @change_attrs)
      assert {:ok, %Company{} = company} = Jobs.create(:company, @valid_attrs)
      assert %Company{} = Jobs.get_by(:company, url: company.url)
    end
  end
end