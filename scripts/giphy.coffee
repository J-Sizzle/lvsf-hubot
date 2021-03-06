# Commands:
#   hubot giphy <term> - Returns a randomly selected gif from a search of the giphy api for <term>

giphy =
  api_key: process.env.HUBOT_GIPHY_API_KEY
  api_url: 'http://api.giphy.com/v1'


  search: (msg, q) ->
    endpoint = '/gifs/search'
    url = "#{giphy.api_url}#{endpoint}"
    msg.http(url)
      .query
        api_key: giphy.api_key
        q: q
      .get() (err, res, body) ->
        parseBody = JSON.parse(body)
        data = parseBody?.data ? []
        if data.length
          img_obj = msg.random data
          msg.send(img_obj.images.original.url)
        else
          msg.send "No results found for #{q}"

module.exports = (robot) ->
  robot.respond /animate (.*)$/i, (msg) ->
    giphy.search msg, msg.match[1]
