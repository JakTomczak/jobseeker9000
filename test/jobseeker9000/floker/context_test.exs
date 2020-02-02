defmodule Jobseeker9000.Floker.ContextTest do
  use Jobseeker9000.DataCase

  alias Jobseeker9000.Floker.Context 

  @remote %{
    name: "Remote",
    type: "remote"
  }

  @poznan %{
    name: "Poznań",
    type: "place",
    latitude: 52.406374,
    longitude: 16.925168100000064,
    radius: 5
  }

  @warszawa %{
    name: "Warszawa",
    type: "place",
    latitude: 52.2296756,
    longitude: 21.012228700000037,
    radius: 10
  }

  @berlin %{
    name: "Berlin",
    type: "place",
    latitude: 52.52000659999999,
    longitude: 13.404953999999975,
    radius: 15
  }
  
  @programming %{
    name: "Programming",
    type: "category"
  }
  
  @elixir %{
    name: "Elixir",
    type: "keyword",
    calls: ["Elixir"]
  }

  @matlab %{
    name: "Matlab",
    type: "keyword",
    calls: ["Matlab"]
  }

  @full_time %{
    name: "Full time",
    type: "employment_type"
  }

  @part_time %{
    name: "Part time",
    type: "employment_type"
  }

  @dollars_2000 %{
    name: "More than $2000",
    type: "salary",
    amount: 2000,
    currency: "USD"
  }

  @euro_2500 %{
    name: "More than 2500 €",
    type: "salary",
    amount: 2500,
    currency: "EUR"
  }

  describe "Context . make/1" do
    test "with one entry type" do
      assert %{place: %{type: :remote}} = Context.make([@remote])
      
      assert %{place: %{type: :place, radius: 5}} = Context.make([@poznan])
      
      assert %{keys: [%{type: :category}]} = Context.make([@programming])
      
      assert %{keys: [%{type: :keyword, calls: ["Elixir"]}]} = Context.make([@elixir])
      
      assert %{employment_type: "Full time"} = Context.make([@full_time])
      
      assert %{salary_min: %{amount: 2000, currency: "USD"}} = Context.make([@dollars_2000])
    end

    test "place given second time should be updated" do
      flags = [@remote, @poznan, @warszawa, @berlin]

      assert %{place: %{type: :place, radius: 15}} = Context.make(flags)
    end

    test "keys given second time should be appended" do
      flags = [@programming, @elixir]

      assert %{keys: [%{}, %{}]} = Context.make(flags)
    end

    test "employment_type given second time should be updated" do
      flags = [@full_time, @part_time]

      assert %{employment_type: "Part time"} = Context.make(flags)
    end

    test "salary given second time should be updated" do
      flags = [@dollars_2000, @euro_2500]

      assert %{salary_min: %{currency: "EUR"}} = Context.make(flags)
    end

    test "all at once" do
      flags = [@remote, @programming, @full_time, @dollars_2000]

      assert %{
        place: %{type: :remote},
        keys: [%{type: :category}],
        employment_type: "Full time",
        salary_min: %{amount: 2000, currency: "USD"}
      } = Context.make(flags)
    end
  end
end