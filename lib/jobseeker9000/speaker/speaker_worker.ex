defmodule Jobseeker9000.Speaker.SpeakerWorker do
  defmodule State do
    defstruct queue: [],
              processed: [],
              current: nil,
              waiting_time: nil
  end

  use GenServer

  alias Jobseeker9000.Speaker.Speaker

  @default_waiting_time 250

  @impl true
  def init(nil) do
    Process.send_after(self(), :work, @default_waiting_time)

    {:ok, %State{}}
  end

  @impl true
  def handle_info(:work, state) do
    state = process_current(state)

    waiting_time = state.waiting_time || @default_waiting_time

    state = dequeue(state)

    Process.send_after(self(), :work, waiting_time)

    {:noreply, state}
  end

  @impl true
  def handle_cast({:enqueue, url}, state) do
    state = %{
      state
      | queue: state.queue ++ [url]
    }

    {:noreply, state}
  end

  defp process_current(%State{current: nil} = state) do
    state
  end

  defp process_current(%State{current: current} = state) do
    case Speaker.process(current) do
      {:ok, body} ->
        %{
          state
          | waiting_time: nil,
            current: nil,
            processed: [body | state.processed]
        }

      {:wait, waiting_time} ->
        %{
          state
          | waiting_time: waiting_time
        }
    end
  end

  defp dequeue(%State{queue: []} = state) do
    state
  end

  defp dequeue(%State{current: current} = state) when not is_nil(current) do
    state
  end

  defp dequeue(%State{queue: [first | the_rest]} = state) do
    %{
      state
      | queue: the_rest,
        current: first
    }
  end
end
