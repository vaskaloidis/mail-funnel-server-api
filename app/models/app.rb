class App < ApplicationRecord
	validates :name, presence: { strict: true }

	has_many :jobs
	has_many :emails
	has_many :email_lists
	has_many :campaigns


	# accepts_nested_attributes_for :campaigns
end
