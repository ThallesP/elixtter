defmodule Elixtter do
  import Plug.Conn

  def init(options) do
    # initialize options
    options
  end

  def call(%Plug.Conn{method: "GET", path_info: ["tweets"]} = conn, _opts) do
    tweets = TweetStore.get_tweets()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(tweets))
  end

  def call(%Plug.Conn{method: "POST", path_info: ["tweets"]} = conn, _opts) do
    tweet = %Tweet{
      text: "Don Ramon",
      created_at: DateTime.utc_now()
    }

    TweetStore.add_tweet(tweet)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(201, Jason.encode!(tweet))
  end

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(404, "")
  end

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, plug: Elixtter, scheme: :http, options: [port: 4000]},
      {TweetStore, []}
    ]

    {:ok, _} = Supervisor.start_link(children, strategy: :one_for_one)

    Process.sleep(:infinity)
  end
end
