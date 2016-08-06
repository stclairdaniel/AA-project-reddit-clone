# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  url        :text
#  content    :text
#  author_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Post < ActiveRecord::Base
  validates :title, :content, :url, :author_id,  presence: true
  validate :has_a_sub

  belongs_to :author,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :post_subs

  has_many :subs,
    through: :post_subs,
    source: :sub

  has_many :comments

  private
  def has_a_sub
    unless self.subs.size > 0
      self.errors[:you] << "must select more than one sub."
    end
  end
end
