defmodule Jobseeker9000.Utils do
  alias Jobseeker9000.Floker.Websites 
  def module(what) do
    @modules[what]
  end

  def () 
  def assumptions_check() do
    for flag <- Jobs.list(:flag) do
      for website <- Websites.available_websites() do
        
      end
    end
  end
end