class Settings
  include Singleton
  
  def method_missing(method_id, *arguments)
    if /=$/ =~ method_id.to_s
      write_setting(method_id.to_s.gsub(/=$/,''), arguments.first)
    else
      read_setting(method_id.to_s)
    end
  end

  private
  
  def load_tree
    @raw_tree = YAML.load_file("#{Rails.root}/config/config.yml")
  end
  
  def save_tree
    # merge the trees
    @raw_tree[Rails.env] = @new_tree[Rails.env]
    File.open("#{Rails.root}/config/config.yml", 'w') { |f| YAML.dump(@raw_tree, f) }
  end
  
  def read_setting(key)
    load_tree
    @raw_tree[Rails.env][key]
  end
  
  def write_setting(key, val)
    load_tree
    @new_tree ||= @raw_tree.dup
    @new_tree[Rails.env][key] = val
    save_tree
  end
end

def settings
  Settings.instance
end