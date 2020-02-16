defmodule Jobseeker9000.Floker.ContextTest do
  use Jobseeker9000.DataCase

  alias Jobseeker9000.Floker.Context 

  describe "Context . make/1" do
    test "with one entry type" do
      assert %{remote: true} = Context.make([@remote])
      
      assert %{place: "Poznań", radius: 5} = Context.make([@poznan])
      
      assert %{categories: [%{"default" => "Programming"}]} = Context.make([@programming])
      
      assert %{keywords: ["Elixir"]} = Context.make([@elixir])
      
      assert %{employment_type: "Full time"} = Context.make([@full_time])
      
      assert %{salary_min: %{"pracuj" => 7500}} = Context.make([@dollars_2000])
    end

    test "place given second time should be updated" do
      flags = [@poznan, @warszawa, @berlin]

      assert %{place: "Berlin", radius: 15} = Context.make(flags)
    end

    test "keywords given second time should be appended" do
      flags = [@matlab, @elixir]

      %{keywords: keywords} = Context.make(flags)

      assert 2 == length(keywords)
    end

    test "employment_type given second time should be updated" do
      flags = [@full_time, @part_time]

      assert %{employment_type: "Part time"} = Context.make(flags)
    end

    test "salary given second time should be updated" do
      flags = [@dollars_2000, @euro_2500]

      assert %{salary_min: %{"pracuj" => 1150}} = Context.make(flags)
    end

    test "all at once" do
      flags = [@remote, @programming, @elixir, @full_time, @dollars_2000]

      assert %{
        remote: true,
        categories: [%{}],
        keywords: ["Elixir"],
        employment_type: "Full time",
        salary_min: %{"pracuj" => 7500}
      } = Context.make(flags)
    end
  end
end