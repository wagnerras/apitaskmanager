class Api::V2::TaskSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :description, :done, :deadline, :created_at, :updated_at,
             :short_description, :is_late, :deadline_to_br


  def short_description
    object.description[0..40] if object.description.present?
  end

  def is_late
    Time.current > object.deadline if object.deadline.present?
  end

  def deadline_to_br
   I18n.l(object.deadline, format: :datetime) if object.deadline.present?
  end

  belongs_to :user

end
