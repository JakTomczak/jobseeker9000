defmodule Jobseeker9000Web.PageControllerTest do
  use Jobseeker9000Web.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "</html>"
  end
end
