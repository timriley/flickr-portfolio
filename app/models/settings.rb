class Settings
  include Singleton
  include Validatable

  validates_presence_of :flickr_user_id, :synchronise_tag
  validates_presence_of :crypted_password, :crypted_password_salt
  
  # accessor for the unencrypted password
  attr_accessor :password
  
  # this allows us to read and write settings of any name
  def method_missing(method_id, *arguments)
    case method_id.to_s
    when /^crypted_.*\?$/:
      match_crypted_setting(method_id.to_s.gsub(/\?$/, ''), arguments.first)
    when /^crypted_.*=$/:
      write_crypted_setting(method_id.to_s.gsub(/=$/, ''), arguments.first)
    when /\?$/:
      match_setting(method_id.to_s.gsub(/\?$/, ''), arguments.first)
    when /=$/:
      write_setting(method_id.to_s.gsub(/=$/, ''), arguments.first)
    else
      read_setting(method_id.to_s)
    end
  end
  
  def save
    if valid?
      # encrypt the password
      self.crypted_password = self.password unless self.password.blank?
    
      File.open("#{Rails.root}/config/config.yml", 'w') { |f| YAML.dump(@raw_tree, f) }
    else
      false
    end
  end
  
  protected
  
  def tree
    @raw_tree ||= YAML.load_file("#{Rails.root}/config/config.yml")
  end
    
  def read_setting(key)
    tree[Rails.env][key]
  end
  
  def write_setting(key, val)
    tree[Rails.env][key] = val
  end
  
  def write_crypted_setting(key, val)
    salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--")
    write_setting("#{key}_salt", salt)
    write_setting(key, encrypt(val, salt))
  end
  
  def match_setting(key, val)
    read_setting(key) == val
  end
  
  def match_crypted_setting(key, val)
    read_setting(key) == encrypt(val, read_setting("#{key}_salt"))
  end
  
  def encrypt(string, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{string}--")
  end
end