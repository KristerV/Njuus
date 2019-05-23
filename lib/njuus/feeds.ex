defmodule Njuus.Feeds do
  def start() do
    get_feed_list()
    |> Enum.each(&Task.start(Njuus.Feeds, :fetch_posts, [&1]))
  end

  def fetch_posts([name, _category, url, icon]) do
    HTTPoison.start()

    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.get(url)

    case FeederEx.parse(body) do
      {:ok, feed, _} -> save_feed_posts(feed.entries, [name, icon])
      # ignore if no link provided
      {:fatal_error, _, _, _, %FeederEx.Feed{link: nil}} -> nil
    end
  end

  def save_feed_posts(entries, [name, icon]) do
    for entry <- entries do
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

  @doc """
  Read feeds file and return result as simple array.
  """
  def get_feed_list() do
    case File.read(Application.app_dir(:njuus, "priv/feed_list.csv")) do
      {:ok, body} -> body
      {:error, :enoent} -> raise "priv/feed_list.csv doesn't exist!"
      {:error, reason} -> raise "priv/feed_list.csv Error: #{reason}"
    end
    |> String.split("\n")
    # ignore comment rows
    |> Enum.filter(fn item -> String.first(item) != "#" end)
    |> Enum.map(&String.split(&1, ";"))
  end

  @doc """
  Read feeds file and return a handy map.

  Example structure:

  %{
    "Maaleht" => %{
      category: "uudised",
      icon: "https://g1.nh.ee/ml/ic/favicon.ico",
      url: "https://feeds2.feedburner.com/maaleht"
    },
    "Postimees" => %{
      category: "uudised",
      icon: "https://f.pmo.ee/logos/81/5ba210a7c2cc9705cfd32d200f09008d.png",
      url: "https://www.postimees.ee/rss"
    }
  }
  """
  def get_feed_map() do
    get_feed_list()
    |> Map.new(fn [name | rest] ->
      [category, url, icon] = rest
      {name, %{category: category, url: url, icon: icon}}
    end)
  end

  @doc """
  Get a map of categories and their matching providers

  Example structure:

  %{
    "krüptoraha" => ["Digikapital"],
    "majandus" => ["Ärileht", "Äripäev"],
    "tehnika" => ["Arvutimaailm", "Geenius"],
    "tervis" => ["Hingele Pai"],
    "uudised" => ["Delfi", "ERR", "Ekspress", "Maaleht", "Postimees", "Õhtuleht"]
  }
  """
  def get_default_categories() do
    get_feed_map()
    |> Enum.reduce(%{}, fn {provider, %{category: cat}}, acc ->
      update_in(acc, [cat], &((&1 || []) ++ [provider]))
    end)
  end
end
