# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170307023910) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "apps", force: :cascade do |t|
    t.string   "name",       :index=>{:name=>"index_apps_on_name", :unique=>true, :using=>:btree}
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
    t.string   "auth_token", :index=>{:name=>"index_apps_on_auth_token", :unique=>true, :using=>:btree}
  end

  create_table "email_lists", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null=>false
    t.datetime "updated_at",  :null=>false
    t.integer  "app_id",      :foreign_key=>{:references=>"apps", :name=>"fk_email_lists_app_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__email_lists_app_id", :using=>:btree}
  end

  create_table "hooks", force: :cascade do |t|
    t.text     "name"
    t.text     "identifier"
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end

  create_table "campaigns", force: :cascade do |t|
    t.integer  "hook_id",         :foreign_key=>{:references=>"hooks", :name=>"fk_campaigns_hook_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__campaigns_hook_id", :using=>:btree}
    t.string   "name"
    t.string   "hook_identifier"
    t.integer  "app_id",          :foreign_key=>{:references=>"apps", :name=>"fk_campaigns_app_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__campaigns_app_id", :using=>:btree}
    t.integer  "email_list_id",   :foreign_key=>{:references=>"email_lists", :name=>"fk_campaigns_email_list_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__campaigns_email_list_id", :using=>:btree}
    t.datetime "created_at",      :null=>false
    t.datetime "updated_at",      :null=>false
  end

  create_table "emails", force: :cascade do |t|
    t.string   "email_address"
    t.string   "name"
    t.datetime "created_at",    :null=>false
    t.datetime "updated_at",    :null=>false
    t.integer  "app_id",        :foreign_key=>{:references=>"apps", :name=>"fk_emails_app_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__emails_app_id", :using=>:btree}
    t.integer  "email_list_id", :foreign_key=>{:references=>"email_lists", :name=>"fk_emails_email_list_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__emails_email_list_id", :using=>:btree}
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "subject"
    t.text     "content"
    t.datetime "created_at",        :null=>false
    t.datetime "updated_at",        :null=>false
    t.integer  "email_list_id",     :foreign_key=>{:references=>"email_lists", :name=>"fk_jobs_email_list_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__jobs_email_list_id", :using=>:btree}
    t.integer  "app_id",            :foreign_key=>{:references=>"apps", :name=>"fk_jobs_app_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__jobs_app_id", :using=>:btree}
    t.boolean  "executed"
    t.integer  "execute_time"
    t.string   "hook_identifier"
    t.string   "execute_frequency"
    t.string   "name"
    t.integer  "hook_id",           :foreign_key=>{:references=>"hooks", :name=>"fk_jobs_hook_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__jobs_hook_id", :using=>:btree}
    t.integer  "campaign_id",       :foreign_key=>{:references=>"campaigns", :name=>"fk_jobs_campaign_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__jobs_campaign_id", :using=>:btree}
    t.datetime "execute_date"
    t.string   "queue_identifier"
    t.datetime "execute_set_time"
  end

  create_table "campaign_product_leads", force: :cascade do |t|
    t.integer  "app_id",             :foreign_key=>{:references=>"apps", :name=>"fk_campaign_product_leads_app_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__campaign_product_leads_app_id", :using=>:btree}
    t.integer  "product_identifier"
    t.integer  "campaign_id",        :foreign_key=>{:references=>"campaigns", :name=>"fk_campaign_product_leads_campaign_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__campaign_product_leads_campaign_id", :using=>:btree}
    t.integer  "job_id",             :foreign_key=>{:references=>"jobs", :name=>"fk_campaign_product_leads_job_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__campaign_product_leads_job_id", :using=>:btree}
    t.boolean  "sold",               :default=>false
    t.decimal  "sale_ammount",       :default=>"0.0"
    t.integer  "email_list_id",      :foreign_key=>{:references=>"email_lists", :name=>"fk_campaign_product_leads_email_list_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__campaign_product_leads_email_list_id", :using=>:btree}
    t.integer  "email_id",           :foreign_key=>{:references=>"emails", :name=>"fk_campaign_product_leads_email_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__campaign_product_leads_email_id", :using=>:btree}
    t.datetime "BuyDate"
    t.datetime "ClickDate"
    t.string   "Source"
  end

  create_table "configs", force: :cascade do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end

  create_table "job_queues", force: :cascade do |t|
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end

  create_table "mail_funnel_server_configs", force: :cascade do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end

  create_table "shops", force: :cascade do |t|
    t.string   "shopify_domain", :null=>false, :index=>{:name=>"index_shops_on_shopify_domain", :unique=>true, :using=>:btree}
    t.string   "shopify_token",  :null=>false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
