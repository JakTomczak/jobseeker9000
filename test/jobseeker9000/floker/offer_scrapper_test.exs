defmodule Jobseeker9000.Floker.OfferScrapperTest do
  use Jobseeker9000.DataCase
  
  alias Jobseeker9000.Floker.OfferScrapper

  describe "offer_scrapper . test_run/3" do
    test "well... yes, test run" do
      offer = %{
      relative_link: "/praca/magento-backend-developer-praca-zdalna-krakow-okolice,oferta,7270893", 
      full_link: "https://www.pracuj.pl/praca/magento-backend-developer-praca-zdalna-krakow-okolice,oferta,7270893", 
      id: "7270893"
    }
      context = %{options: [{:include, :remote}]}

      OfferScrapper.test_run(:pracuj, context, offer) 
      |> IO.puts()
    end
  end
end