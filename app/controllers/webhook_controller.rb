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
                    "thumbnailImageUrl": "https://c1.staticflickr.com/9/8132/29971985550_e666791121_b.jpg",
                    "imageAspectRatio": "rectangle",
                    "imageSize": "cover",
                    "imageBackgroundColor": "#FFFFFF",
                    "title": "孫悟空",
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
              text: "「なんでやねん」にツッコめるぼけをしてください！"
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
                  "title": "Please say「nandeyanen!」",
                  "text": "Take a picture and click below link",
                  "actions": [
                    {
                      "type": "uri",
                      "label": "Please click ",
                      "uri": "https://98cc7ff3.ngrok.io/users/auth/line"
                    }
                  ]
              }
            }
          end
          client.reply_message(event['replyToken'], message)
        end
      }
      head :ok
  end
end
