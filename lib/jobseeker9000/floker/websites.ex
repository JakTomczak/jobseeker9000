defmodule Jobseeker9000.Floker.Websites do
  @modules %{
    pracuj: Jobseeker9000.Floker.Websites.Pracuj
  }
  def module(what) do
    @modules[what]
  end

  def available_websites() do
    [
      :pracuj
    ]
  end

  def search_url(%{options: []}, module) do
     apply(module, :index, [])
  end
  def search_url(%{options: include}, module) do
    search_url(
      apply(module, :index, []) <> "?", 
      include,
      module
    )
  end
  def search_url(url, [{action, option} | tail], module) when tail == [] do
    url <> apply(module, action, [option])
  end
  def search_url(url, [{action, option} | tail], module) do
    search_url(
      url <> apply(module, action, [option]) <> "&",
      tail,
      module
    )
  end
end