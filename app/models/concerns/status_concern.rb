# STATUSES hash must be defined after including StatusConcern in model
module StatusConcern
  extend ActiveSupport::Concern

  included do

    validates :status, presence: true

    validates :status, inclusion: { in: Proc.new{ self.statuses.keys } }, allow_blank: true , on: :create

    def self.statuses_select
      statuses_i18n.invert
    end

    def self.statuses_invert
      statuses.invert
    end

    def self.statuses_search_select
      statuses_i18n.each_with_object({}) do |(k, v), obj|
        obj[statuses[k]] = v
      end.invert
    end
  end
end
