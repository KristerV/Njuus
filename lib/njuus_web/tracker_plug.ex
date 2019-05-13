defmodule Njuus.TrackerPlug do
  import Plug.Conn
  alias Njuus.Repo
  alias Njuus.Tracking

  def init(options), do: options

  def call(conn, _opts) do
    conn
    |> configure_session(renew: true)
    |> track
  end

  def track(conn) do
    %Tracking{}
    |> Tracking.changeset(%{
      sessionid: conn.cookies["_njuus_key"],
      route: Enum.join(conn.path_info, "/"),
      ip: Enum.join(Tuple.to_list(conn.remote_ip), ".")
    })
    |> Repo.insert()

    conn
  end
end
