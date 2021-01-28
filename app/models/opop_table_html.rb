class OpopTableHtml < ApplicationRecord
  validates :level, length: { is: 3 }
end
