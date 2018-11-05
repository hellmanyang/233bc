class Book < ApplicationRecord
    has_many :chapters, dependent: :destroy
    belongs_to :user
end
