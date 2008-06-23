class Settings
  include Singleton
  
  # this allows us to read and write settings of any name
  def method_missing(method_id, *arguments)
    if /=$/ =~ method_id.to_s
      write_setting(method_id.to_s.gsub(/=$/,''), arguments.first)
    else
      read_setting(method_id.to_s)
    end
  end
  
  # the password setting is special, we need to encrypt its contents
  def password=(value)
    salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--")
    write_setting('password_salt', salt)
    write_setting('password', self.class.encrypt(value, salt))
  end
  
  def password?(password)
    self.password == self.class.encrypt(password, self.password_salt)
  end
  
  def save
    File.open("#{Rails.root}/config/config.yml", 'w') { |f| YAML.dump(@raw_tree, f) }
  end
  
  def self.encrypt(string, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{string}--")
  end

  private
  
  def tree
    @raw_tree ||= YAML.load_file("#{Rails.root}/config/config.yml")
  end
    
  def read_setting(key)
    tree[Rails.env][key]
  end
  
  def write_setting(key, val)
    tree[Rails.env][key] = val
  end
end