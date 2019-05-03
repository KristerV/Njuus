defmodule Njuus.Core.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :link, :string
    field :title, :string
    field :image, :string
    field :votes, {:array, :integer}, default: [1]

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :link, :title, :votes, :image])
    |> validate_required([:title, :votes])
    |> validate_required_one(:body, :link)
  end

  def validate_required_one(changeset, first, second) do
    firstVal = get_field(changeset, first) |> (&(&1 && &1 != "")).()
    secondVal = get_field(changeset, second) |> (&(&1 && &1 != "")).()

    case {firstVal, secondVal} do
      {nil, nil} -> add_error(changeset, first, "Täida kas link või tekst.")
      {true, true} -> changeset
      {true, nil} -> changeset
      {nil, true} -> changeset
    end
  end
end
