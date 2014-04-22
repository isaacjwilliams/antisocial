class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # attr_accessible :email, :password, :password_confirmation, :remember_me,
  # 				  :first_name, :last_name, :profile_name

  validates :first_name, presence: true

  validates :last_name, presence: true

  validates :profile_name, presence: true,
  						  uniqueness: true,
  						  format: {
  						    with: /[a-zA-Z0-9_-]+/,
  						   	message: 'Must be formatted correctly.'
  						  }

  has_many :statuses, dependent: :delete_all
  has_many :user_friendships, dependent: :destroy
  has_many :friends, -> { where user_friendships: { state: 'accepted' } },
                     through: :user_friendships,
                     dependent: :delete_all

  has_many :pending_user_friendships, -> { where state: 'pending' },
                                      class_name: 'UserFriendship',
                                      foreign_key: :user_id,
                                      dependent: :delete_all
  has_many :pending_friends, through: :pending_user_friendships, source: :friend, dependent: :delete_all
  has_many :activities

  def full_name
    first_name + " " + last_name
  end

  def to_param
    profile_name
  end

  def gravatar_url
    stripped_email = email.strip
    downcased_email = stripped_email.downcase
    hash = Digest::MD5.hexdigest(downcased_email)

    "http://gravatar.com/avatar/#{hash}"
  end

  def create_activity(item, action)
    activity = activities.new
    activity.targetable = item
    activity.action = action
    activity.save!
    activity
  end
end