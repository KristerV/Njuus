defmodule Njuus.Core.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :link, :string
    field :title, :string
    field :votes, {:array, :integer}

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :link, :title, :votes])
    |> validate_required([:body, :link, :title, :votes])
  end
end
