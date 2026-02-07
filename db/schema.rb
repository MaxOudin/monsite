# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_02_07_221137) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "articles", force: :cascade do |t|
    t.string "couleur"
    t.datetime "created_at", null: false
    t.string "image_alt"
    t.string "image_url"
    t.string "slug"
    t.string "theme"
    t.string "titre"
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_articles_on_slug", unique: true
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.datetime "created_at"
    t.string "scope"
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "exp"
    t.string "jti"
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti"
  end

  create_table "outils", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "icone_url"
    t.string "icone_url_alt"
    t.string "nom"
    t.bigint "projet_id"
    t.datetime "updated_at", null: false
    t.index ["projet_id"], name: "index_outils_on_projet_id"
  end

  create_table "outils_projets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "outil_id", null: false
    t.bigint "projet_id", null: false
    t.datetime "updated_at", null: false
    t.index ["outil_id"], name: "index_outils_projets_on_outil_id"
    t.index ["projet_id"], name: "index_outils_projets_on_projet_id"
  end

  create_table "projets", force: :cascade do |t|
    t.string "client"
    t.string "couleur"
    t.datetime "created_at", null: false
    t.date "date_debut"
    t.date "date_fin"
    t.text "description"
    t.string "github_lien"
    t.text "image_url"
    t.string "image_url_alt"
    t.string "projet_lien"
    t.string "slug"
    t.string "titre"
    t.string "type_projet"
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_projets_on_slug", unique: true
  end

  create_table "services", force: :cascade do |t|
    t.string "couleur"
    t.datetime "created_at", null: false
    t.text "description"
    t.text "icone_url"
    t.string "icone_url_alt"
    t.string "nom"
    t.datetime "updated_at", null: false
  end

  create_table "sujets", force: :cascade do |t|
    t.string "couleur"
    t.datetime "created_at", null: false
    t.text "description"
    t.text "icone_url"
    t.string "icone_url_alt"
    t.string "nom"
    t.integer "numero"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "outils", "projets"
  add_foreign_key "outils_projets", "outils"
  add_foreign_key "outils_projets", "projets"
end
