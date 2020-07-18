defmodule Jobseeker9000.Jobs.OfferTest do
  use Jobseeker9000.DataCase

  alias Jobseeker9000.Jobs.Offer
  alias Jobseeker9000.Jobs.Offer.Schema

  @dummy_name "dummy"

  @offer %{
    "name" => @dummy_name,
    "from" => ~D[2020-07-16],
    "ending" => ~D[2020-08-16],
    "found_on" => "pracuj",
    "url" => "pracuj.pl/oferta/1",
    "state" => "open"
  }

  describe "Offer create/2" do
    test "with valid data" do
      company = insert(:company)
      params = @offer

      assert {:ok, %Schema{name: @dummy_name}} = Offer.create(company, params)
    end

    test "with invalid data" do
      company = insert(:company)

      params = Map.delete(@offer, "name")
      assert {:error, _changeset} = Offer.create(company, params)

      params = Map.delete(@offer, "from")
      assert {:error, _changeset} = Offer.create(company, params)

      params = Map.delete(@offer, "found_on")
      assert {:error, _changeset} = Offer.create(company, params)

      params = Map.delete(@offer, "url")
      assert {:error, _changeset} = Offer.create(company, params)
    end

    test "with unique index violation" do
      company = insert(:company)
      params = @offer

      Offer.create(company, params)

      assert {:error, _changeset} = Offer.create(company, params)
    end

    test "when company not given" do
      params = @offer

      assert {:error, _changeset} = Offer.create(nil, params)
    end
  end

  describe "Offer get/1" do
    test "when offer exists" do
      %{id: id} = insert(:offer)

      assert {:ok, %Schema{id: ^id}} = Offer.get(id)
    end

    test "with unknown id" do
      assert {:error, :not_found} = Offer.get(Ecto.UUID.generate())
    end

    test "when nil given" do
      assert {:error, :nil_given} = Offer.get(nil)
    end
  end

  describe "Offer list/0" do
    test "when offers exist" do
      insert_pair(:offer)

      assert [%Schema{}, %Schema{}] = Offer.list()
    end

    test "when no offer exists" do
      assert [] = Offer.list()
    end
  end
end
