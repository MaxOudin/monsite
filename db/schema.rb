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

ActiveRecord::Schema[7.1].define(version: 2024_01_18_090823) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "outils", force: :cascade do |t|
    t.string "nom"
    t.text "description"
    t.string "icone_url"
    t.string "icone_url_alt"
    t.bigint "projet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["projet_id"], name: "index_outils_on_projet_id"
  end

  create_table "projets", force: :cascade do |t|
    t.string "titre"
    t.string "type_projet"
    t.text "description"
    t.text "image_url"
    t.string "image_url_alt"
    t.date "date_debut"
    t.date "date_fin"
    t.string "client"
    t.string "projet_lien"
    t.string "github_lien"
    t.string "couleur"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "services", force: :cascade do |t|
    t.string "nom"
    t.text "description"
    t.text "icone_url"
    t.string "icone_url_alt"
    t.string "couleur"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sujets", force: :cascade do |t|
    t.string "nom"
    t.text "description"
    t.integer "numero"
    t.string "couleur"
    t.text "icone_url"
    t.string "icone_url_alt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "outils", "projets"
end
