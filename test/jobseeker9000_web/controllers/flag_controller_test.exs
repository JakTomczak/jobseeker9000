defmodule Jobseeker9000Web.FlagControllerTest do
  use Jobseeker9000Web.ConnCase
  
  alias Jobseeker9000.Jobs
  alias Jobseeker9000.JobsHelpers
  
  @dummy_name "dummy name"

  # describe "Flag Controller GET index/2" do
  #   setup do
  #     [url: "/flag"]
  #   end

  #   test "when flags exist", %{conn: conn, url: url} do
  #     {:ok, %Jobs.Flag{} = flag} =
  #       JobsHelpers.maybe_get_defaults(:flag, %{name: @dummy_name})
  #       |> Jobs.create(:flag)
      
  #     conn = get(conn, url)

  #     assert html_response(conn, 200) =~ @dummy_name
  #   end
  # end
end
