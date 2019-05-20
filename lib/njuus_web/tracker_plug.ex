defmodule Njuus.TrackerPlug do
  import Plug.Conn
  alias Njuus.Repo
  alias Njuus.Tracking

  def init(options), do: options

  def call(conn, _opts) do
    conn
    |> add_user_id
    |> track
  end

  def track(conn) do
    IO.puts("TRACK")

    %Tracking{}
    |> Tracking.changeset(%{
      sessionid: get_session(conn, :uuid),
      route: Enum.join(conn.path_info, "/"),
      ip: Enum.join(Tuple.to_list(conn.remote_ip), ".")
    })
    |> Repo.insert()

    conn
  end

  def add_user_id(conn) do
    if get_session(conn, :uuid) == nil do
      put_session(conn, :uuid, Ecto.UUID.generate())
    else
      conn
    end
  end
end
