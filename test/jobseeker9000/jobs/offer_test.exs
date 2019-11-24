defmodule Jobseeker9000.Jobs.OfferTest do
  use Jobseeker9000.DataCase

  alias Jobseeker9000.Jobs
  alias Jobseeker9000.Jobs.Offer

  @dummy_name "dummy"
  @date1 ~N[2019-11-01 12:00:00]
  @date2 ~N[2019-12-01 12:00:00]
  @domain "pracuj.pl"
  @dummy_url "pracuj.pl/praca/1"
  @state1 "open"
  @state2 "closed"

  @valid_attrs %{
    name: @dummy_name, 
    from: @date1, 
    ending: @date2, 
    found_on: @domain, 
    url: @dummy_url, 
    state: @state1
  }
  @change_attrs %{
    state: @state2
  }
  @invalid_attrs %{
    found_on: nil
  }

  describe "without relational fields' tests" do
    test "create/2 and change/2 offer with valid data" do
      assert {:ok, %Offer{} = offer} = Jobs.create(:offer, @valid_attrs)
      assert offer.state == @state1
      assert {:ok, %Offer{} = offer} = Jobs.change(offer, @change_attrs)
      assert offer.state == @state2
    end

    test "create/2 offer with invalid data" do
      assert {:error, %Ecto.Changeset{}} = Jobs.create(:offer, @invalid_attrs)
    end

    test "change/2 offer with invalid data" do
      assert {:ok, %Offer{} = offer} = Jobs.create(:offer, @valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Jobs.change(offer, @invalid_attrs)
    end

    test "list/1 offers" do
      assert [] = Jobs.list(:offer)
      assert {:ok, %Offer{} = offer} = Jobs.create(:offer, @valid_attrs)
      assert [%Offer{}] = Jobs.list(:offer)
    end

    test "get/2 offer" do
      assert nil == Jobs.get(:offer, 1)
      assert {:ok, %Offer{} = offer} = Jobs.create(:offer, @valid_attrs)
      assert %Offer{} = Jobs.get(:offer, offer.id)
    end

    test "get_by/2 offer" do
      assert nil == Jobs.get_by(:offer, @change_attrs)
      assert {:ok, %Offer{} = offer} = Jobs.create(:offer, @valid_attrs)
      assert %Offer{} = Jobs.get_by(:offer, state: offer.state)
    end
  end
end