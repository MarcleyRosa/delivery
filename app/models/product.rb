class Product < ApplicationRecord
  belongs_to :store
  has_many :orders, through: :order_items
  has_many :cart_items
  has_one_attached :image
  validates :stock, numericality: { greater_than_or_equal_to: 0 }

  validate :acceptable_image

  def image_url
    if image.attached?
      # Rails.application.routes.url_helpers.url_for(image)
      Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true)
    end
  end

  def as_json(options = {})
    super(options.merge(methods: :image_url))
  end

  private

  def acceptable_image
    return unless image.attached?

    unless image.byte_size <= 1.megabyte
      errors.add(:image, "is too big")
    end

    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, "must be a JPEG or PNG")
    end
  end
end
