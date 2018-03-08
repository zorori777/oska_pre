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
                          "label": "OK",
                          "data": "OK"
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
          if event["postback"]["data"] =="OK"
            message = {
              "type": "template",
              "altText": "Come on",
              "template": {
                  "type": "buttons",
                  "title": "Found?",
                  "text": "Cute and cool",
                  "actions": [
                      {
                        "type": "postback",
                        "label": "OK",
                        "data": "Found"
                      }
                  ]
              }
            }
          elsif event["postback"]["data"] == "NO"
            message = {
              type: 'text',
              text: "See you"
            }
          elsif event["postback"]["data"] == "Found"
            message = {
              type: 'text',
              text: "Don't hesitate!"
            }
          end
          client.reply_message(event['replyToken'], message)
        end
      }
      head :ok
  end
end
