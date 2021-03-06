class WebhookController < ApplicationController
  protect_from_forgery except: :callback
  require 'line/bot'

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret =  ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    events = client.parse_events_from(body)

    events.each { |event|
      case event
        when Line::Bot::Event::Message
          case event.type
            when Line::Bot::Event::MessageType::Text
              message = {
                "type": "template",
                "altText": "Come on",
                "template": {
                    "type": "buttons",
                    "thumbnailImageUrl": "https://img.kyotore.jp/2017/04/article_20170421_717_totsuhara_img3-580x490.jpg",
                    "imageAspectRatio": "rectangle",
                    "imageSize": "cover",
                    "imageBackgroundColor": "#FFFFFF",
                    "title": "YURIAN",
                    "text": "Do you want to talk?",
                    "actions": [
                        {
                          "type": "postback",
                          "label": "YES",
                          "data": "YES"
                        },
                        {
                          "type": "postback",
                          "label": "NO",
                          "data": "NO"
                        }
                    ]
                }
              }
            client.reply_message(event['replyToken'], message)
          end
        when Line::Bot::Event::Postback
          if event["postback"]["data"] == "YES"
            message = {
              "type": "template",
              "altText": "Finding comedian",
              "template": {
                  "type": "buttons",
                  "thumbnailImageUrl": "https://image.slidesharecdn.com/phrasalverbs-130203100305-phpapp02/95/phrasal-verbs-english-2batx-7-638.jpg?cb=1359885841",
                  "imageAspectRatio": "rectangle",
                  "imageSize": "cover",
                  "imageBackgroundColor": "#FFFFFF",
                  "title": "Did you find comedian?",
                  "text": "Looking around well?",
                  "actions": [
                      {
                        "type": "postback",
                        "label": "OK",
                        "data": "Found"
                      }
                  ]
              }
            }
            rep_message = {
              type: 'text',
              text: "外国人が近づいています！"
            }
            client.push_message(ENV["LINE_PUSH_USER"], rep_message)
          elsif event["postback"]["data"] == "NO"
            message = {
              type: 'text',
              text: "See you"
            }
          elsif event["postback"]["data"] == "Found"
            message = {
              "type": "template",
              "altText": "Finding comedian",
              "template": {
                  "type": "buttons",
                  "thumbnailImageUrl": "https://rr.img.naver.jp/mig?src=http%3A%2F%2Flivedoor.blogimg.jp%2Fgarlsvip%2Fimgs%2F3%2F3%2F33a910a4.jpg&twidth=1200&theight=1200&qlt=80&res_format=jpg&op=r",
                  "imageAspectRatio": "rectangle",
                  "imageSize": "cover",
                  "imageBackgroundColor": "#FFFFFF",
                  "title": "Please say「nandeyanen!」",
                  "text": "Take a picture and click below link",
                  "actions": [
                    {
                      "type": "uri",
                      "label": "Please click ",
                      "uri": "https://8b98cf37.ngrok.io/users/auth/line"
                    }
                  ]
              }
            }
            rep_message = {
              type: 'text',
              text: "「なんでやねん」にツッコめるぼけをしてください！"
            }
            client.push_message(ENV["LINE_PUSH_USER"], rep_message)

          end
          client.reply_message(event['replyToken'], message)
        end
      }
      head :ok
  end
end
