defmodule Jobseeker9000.Jobs.FlagTest do
  use Jobseeker9000.DataCase

  alias Jobseeker9000.Jobs
  alias Jobseeker9000.JobsHelpers

  @dummy_name "dummy"
  @calls1 "dummy;dummies"
  @calls2 "call;calls"
  @wrong_id 999
  @wrong_name "wrong"
  @invalid_attrs %{
    name: nil
  }
  @not_default_offer_url "pracuj.pl/oferta/not_default"

  describe "jobs . create/2 flag" do
    test "with valid data" do
      {:ok, %Jobs.Flag{} = flag} =
        JobsHelpers.maybe_get_defaults(:flag, %{name: @dummy_name})
        |> Jobs.create(:flag)
      assert flag.name == @dummy_name
    end

    test "with invalid data" do
      assert {:error, %Ecto.Changeset{valid?: false}} = Jobs.create(:flag)
    end
  end

  describe "jobs . change/2 flag" do
    setup do
      [flag: JobsHelpers.mock(:flag)]
    end

    test "with valid data", %{flag: flag} do
      assert {:ok, %Jobs.Flag{name: @dummy_name}} = Jobs.change(flag, %{name: @dummy_name})
    end

    test "with invalid data", %{flag: flag} do
      assert {:error, %Ecto.Changeset{valid?: false}} = Jobs.change(flag, @invalid_attrs)
    end
  end

  describe "jobs . list/1 flag" do
    setup context do
      if context[:seed] == :yes do
        JobsHelpers.mock(:flag, %{calls: @calls1})
        JobsHelpers.mock(:flag, %{calls: @calls2})
      end
      :ok
    end

    @tag seed: :yes
    test "when two records exist" do
      assert [%Jobs.Flag{calls: @calls1}, %Jobs.Flag{calls: @calls2}]
        = Jobs.list(:flag)
    end

    @tag seed: :no
    test "when no records exist" do
      assert [] == Jobs.list(:flag)
    end
  end

  describe "jobs . get/2 flag" do
    setup do
      flag = JobsHelpers.mock(:flag)
      [id: flag.id, flag: flag]
    end

    test "by valid id", %{id: id, flag: flag} do
      assert flag == Jobs.get(:flag, id)
    end

    test "by invalid id", %{id: id} do
      assert id != @wrong_id
      assert nil == Jobs.get(:flag, @wrong_id)
    end
  end

  describe "jobs . get_by/2 flag" do
    setup do
      [ flag: JobsHelpers.mock(:flag, %{name: @dummy_name}) ]
    end

    test "when matched", %{flag: flag} do
      assert flag == Jobs.get_by(:flag, name: @dummy_name)
    end

    test "when unmatched" do
      assert is_nil( Jobs.get_by(:flag, name: @wrong_name) )
    end
  end

  describe "jobs . flag . list_offers/1" do
    setup context do
      flag = JobsHelpers.mock(:flag)
      if context[:seed] == :yes do
        offer_1 = JobsHelpers.mock(:offer)
        Jobs.set_flags(offer_1, flag)
        offer_2 = JobsHelpers.mock(:offer, %{url: @not_default_offer_url})
        Jobs.set_flags(offer_2, flag)
      end
      [flag: flag]
    end

    @tag seed: :yes
    test "when two records exist", %{flag: flag} do
      assert [%Jobs.Offer{}, %Jobs.Offer{}] = Jobs.list_offers(flag)
    end

    @tag seed: :no
    test "when no record exist", %{flag: flag} do
      assert [] = Jobs.list_offers(flag)
    end
  end
end