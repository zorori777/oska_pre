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
                    "title": "Boke",
                    "text": "Please select",
                    "actions": [
                        {
                          "type": "postback",
                          "label": "NANDEYANEN",
                          "data": "action=buy&itemid=123"
                        },
                        {
                          "type": "postback",
                          "label": "OI",
                          "data": "action=add&itemid=123"
                        },
                        {
                          "type": "postback",
                          "label": "FUCK",
                          "data": "action=add&itemid=123"
                        }
                    ]
                }
              }
            client.reply_message(event['replyToken'], message)
            when Line::Bot::Event::MessageType::Image
              message = {
                type: 'text',
                text: "テストなう"
              }
              client.push_message(event['replyToken'], message)
          end
      end
      }
      head :ok
  end
end
