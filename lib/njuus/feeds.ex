alias Njuus.Core.Post

defmodule Njuus.Feeds do
  def start() do
    HTTPoison.start()
    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get("https://www.postimees.ee/rss")
    {:ok, feed, _} = FeederEx.parse(body)

    for entry <- feed.entries do
      post = %{
        body: entry.summary,
        link: entry.link,
        title: entry.title,
        image: entry.enclosure.url
      }

      Task.start(Njuus.Core, :create_post_if_not_exists, [post])
    end
  end
end
