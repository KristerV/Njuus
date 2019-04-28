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
    |> validate_required([:title, :votes])
    |> validate_required_one_of_two(:body, :link)
  end

  def validate_required_one_of_two(changeset, first, second) do
    firstVal = get_field(changeset, first) |> (&(&1 && &1 != "")).()
    secondVal = get_field(changeset, second) |> (&(&1 && &1 != "")).()

    case {firstVal, secondVal} do
      {nil, nil} -> add_error(changeset, first, "Täida kas link või tekst.")
      {true, true} -> add_error(changeset, first, "Täida kas link või tekst, aga mitte mõlemad.")
      {true, nil} -> changeset
      {nil, true} -> changeset
    end
  end
end
