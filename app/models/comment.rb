# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  content    :text             not null
#  post_id    :integer          not null
#  author_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Comment < ActiveRecord::Base
  validates :content, :post_id, :author_id, presence: true

  belongs_to :post

  belongs_to :author,
    primary_key: :id,
    foreign_key: :author_id,
    class_name: :User

end
