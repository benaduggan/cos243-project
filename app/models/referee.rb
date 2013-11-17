class Referee < ActiveRecord::Base
  belongs_to :user
  has_many :contests
  has_many :matches, as: :manager

  REGEX=/(http(?:s)?\:\/\/[a-zA-Z0-9\-]+(?:\.[a-zA-Z0-9\-]+)*\.[a-zA-Z]{2,6}(?:\/?|(?:\/[\w\-]+)*)(?:\/?|\/\w+\.[a-zA-Z]{2,4}(?:\?[\w]+\=[\w\-]+)?)?(?:\&[\w]+\=[\w\-]+)*)/  
  validates :name, length: { minimum: 2 }, uniqueness: true  
  validates :rules_url, presence: true, :format => { :with => REGEX }
  validates :players_per_game, numericality: { greater_than_or_equal_to: 1,less_than_or_equal_to: 10, only_integer: true }
  validates :file_location, presence: true, :format => { :with => /.+referees.+/ }

    
  def upload=(uploaded_file)
    if(uploaded_file.nil?)
      # problem no file
    else
      time_no_spaces = Time.now.to_s.gsub(/\s/, '_')
      file_location = Rails.root.join('code', "referees",Rails.env, time_no_spaces).to_s + SecureRandom.hex
      IO::copy_stream(uploaded_file,file_location)
    end
    self.file_location = file_location
  end
    
    
  before_destroy :delete_file
  
  def delete_file
    File.delete(self.file_location)
  end
end