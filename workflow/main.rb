#!/usr/bin/env ruby

# ============== = ===========================================================
# Description    : Alfred 2 JIRA Search Issues Workflow
# Author         : Romain Champourlier <pro@rchampourlier.com>
# HomePage       : https://github.com/rchampourlier/alfred-workflow-jira-search-issues
# Version        : 0.1.0
# Tag            : [ ruby, alfred, workflow, jira ]
# Copyright      : © 2014 by Romain Champourlier,
#                  Released under current MIT license.
# ============== = ===========================================================
($LOAD_PATH << File.expand_path('..', __FILE__)).uniq!

require 'rubygems' unless defined? Gem # rubygems is only needed in 1.8

require 'bundle/bundler/setup'
require 'alfred'
#require 'log'

require 'config'
$workflow_config = config

class JIRASearchIssues < ::Alfred::Handler::Base

  def initialize(alfred, opts = {})
    super

    @settings = {
      handler: 'JIRASearchIssues',
      expire: $workflow_config['cache_duration'],
    }.update(opts)

    feedback.use_cache_file :expire => @settings[:expire]
  end

  def generate_feedback
    require 'jira'
    JIRA.issues.each do |key, data|

      arg = xml_builder(
        :handler => @settings[:handler] ,
        :key => key
      )

      feedback.add_item({
        :uid      => key,
        :title    => "#{key} - #{data[:summary]}",
        :subtitle => data[:description],
        :arg      => arg,
        :type     => 'jira:issue',
        :match?   => :all_title_match?
      })
    end

    feedback.put_cached_feedback
  end

  def on_feedback
    if !options.should_reload_cached_feedback and fb = feedback.get_cached_feedback
      feedback.merge! fb
    else
      generate_feedback
    end
  end

  def on_action(arg)
    return unless action?(arg)

    # Available modifiers: none, command...
    case options.modifier
    when :none
      url = jira_issue_url(arg[:key])
      Alfred::Util.open_url url
    end
  end

  def jira_issue_url(key)
    "#{$workflow_config['url']}/browse/#{key}"
  end
end

Alfred.with_friendly_error do |alfred|
  alfred.with_rescue_feedback = true
  alfred.with_help_feedback = false
  alfred.cached_feedback_reload_option[:use_reload_option] = true
  alfred.cached_feedback_reload_option[:use_exclamation_mark] = true

  JIRASearchIssues.new(alfred).register
end
