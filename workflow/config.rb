CONFIG_FILE = '~/.jira-search-issues-config.yml'

def config
  filepath = File.expand_path CONFIG_FILE
  @config ||= (
    if File.exists?(filepath)
      YAML.load File.read(filepath)
    else
      raise "You must create the #{CONFIG_FILE} configuration file first!"
    end
  )
end

def check_config!
  mandatory_items = [:username, :password, :query, :url]
  found_items = config.keys.map(&:to_sym)
  missing_items = mandatory_items - found_items
  if missing_items.any?
    raise "Missing #{missing_items} in #{CONFIG_FILE} configuration file!"
  end
end
