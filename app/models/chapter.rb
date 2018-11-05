class Chapter < ApplicationRecord
    belongs_to :book
    
    def next
      book.chapters.where("id > ?", id).first
    end
  
    def prev
      book.chapters.where("id < ?", id).last
    end
end
