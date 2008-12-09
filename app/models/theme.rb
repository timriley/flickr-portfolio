class Theme
  include Singleton
  include Validatable
  
  THEME_FILE = File.join(Rails.root, 'config', 'template.html')

  attr_accessor :template
  
  validates_presence_of :template
  
  def initialize
    @template = File.read(THEME_FILE) rescue ''
  end
  
  def save
    backup_file
    File.open(THEME_FILE, 'w+') do |file|
      file.write(@template)
      file.flush
    end
  end
  
  protected
  
  def backup_file
    FileUtils.cp_r THEME_FILE, "#{THEME_FILE}~"
  end
end