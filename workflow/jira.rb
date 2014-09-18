#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'cgi'
require 'json'
require 'config'

class JIRA

  def self.issues
    @issues ||= (
      check_config!

      url = "#{config['url']}/rest/api/2/search"
      uri = URI.parse(url)

      uri.query = URI.encode_www_form({
        jql: config['query'],
        maxResults: config['max_results'] || 500,
        fields: 'summary,description'
      })

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri.request_uri)
      request.basic_auth(config['username'], config['password'])
      response = http.request(request)

      data = JSON.parse(response.body)

      data['issues'].inject({}) do |hash, issue|
        hash[issue['key']] = {
          summary: issue['fields']['summary'],
          description: issue['fields']['description']
        }
        hash
      end
    )
  end
end
