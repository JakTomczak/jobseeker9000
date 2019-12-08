defmodule Jobseeker9000.Jobs.OfferTest do
  use Jobseeker9000.DataCase

  alias Jobseeker9000.Jobs
  alias Jobseeker9000.JobsHelpers

  @dummy_name "dummy"
  @dummy_url_1 "pracuj.pl/praca/1"
  @dummy_url_2 "pracuj.pl/praca/2"
  @wrong_id 999
  @wrong_name "wrong"
  @invalid_attrs %{
    found_on: nil
  }

  describe "jobs . create/2 offer" do
    test "with valid data" do
      {:ok, %Jobs.Offer{} = offer} =
        JobsHelpers.maybe_get_defaults(:offer, %{name: @dummy_name})
        |> Jobs.create(:offer)
      assert offer.name == @dummy_name
    end

    test "with invalid data" do
      assert {:error, %Ecto.Changeset{valid?: false}} = Jobs.create(:offer)
    end
  end

  describe "jobs . change/2 offer" do
    setup do
      [offer: JobsHelpers.mock(:offer)]
    end

    test "with valid data", %{offer: offer} do
      assert {:ok, %Jobs.Offer{name: @dummy_name}} = Jobs.change(offer, %{name: @dummy_name})
    end

    test "with invalid data", %{offer: offer} do
      assert {:error, %Ecto.Changeset{valid?: false}} = Jobs.change(offer, @invalid_attrs)
    end
  end

  describe "jobs . list/1 offer" do
    setup context do
      if context[:seed] == :yes do
        JobsHelpers.mock(:offer, %{url: @dummy_url_1})
        JobsHelpers.mock(:offer, %{url: @dummy_url_2})
      end
      :ok
    end

    @tag seed: :yes
    test "when two records exist" do
      assert [%Jobs.Offer{url: @dummy_url_1}, %Jobs.Offer{url: @dummy_url_2}]
        = Jobs.list(:offer)
    end

    @tag seed: :no
    test "when no records exist" do
      assert [] == Jobs.list(:offer)
    end
  end

  describe "jobs . get/2 offer" do
    setup do
      offer = JobsHelpers.mock(:offer)
      [offer: offer, id: offer.id]
    end

    test "by valid id", %{id: id, offer: offer} do
      assert offer == Jobs.get(:offer, id)
    end

    test "by invalid id", %{id: id} do
      assert id != @wrong_id
      assert nil == Jobs.get(:offer, @wrong_id)
    end
  end

  describe "jobs . get_by/2 offer" do
    setup do
      [ offer: JobsHelpers.mock(:offer, %{name: @dummy_name}) ]
    end

    test "when matched", %{offer: offer} do
      assert offer == Jobs.get_by(:offer, name: @dummy_name)
    end

    test "when unmatched" do
      assert nil == Jobs.get_by(:offer, name: @wrong_name)
    end
  end

  describe "jobs . offer . set_flags/2" do
    setup do
        [
          offer: JobsHelpers.mock(:offer), 
          flag_1: JobsHelpers.mock(:flag), 
          flag_2: JobsHelpers.mock(:flag)
        ]
    end

    test "with one flag && relation is added both ways", %{offer: offer, flag_1: flag} do
      assert {:ok, %Jobs.Offer{flags: [^flag]} = offer} = Jobs.set_flags(offer, flag)
      flag = Jobseeker9000.Repo.preload(flag, :offers)
      assert List.first(flag.offers).id == offer.id
    end

    test "with many flags", context do
      flags = [context[:flag_1], context[:flag_2]]
      assert {:ok, %Jobs.Offer{flags: ^flags}} = Jobs.set_flags(context[:offer], flags)
    end

    test "try and fail when flags aren't flags", %{offer: offer} do
      assert {:error, %Ecto.Changeset{valid?: false}} = Jobs.set_flags(offer, [1, 2])
    end

    test "flags association is replaced, not expanded", %{offer: offer, flag_1: old_flag, flag_2: new_flag} do
      {:ok, offer} = Jobs.set_flags(offer, old_flag)
      {:ok, offer} = Jobs.set_flags(offer, new_flag)
      assert 1 == length(offer.flags)
    end
  end

  describe "jobs . offer . list_flags/1" do
    setup context do
      offer = JobsHelpers.mock(:offer)
      if context[:seed] == :yes do
        flag_1 = JobsHelpers.mock(:flag)
        flag_2 = JobsHelpers.mock(:flag)
        Jobs.set_flags(offer, [flag_1, flag_2])
      end
      [offer: offer]
    end

    @tag seed: :yes
    test "when two records exist", %{offer: offer} do
      assert [%Jobs.Flag{}, %Jobs.Flag{}] = Jobs.list_flags(offer)
    end

    @tag seed: :no
    test "when no record exist", %{offer: offer} do
      assert [] = Jobs.list_flags(offer)
    end
  end

  describe "jobs . offer .  get_company/1" do
    setup context do
      offer = JobsHelpers.mock(:offer)
      if context[:seed] == :yes do
        company = JobsHelpers.mock(:company, %{url: @dummy_url_1})
        {:ok, %Jobs.Company{offers: [offer]}} = Jobs.link_offers(company, offer)
        [offer: offer]
      else
        [offer: offer]
      end
    end

    @tag seed: :yes
    test "when company is linked", %{offer: offer} do
      offer = Repo.preload(offer, :company)
      assert %Jobs.Company{url: @dummy_url_1} = Jobs.get_company(offer)
    end

    @tag seed: :no
    test "when no company is linked", %{offer: offer} do
      assert nil == Jobs.get_company(offer)
    end
  end
end