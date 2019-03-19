# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  failed_attempts        :integer          default(0), not null
#  image                  :string(255)
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  locked_at              :datetime
#  name                   :string(255)
#  nickname               :string(255)
#  provider               :string(255)      default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0), not null
#  status                 :integer          default("not_verified"), not null
#  tokens                 :text(65535)
#  uid                    :string(255)      default(""), not null
#  unlock_token           :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role_id                :integer          not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable, :registerable
  devise :database_authenticatable, :recoverable, :rememberable,
         :trackable, :validatable, :lockable

  include DeviseTokenAuth::Concerns::User
  include TheRole::Api::User
  include StatusConcern

  cattr_accessor :current_user

  belongs_to :role

  before_validation :refine_values

  STATUS_NOT_VERIFIED = 1
  STATUS_ACTIVE = 2
  STATUS_INACTIVE = 3

  before_create :set_default_role

  validates :name, presence: true

  validates_uniqueness_of :email, case_sensitive: false

  validates :role_id, presence: true

  before_validation :ignore_empty_password

  enum status: { not_verified: STATUS_NOT_VERIFIED, active: STATUS_ACTIVE, inactive: STATUS_INACTIVE }

  UPDATABLE_ATTRIBUTES = %i[
    name email password status role_id
  ].freeze

  INDEX_ATTRIBUTES = %i[
    id name email status role_id last_sign_in_at
  ].freeze

  ##
  # https://github.com/plataformatec/devise/wiki/How-To:-Customize-user-account-status-validation-when-logging-in
  ##
  def active_for_authentication?
    super && active?
  end

  private

  def set_default_role
    self.role ||= Role.with_name(:guest)
  end

  def ignore_empty_password
    self.password = password.presence
  end

  private

  def refine_values
    if name.present?
      name.strip!
      name.squeeze!(' ')
      self.name = name.mb_chars.titleize.to_s
    end

    if email.present?
      email.delete!(' ')
      email.downcase!
    end
  end

end
