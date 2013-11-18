class Player < ActiveRecord::Base
  belongs_to :user
  belongs_to :contest
  has_many :matches, through: :player_matches
  has_many :player_matches
  validates :user,  presence: true
  validates :contest, presence: true
  
  validates :name, length: { minimum: 2 }, uniqueness: true 
  validates :description, presence: true
  validates :file_location, presence: true
  
  
  validate :filelocationstuff
  
  def filelocationstuff
    if self.file_location && !File.exists?(self.file_location)
      errors.add( :file_location, " is invalid!")
    end
  end
  
  
  def upload=(uploaded_file)
    if(uploaded_file.nil?)
      #idk what to do here
    else
      time_no_spaces = Time.now.to_s.gsub(/\s/, '_')
      file_location = Rails.root.join('code', "players",Rails.env, time_no_spaces).to_s + SecureRandom.hex
      IO::copy_stream(uploaded_file,file_location)
    end
    self.file_location = file_location
    if File.exists?(file_location)
      flash[:danger]="That was an invalid file location!"
      redirect_to root_path
    end
  end
  
  before_destroy :delete_file
  
  def delete_file
    File.delete(self.file_location)
  end
end