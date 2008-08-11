class Theme
  include Singleton
  include Validatable
  
  THEME_FILE = "#{Rails.root}/config/template.txt"

  attr_accessor :template
  
  validates_presence_of :template
  
  def initialize
    @template = File.read(THEME_FILE) rescue ''
  end
  
  def save
    backup_file
    File.open(THEME_FILE) do |file|
      file.write(@template)
      file.flush
    end
  end
  
  protected
  
  def backup_file
    FileUtils.cp_r THEME_FILE, "#{THEME_FILE}~"
  end
end