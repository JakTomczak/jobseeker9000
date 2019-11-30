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
        %{name: @dummy_name}
        |> JobsHelpers.maybe_get_defaults(:offer)
        |> Jobs.create(:offer)
      assert offer.name == @dummy_name
    end

    test "with invalid data" do
      assert {:error, %Ecto.Changeset{valid?: false}} = Jobs.create(:offer)
    end
  end

  describe "jobs . change/2 offer" do
    setup do
      {:ok, %Jobs.Offer{} = offer} =
        JobsHelpers.maybe_get_defaults(:offer)
        |> Jobs.create(:offer)
      [offer: offer]
    end

    test "with valid data", context do
      assert {:ok, %Jobs.Offer{name: @dummy_name}}
        = Jobs.change(context[:offer], %{name: @dummy_name})
    end

    test "with invalid data", context do
      assert {:error, %Ecto.Changeset{valid?: false}} = Jobs.change(context[:offer], @invalid_attrs)
    end
  end

  describe "jobs . list/1 offer" do
    setup context do
      if context[:seed] == :yes do
        %{url: @dummy_url_1}
        |> JobsHelpers.maybe_get_defaults(:offer)
        |> Jobs.create(:offer)
        %{url: @dummy_url_2}
        |> JobsHelpers.maybe_get_defaults(:offer)
        |> Jobs.create(:offer)
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
      {:ok, %Jobs.Offer{} = offer} =
        JobsHelpers.maybe_get_defaults(:offer)
        |> Jobs.create(:offer)
      [id: offer.id, offer: offer]
    end

    test "by valid id", context do
      assert context[:offer] == Jobs.get(:offer, context[:id])
    end

    test "by invalid id", context do
      assert context[:id] != @wrong_id
      assert nil == Jobs.get(:offer, @wrong_id)
    end
  end

  describe "jobs . get_by/2 offer" do
    setup do
      {:ok, %Jobs.Offer{} = offer} =
        %{name: @dummy_name}
        |> JobsHelpers.maybe_get_defaults(:offer)
        |> Jobs.create(:offer)
      [offer: offer]
    end

    test "when matched", context do
      assert context[:offer] == Jobs.get_by(:offer, name: @dummy_name)
    end

    test "when wrongly matched" do
      assert nil == Jobs.get_by(:offer, name: @wrong_name)
    end
  end

  describe "jobs . offer . flags field" do
    setup do
      {:ok, %Jobs.Offer{} = offer} =
        JobsHelpers.maybe_get_defaults(:offer)
        |> Jobs.create(:offer)
      {:ok, %Jobs.Flag{} = flag_1} =
        JobsHelpers.maybe_get_defaults(:flag)
        |> Jobs.create(:flag)
      {:ok, %Jobs.Flag{} = flag_2} =
        JobsHelpers.maybe_get_defaults(:flag)
        |> Jobs.create(:flag)
      [offer: offer, flag_1: flag_1, flag_2: flag_2]
    end

    test "add_flags/2 with one flag && relation is added both ways", context do
      flag = context[:flag_1]
      assert {:ok, %Jobs.Offer{flags: [^flag]} = offer} = Jobs.add_flags(context[:offer], flag)
      flag = Jobseeker9000.Repo.preload(flag, :offers)
      assert List.first(flag.offers).id == offer.id
    end

    test "add_flags/2 with many flags", context do
      flags = [context[:flag_1], context[:flag_2]]
      assert {:ok, %Jobs.Offer{flags: ^flags}} = Jobs.add_flags(context[:offer], flags)
    end

    test "add_flags/2 try and fail when flags aren't flags", context do
      assert {:error, %Ecto.Changeset{valid?: false}} = Jobs.add_flags(context[:offer], [1, 2])
    end
  end
end