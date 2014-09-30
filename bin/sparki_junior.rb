require 'rest-client'
require 'addressable/uri'
require 'launchy'
require 'json'

# https://en.wikipedia.org/w/api.php?action=opensearch&search=api&limit=10&namespace=0&format=jsonfm

def build_search_uri(search_string)
  search_uri = Addressable::URI.new(
  scheme: "http",
  host: "en.wikipedia.org",
  path: "w/api.php",
  query_values: {
    action: "opensearch",
    search: search_string,
    limit: "10",
    format: "json"
    }).to_s
end

def get_article_title_from_search(search_string)
  search_response = RestClient.get(build_search_uri(search_string))
  search_response = JSON.parse(search_response)

  unless search_response[1].empty?
    return search_response[1][0]
  end

  nil
end

def build_article_uri(title)
  Addressable::URI.new(
    scheme: "http",
    host: "en.wikipedia.org",
    path: "w/api.php",
    query_values: {
      action: "query",
      titles: title,
      format: "json",
      prop: "extracts",
      explaintext: "true"
      }).to_s
end


if __FILE__ == $PROGRAM_NAME
  search_string = get_article_title_from_search("Abraham Lincoln")
  Launchy.open(build_article_uri(search_string))
end
