ActiveRecord::Schema[7.2].define(version: 2024_09_03_140554) do
  
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
  end

  create_table "photos", force: :cascade do |t|
    t.string "image_url"
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_photos_on_post_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "youtube_url"
    t.boolean "saved"
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "featured"
    t.integer "views_count", default: 0
    t.index ["category_id"], name: "index_posts_on_category_id"
  end

  add_foreign_key "comments", "posts"
  add_foreign_key "photos", "posts"
  add_foreign_key "posts", "categories"
end
