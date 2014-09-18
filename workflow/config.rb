SETTINGS_FILE = '~/.jira-search-issues-config.yml'

def config
  filepath = File.expand_path SETTINGS_FILE
  @settings ||= (
    if File.exists?(filepath)
      YAML.load File.read(filepath)
    else
      raise "You must create the #{SETTINGS_FILE} configuration file first!"
    end
  )
end

def check_config!
  mandatory_settings = [:username, :password, :query, :url]
  found_settings = settings.keys.map(&:to_sym)
  missing_settings = mandatory_settings - found_settings
  if missing_settings.any?
    raise "Missing #{missing_settings} in #{SETTINGS_FILE} configuration file!"
  end
end
