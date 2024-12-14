defmodule Tweet do
  @type t() :: %__MODULE__{
          text: String.t(),
          created_at: DateTime.t()
        }
  @derive {Jason.Encoder, only: [:text, :created_at]}
  defstruct text: "", created_at: DateTime.utc_now()
end

defmodule TweetStore do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @spec add_tweet(Tweet.t()) :: :ok
  def add_tweet(%Tweet{} = tweet) do
    GenServer.cast(__MODULE__, {:add_tweet, tweet})
  end

  @spec get_tweets() :: [Tweet.t()]
  def get_tweets() do
    GenServer.call(__MODULE__, :get_tweets)
  end

  @impl true
  def init(_opts) do
    {:ok, []}
  end

  @impl true
  def handle_call(:get_tweets, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:add_tweet, %Tweet{} = tweet}, state) do
    Process.sleep(1000)
    {:noreply, [tweet | state]}
  end
end
