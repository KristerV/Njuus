alias Njuus.Core.Post

defmodule Njuus.Feeds do
  def start() do
    case File.read(Application.app_dir(:njuus, "priv/feed_list.csv")) do
      {:ok, body} -> body
      {:error, :enoent} -> raise "priv/feed_list.csv doesn't exist!"
      {:error, reason} -> raise "priv/feed_list.csv Error: #{reason}"
    end
    |> String.split("\n")
    # ignore comment rows
    |> Enum.filter(fn item -> String.first(item) != "#" end)
    |> Enum.map(&String.split(&1, ";"))
    |> Enum.each(&Task.start(Njuus.Feeds, :fetch_posts, [&1]))
  end

  def fetch_posts([name, _category, url, icon]) do
    HTTPoison.start()
    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get(url)
    {:ok, feed, _} = FeederEx.parse(body)

    for entry <- feed.entries do
      post = %{
        provider: name,
        body: entry.summary,
        link: entry.link,
        title: entry.title,
        image: if(entry.enclosure, do: entry.enclosure.url, else: entry.image),
        categories: entry.categories,
        datetime: Utils.parseDate(entry.updated),
        icon: icon,
        source: entry.author
      }

      Task.start(Njuus.Core, :create_post_if_not_exists, [post])
    end
  end
end
