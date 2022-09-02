class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image

  has_many :books
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  # フォローしている人取得(Userのfollowerから見た関係)
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # フォローされている人取得(Userのfolowedから見た関係)
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  # 一覧画面で使う(自分がフォローした)
  has_many :followings, through: :follower, source: :followed
  # 一覧画面で使う(自分がフォローされた)
  has_many :followers, through: :followed, source: :follower

   # ユーザーをフォローする
  def follow(user_id)
   follower.create(followed_id: user_id)
  end
  # ユーザーのフォローを外す
  def unfollow(user_id)
   follower.find_by(followed_id: user_id).destroy
  end
  # フォロー確認をおこなう
  def following?(user)
   followings.include?(user)
  end

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }



  def get_profile_image(width,height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image', content_type:'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width,height]).processed
  end
    # (profile_image.attached?) ? profile_image : 'no_image.jpg'
end
