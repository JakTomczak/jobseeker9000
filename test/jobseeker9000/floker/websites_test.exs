defmodule Jobseeker9000.Floker.WebsitesTest do
  use Jobseeker9000.DataCase
  
  alias Jobseeker9000.Floker

  describe "Websites . search_url/2 on pracuj.pl" do
    setup do
      [base_url: "https://www.pracuj.pl/praca"]
    end

    test "with no query", %{base_url: base_url} do

    end
  end
end