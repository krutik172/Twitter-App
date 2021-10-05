class User < ApplicationRecord
    attr_accessor :remember_token, :activation_token
    validates :name, presence: true, length: {minimum:3}, uniqueness: {case_sensitive: false}
    validates :email, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "Enter valid email"}, uniqueness: true, presence: true
    validates :password, presence: true, format: {with: /(?=^.{8,12}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/, message: "should be at least one Uppercase,one digit and one special character and upto 8 characters", multiline: true} 
    validates_confirmation_of :password
    has_many :tweets
    has_many :comments  
    has_many :active_relationships, class_name: "Relationship",
                                    foreign_key: "follower_id",
                                    dependent: :destroy
    has_many :passive_relationships, class_name: "Relationship",
                                     foreign_key: "followed_id",
                                     dependent: :destroy
    has_many :following, through: :active_relationships, source: :followed
    has_many :followers, through: :passive_relationships, source: :follower
    has_secure_password
    before_save :downcase_email
    before_create :create_activation_digest

    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
        # Returns a random token.
    def activate
        update_columns(activated: FILL_IN, activated_at: FILL_IN)
    end
    def User.new_token
        SecureRandom.urlsafe_base64
    end


    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    # def authenticated?(remember_token)
    #     BCrypt::Password.new(remember_digest).is_password?(remember_token)
    # end
    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end

    def forget
        update_attribute(:remember_digest, nil)
    end

    def follow(other_user)
        following << other_user unless self == other_user
    end

    def unfollow(other_user)
        following.delete(other_user)
    end

    def following?(other_user)
        following.include?(other_user)
    end
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end

    private

    def downcase_email
        self.email=email.downcase
    end

    def create_activation_digest
        self.activation_token=User.new_token
        self.activation_digest=User.digest(activation_token)
    end
end
