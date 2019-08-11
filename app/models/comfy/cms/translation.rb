# frozen_string_literal: true

class Comfy::Cms::Translation < ActiveRecord::Base

  self.table_name = "comfy_cms_translations"

  include Comfy::Cms::WithFragments

  cms_has_revisions_for :fragments_attributes

  delegate :site, to: :page

  # -- Relationships -----------------------------------------------------------
  belongs_to :page

  # -- Callbacks ---------------------------------------------------------------
  before_validation :assign_layout

  # -- Scopes ------------------------------------------------------------------
  scope :draft, -> { where(published_at: nil) }
  scope :published, ->(now = DateTime.now) { where.not(published_at: nil).where(arel_attribute(:published_at).lteq(now)) }
  scope :scheduled_for_publish, ->(now = DateTime.now) { where.not(published_at: nil).where(arel_attribute(:published_at).gt(now)) }

  # -- Validations -------------------------------------------------------------
  validates :label,
    presence:   true

  validates :locale,
    presence:   true,
    uniqueness: { scope: :page_id }

  validate :validate_locale

private

  def validate_locale
    return unless page
    errors.add(:locale) if locale == page.site.locale
  end

  def assign_layout
    self.layout ||= page.layout if page.present?
  end

end
