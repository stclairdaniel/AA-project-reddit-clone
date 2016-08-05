class Sub < ActiveRecord::Base
  has_one :moderator,
    primary_key: :id,
    foreign_key: :moderator_id,
    class_name: :User

  validates :moderator_id, :title, :description, presence: true
end
