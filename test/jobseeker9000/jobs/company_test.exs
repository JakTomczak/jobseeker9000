defmodule Jobseeker9000.Jobs.Companyest do
  use Jobseeker9000.DataCase

  alias Jobseeker9000.Jobs
  alias Jobseeker9000.JobsHelpers

  @dummy_name "dummy"
  @dummy_url_1 "pracuj.pl/firma/1"
  @dummy_url_2 "pracuj.pl/firma/2"
  @wrong_id 999
  @wrong_name "wrong"
  @invalid_attrs %{
    name: nil
  }

  describe "jobs . create/2 company" do
    test "with valid data" do
      {:ok, %Jobs.Company{} = company} =
        %{name: @dummy_name}
        |> JobsHelpers.maybe_get_defaults(:company)
        |> Jobs.create(:company)
      assert company.name == @dummy_name
    end

    test "with invalid data" do
      assert {:error, %Ecto.Changeset{valid?: false}} = Jobs.create(:company)
    end
  end

  describe "jobs . change/2 company" do
    setup do
      {:ok, %Jobs.Company{} = company} =
        JobsHelpers.maybe_get_defaults(:company)
        |> Jobs.create(:company)
      [company: company]
    end

    test "with valid data", context do
      assert {:ok, %Jobs.Company{name: @dummy_name}}
        = Jobs.change(context[:company], %{name: @dummy_name})
    end

    test "with invalid data", context do
      assert {:error, %Ecto.Changeset{valid?: false}} = Jobs.change(context[:company], @invalid_attrs)
    end
  end

  describe "jobs . list/1 company" do
    setup context do
      if context[:seed] == :yes do
        %{url: @dummy_url_1}
        |> JobsHelpers.maybe_get_defaults(:company)
        |> Jobs.create(:company)
        %{url: @dummy_url_2}
        |> JobsHelpers.maybe_get_defaults(:company)
        |> Jobs.create(:company)
      end
      :ok
    end

    @tag seed: :yes
    test "when two records exist" do
      assert [%Jobs.Company{url: @dummy_url_1}, %Jobs.Company{url: @dummy_url_2}]
        = Jobs.list(:company)
    end

    @tag seed: :no
    test "when no records exist" do
      assert [] == Jobs.list(:company)
    end
  end

  describe "jobs . get/2 company" do
    setup do
      {:ok, %Jobs.Company{} = company} =
        JobsHelpers.maybe_get_defaults(:company)
        |> Jobs.create(:company)
      [id: company.id, company: company]
    end

    test "by valid id", context do
      assert context[:company] == Jobs.get(:company, context[:id])
    end

    test "by invalid id", context do
      assert context[:id] != @wrong_id
      assert nil == Jobs.get(:company, @wrong_id)
    end
  end

  describe "jobs . get_by/2 company" do
    setup do
      {:ok, %Jobs.Company{} = company} =
        %{name: @dummy_name}
        |> JobsHelpers.maybe_get_defaults(:company)
        |> Jobs.create(:company)
      [company: company]
    end

    test "when matched", context do
      assert context[:company] == Jobs.get_by(:company, name: @dummy_name)
    end

    test "when wrongly matched" do
      assert is_nil( Jobs.get_by(:company, name: @wrong_name) )
    end
  end
end