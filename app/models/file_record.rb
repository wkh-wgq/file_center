class FileRecord < ApplicationRecord
  self.inheritance_column = :not_need

  has_one_attached :data
  before_create :generate_uid

  scope :find_by_uid, ->(uid) {
    where(uid: uid)
  }

  private
  def generate_uid
    self.uid = SecureRandom.uuid
  end
end
