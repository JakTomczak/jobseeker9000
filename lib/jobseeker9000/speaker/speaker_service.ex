defmodule Jobseeker9000.Speaker.SpeakerService do
  alias Jobseeker9000.Speaker.SpeakerWorker

  def start() do
    GenServer.start_link(SpeakerWorker, nil)
  end

  def enqueue(url) do
    GenServer.cast(SpeakerWorker, {:enqueue, url})
  end
end
