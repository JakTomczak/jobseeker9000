defmodule Jobseeker9000.Floker.WebsitesTest do
  use Jobseeker9000.DataCase

  alias Jobseeker9000.Floker.Websites
  alias Jobseeker9000.Floker.Context

  @pracuj_urls_parts %{
    remote: "rw=true&",
    poznan: "Poznań;wp/",
    programming: "programowanie;cc,5016003/",
    elixir: "Elixir;kw/",
    matlab: "Matlab;kw/",
    full_time: "ws=0&",
    part_time: "ws=1&",
    dollars_2000: "sal=7500&"
  }

  describe "Websites . search_url/2 on pracuj.pl" do
    setup do
      [
        base_url: "https://www.pracuj.pl/praca/",
        module: Jobseeker9000.Floker.Websites.Pracuj
      ]
    end

    test "with no query", %{base_url: base_url, module: module} do
      context = Context.make([])

      assert base_url == Websites.search_url(context, module)
    end

    test "with remote", %{base_url: base_url, module: module} do
      context = Context.make([@remote])

      url = base_url <> "?" <> @pracuj_urls_parts.remote

      assert url == Websites.search_url(context, module)
    end

    test "with place", %{base_url: base_url, module: module} do
      context = Context.make([@poznan])

      url = base_url <> @pracuj_urls_parts.poznan <> "?" <> "rd=5&"

      assert url == Websites.search_url(context, module)
    end

    test "with category", %{base_url: base_url, module: module} do
      context = Context.make([@programming])

      url = base_url <> @pracuj_urls_parts.programming

      assert url == Websites.search_url(context, module)
    end

    test "with keyword", %{base_url: base_url, module: module} do
      context = Context.make([@elixir])

      url = base_url <> @pracuj_urls_parts.elixir

      assert url == Websites.search_url(context, module)
    end

    test "with employment type", %{base_url: base_url, module: module} do
      context = Context.make([@full_time])

      url = base_url <> "?" <> @pracuj_urls_parts.full_time

      assert url == Websites.search_url(context, module)
    end

    test "with salary", %{base_url: base_url, module: module} do
      context = Context.make([@dollars_2000])

      url = base_url <> "?" <> @pracuj_urls_parts.dollars_2000

      assert url == Websites.search_url(context, module)
    end

    test "with two pre question mark", %{base_url: base_url, module: module} do
      context = Context.make([@elixir, @programming])

      url = base_url <> @pracuj_urls_parts.elixir <> @pracuj_urls_parts.programming

      assert url == Websites.search_url(context, module)
    end

    test "with two after question mark", %{base_url: base_url, module: module} do
      context = Context.make([@dollars_2000, @full_time])

      url = base_url <> "?" <> @pracuj_urls_parts.dollars_2000 <> @pracuj_urls_parts.full_time

      assert url == Websites.search_url(context, module)
    end

    test "with one pre and after question mark", %{base_url: base_url, module: module} do
      context = Context.make([@dollars_2000, @programming])

      url = base_url <> @pracuj_urls_parts.programming <> "?" <> @pracuj_urls_parts.dollars_2000

      assert url == Websites.search_url(context, module)
    end

    test "with many keywords", %{base_url: base_url, module: module} do
      context = Context.make([@matlab, @programming])

      url = base_url <> @pracuj_urls_parts.matlab <> @pracuj_urls_parts.programming

      assert url == Websites.search_url(context, module)
    end
  end
end
