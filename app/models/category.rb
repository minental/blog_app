class Category < ApplicationRecord
  has_many :posts, dependent: :destroy
  validates :name, presence: true, length: { maximum: 50 }

  default_scope -> { order(name: :desc) }

  def self.options_for_select
    order(name: :asc).map {|r| [r.name, r.id]}
  end
end
