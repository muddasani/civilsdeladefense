# frozen_string_literal: true

# Top level organization where all other resources are tight to
# aka a customer for the SaaS platform
class Organization < ApplicationRecord
  has_many :administrators
  has_many :job_applications
  has_many :job_offers
  has_many :organization_defaults
  has_many :pages
  has_many :users

  validates :name, :name_business_owner, :subdomain, presence: true

  %i[logo_vertical logo_horizontal logo_vertical_negative logo_horizontal_negative].each do |field|
    mount_uploader field, LogoUploader, mount_on: :"#{field}_file_name"
    validates field,
              file_size: { less_than: 1.megabytes }
  end

  mount_uploader :image_background, LogoUploader, mount_on: :image_background_file_name
  validates :image_background,
            file_size: { less_than: 1.megabytes }

  #####################################
  # Enums
  INBOUND_EMAIL_CONFIGS = {
    not_available: 0,
    hidden_headers: 10,
    catch_all: 20
  }.freeze
  enum inbound_email_config: INBOUND_EMAIL_CONFIGS, _prefix: true
end
