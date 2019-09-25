class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true
  validate :reservation_criteria
  

  def reservation_criteria
    unless reservation && reservation.status == "accepted" && reservation.checkout <= DateTime.now
      errors.add(:reservation, "Cannot write a review for this reservation")
    end
  end

end
