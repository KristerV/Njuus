defmodule Njuus.Tracking do
  use Ecto.Schema
  import Ecto.Changeset
  alias Njuus.Repo

  schema "tracking" do
    field :sessionid, :string
    field :route, :string
    field :ip, :string
    timestamps()
  end

  @doc false
  def changeset(track, attrs) do
    track
    |> cast(attrs, [
      :sessionid,
      :route,
      :ip
    ])
    |> validate_required([:sessionid, :route, :ip])
  end
end
