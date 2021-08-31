class User < ApplicationRecord
   attr_accessor :remember_token
    validates :name, presence: true, length: {minimum:3}, uniqueness: {case_sensitive: false}
    validates :email, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "Enter valid email"}, uniqueness: true, presence: true
    validates :password, presence: true, format: {with: /(?=^.{8,12}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/, message: "should be at least one Uppercase,one digit and one special character and upto 8 characters", multiline: true} 
    validates_confirmation_of :password
    has_many :tweets
    has_many :comments
    has_secure_password

    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
        # Returns a random token.
        
    def User.new_token
        SecureRandom.urlsafe_base64
    end


    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    def authenticated?(remember_token)
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    def forget
        update_attribute(:remember_digest, nil)
    end
end
