class Task < ApplicationRecord
  belongs_to :user

  #validades_presence_of :title, :user_id    ou abaixo
  validates :title, :user_id, presence: true
end
