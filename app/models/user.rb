# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  has_one :api_key, dependent: :destroy
  after_create :create_user_api_key

  private

  def create_user_api_key
    create_api_key token: SecureRandom.hex
  end
end
