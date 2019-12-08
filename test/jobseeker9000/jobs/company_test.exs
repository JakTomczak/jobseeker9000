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
  @not_default_offer_url "pracuj.pl/oferta/not_default"

  describe "jobs . create/2 company" do
    test "with valid data" do
      {:ok, %Jobs.Company{} = company} =
        JobsHelpers.maybe_get_defaults(:company, %{name: @dummy_name})
        |> Jobs.create(:company)
      assert company.name == @dummy_name
    end

    test "with invalid data" do
      assert {:error, %Ecto.Changeset{valid?: false}} = Jobs.create(:company)
    end
  end

  describe "jobs . change/2 company" do
    setup do
      [ company: JobsHelpers.mock(:company) ]
    end

    test "with valid data", %{company: company} do
      assert {:ok, %Jobs.Company{name: @dummy_name}} = Jobs.change(company, %{name: @dummy_name})
    end

    test "with invalid data", %{company: company} do
      assert {:error, %Ecto.Changeset{valid?: false}} = Jobs.change(company, @invalid_attrs)
    end
  end

  describe "jobs . list/1 company" do
    setup context do
      if context[:seed] == :yes do
        JobsHelpers.mock(:company, %{url: @dummy_url_1})
        JobsHelpers.mock(:company, %{url: @dummy_url_2})
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
      company = JobsHelpers.mock(:company)
      [id: company.id, company: company]
    end

    test "by valid id", %{id: id, company: company} do
      assert company == Jobs.get(:company, id)
    end

    test "by invalid id", %{id: id} do
      assert id != @wrong_id
      assert nil == Jobs.get(:company, @wrong_id)
    end
  end

  describe "jobs . get_by/2 company" do
    setup do
      [ company: JobsHelpers.mock(:company, %{name: @dummy_name}) ]
    end

    test "when matched", %{company: company} do
      assert company == Jobs.get_by(:company, name: @dummy_name)
    end

    test "when unmatched" do
      assert is_nil( Jobs.get_by(:company, name: @wrong_name) )
    end
  end

  describe "jobs . company . link_offers/2" do
    setup do
      [
        company: JobsHelpers.mock(:company),
        offer_1: JobsHelpers.mock(:offer),
        offer_2: JobsHelpers.mock(:offer, url: @not_default_offer_url)
      ]
    end

    test "with one offer && relation is added both ways", %{company: company, offer_1: offer} do
      assert {:ok, %Jobs.Company{offers: [offer]} = company} = Jobs.link_offers(company, offer)
      assert company.id == offer.company_id
    end

    test "with many offers", context do
      offers = [context[:offer_1], context[:offer_2]]
      assert {:ok, %Jobs.Company{offers: offers}} = Jobs.link_offers(context[:company], offers)
      assert 2 == length(offers)
    end

    test "try and fail when offers aren't offers", %{company: company} do
      assert {:error, %Ecto.Changeset{valid?: false}} = Jobs.link_offers(company, [1, 2])
    end

    test "offers association is expanded, not replaced", %{company: company, offer_1: old_offer, offer_2: new_offer} do
      {:ok, company} = Jobs.link_offers(company, old_offer)
      {:ok, company} = Jobs.link_offers(company, new_offer)
      assert 2 == length(company.offers)
    end
  end
end