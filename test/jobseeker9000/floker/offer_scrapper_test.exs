defmodule Jobseeker9000.Floker.OfferScrapperTest do
  use Jobseeker9000.DataCase
  
  alias Jobseeker9000.Floker.OfferScrapper

  describe "offer_scrapper . test_run/3" do

    @tag :skip
    test "well... yes, test run" do
      offer = %{
      relative_link: "/praca/elektromechanik-poznan,oferta,7319844", 
      full_link: "https://www.pracuj.pl/praca/elektromechanik-poznan,oferta,7319844", 
      id: "7319844"
    }
      context = %{options: [{:include, :remote}]}

      OfferScrapper.test_run(:pracuj, context, offer) 
      |> IO.puts()
    end
  end
end