defmodule Jobseeker9000.FlokerTest do
  use Jobseeker9000.DataCase
  
  alias Jobseeker9000.Floker

  describe "Floker . poison!/1" do
    test "with valid url" do
      html = Floker.poison!("https://www.google.pl/")
      assert html =~ "<html"
      assert html =~ "Google"
      assert html =~ "</body>"
    end
    
    test "with invalid url" do
      assert_raise RuntimeError, fn -> Floker.poison!("https://www.bardzopolskanazwa.en/") end
    end
  end

  # describe "Floker . run/2 on pracuj.pl" do
  #   test "" do
  #     context = %{options: [{:include, :remote}]}
  #     html = Floker.poison!("https://www.google.pl/")
  #     assert html =~ "<html"
  #     assert html =~ "Google"
  #     assert html =~ "</body>"
  #   end
    
  #   test "with invalid url" do
  #     assert_raise RuntimeError, fn -> Floker.poison!("https://www.bardzopolskanazwa.en/") end
  #   end
  # end
end