class ChangeIsPublishedToPublishedAt < ActiveRecord::Migration[5.2]
  def up
    add_column :comfy_cms_pages, :published_at, :datetime, after: :is_published, index: true
    add_column :comfy_cms_translations, :published_at, :datetime, after: :is_published, index: true
    execute 'UPDATE comfy_cms_pages SET published_at = updated_at WHERE is_published'
    execute 'UPDATE comfy_cms_translations SET published_at = updated_at WHERE is_published'
    remove_column :comfy_cms_pages, :is_published
    remove_column :comfy_cms_translations, :is_published
  end

  def down
    add_column :comfy_cms_pages, :is_published, :boolean, null: false, default: true, after: :published_at, index: true
    add_column :comfy_cms_translations, :is_published, :boolean, null: false, default: true, after: :published_at, index: true
    execute 'UPDATE comfy_cms_pages SET is_published = FALSE WHERE published_at IS NULL'
    execute 'UPDATE comfy_cms_translations SET is_published = FALSE WHERE published_at IS NULL'
    remove_column :comfy_cms_pages, :published_at
    remove_column :comfy_cms_translations, :published_at
  end
end
