defmodule Njuus.CoreTest do
  use Njuus.DataCase

  alias Njuus.Core

  describe "posts" do
    alias Njuus.Core.Post

    @valid_attrs %{body: "some body", link: "some link", title: "some title", votes: []}
    @update_attrs %{
      body: "some updated body",
      link: "some updated link",
      title: "some updated title",
      votes: []
    }
    @invalid_attrs %{body: nil, link: nil, title: nil, votes: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Core.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Core.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Core.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Core.create_post(@valid_attrs)
      assert post.body == "some body"
      assert post.link == "some link"
      assert post.title == "some title"
      assert post.votes == []
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, %Post{} = post} = Core.update_post(post, @update_attrs)
      assert post.body == "some updated body"
      assert post.link == "some updated link"
      assert post.title == "some updated title"
      assert post.votes == []
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_post(post, @invalid_attrs)
      assert post == Core.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Core.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Core.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Core.change_post(post)
    end
  end
end
