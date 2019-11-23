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
    test "create_offer/1 and change_offer/2 with valid data" do
      assert {:ok, %Offer{} = offer} = Jobs.create_offer(@valid_attrs)
      assert offer.state == @state1
      assert {:ok, %Offer{} = offer} = Jobs.change_offer(offer, @change_attrs)
      assert offer.state == @state2
    end

    test "create_offer/1 with invalid data" do
      assert {:error, %Ecto.Changeset{}} = Jobs.create_offer(@invalid_attrs)
    end

    test "change_offer/2 with invalid data" do
      assert {:ok, %Offer{} = offer} = Jobs.create_offer(@valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Jobs.change_offer(offer, @invalid_attrs)
    end

    test "list_offers/0" do
      assert [] = Jobs.list_offers
      assert {:ok, %Offer{} = offer} = Jobs.create_offer(@valid_attrs)
      assert [%Offer{}] = Jobs.list_offers
    end

    test "get_offer/1" do
      assert nil == Jobs.get_offer(1)
      assert {:ok, %Offer{} = offer} = Jobs.create_offer(@valid_attrs)
      assert %Offer{} = Jobs.get_offer(offer.id)
    end

    test "get_offer_by/1" do
      assert nil == Jobs.get_offer_by(@change_attrs)
      assert {:ok, %Offer{} = offer} = Jobs.create_offer(@valid_attrs)
      assert %Offer{} = Jobs.get_offer_by(state: offer.state)
    end
  end
end