#SERVER - Seeds.rb

require 'sidekiq/api'
Sidekiq::Queue.new.clear

# Config
MailFunnelServerConfig.create(name: "app_name", value: ENV["APP_NAME"])
MailFunnelServerConfig.create(name: "app_key", value: ENV["APP_KEY"])
MailFunnelServerConfig.create(name: "app_secret", value: ENV["APP_SECRET"])
MailFunnelServerConfig.create(name: "app_scope", value: ENV["APP_SCOPE"])
#
# server_url = "http://localhost:3001/"
server_url = ENV['APP_URL']
MailFunnelServerConfig.create(name: "app_url", value: server_url)
MailFunnelServerConfig.create(name: "api_url", value: server_url + "api/")

# Checkout
cart_create_hook = Hook.create(name: 'Cart / Create', identifier: 'cart_create');
cart_update_hook = Hook.create(name: 'Cart / Update', identifier: 'cart_update');
cart_abandon_hook    = Hook.create(name: 'Cart / Abandon', identifier: 'cart_abandon');

# Checkout
checkout_create_hook = Hook.create(name: 'Checkout / Create', identifier: 'checkout_create');
checkout_update_hook = Hook.create(name: 'Checkout / Update', identifier: 'checkout_update');

# Order
order_create_hook    = Hook.create(name: 'Order / Create', identifier: 'order_create');
order_update_hook = Hook.create(name: 'Order / Update', identifier: 'order_update');

seed_data = false

if seed_data

	generate_client_data = false

# GENERATE OUR DEFAULT DATA
# TODO: Move this to client-install
	if generate_client_data

		app_create = App.new(name: ShopifyAPI::Shop.current.domain)
		if app_create.new_record?
			app_create.save!
			puts "App did not exist, created with id: " + app.id.to_s
		else
			puts "App exists already"
		end

		app         = app_create.id

		# app_create = BluehelmetUtil.get_app
		# app        = app_create.id
		defaultlist = EmailList.new(name:        "Default",
		                            description: "The default Mail-Funnel email list",
		                            app_id:      app);

		if defaultlist.new_record?
			puts "Default list does not exist, create it"
			defaultlist.save!
		else
			puts "Default list exists already"
		end

		$y = 0
		until $y > Random.rand(1...5) do
			email = Email.create(email_address: Faker::Internet.email,
			                     app_id:        app,
			                     email_list_id: defaultlist.id);
			puts defaultlist.name.to_s + ": Email Created " + email.email.to_s
			$y += 1
		end

		# GENERATE OUR OTHER Data
		$x = 0
		until $x > Random.rand(2...3) do
			list = EmailList.create(name:        "Email List some Name " + $x.to_s,
			                        description: "A Mail-Funnel email list",
			                        app_id:      app)

			$y = 0
			until $y > Random.rand(1...10) do
				email = Email.create(email_address: Faker::Internet.email,
				                     name:          Faker::Name.name,
				                     app_id:        app,
				                     email_list_id: list.id)
				puts list.name.to_s + ": Email Created " + email.email.to_s
				$y += 1
			end
			$x += 1
		end

	else
		# What to do if we didn't create client data - nothing
	end


# TEST DATA
	puts 'GENERATING EXTRA SEED DATA:'
	$x = 0
	while $x < 20 do
		app = App.create(name: "App-Name " + $x.to_s)
		puts "Created App Name: " + app.name + " ID: - " + app.id.to_s

		$y = 0
		while $y < 5 do
			list = EmailList.create(name:        "Main List " + $y.to_s,
			                        description: Faker::Lorem.sentence,
			                        app_id:      app.id)

			puts "Created List " + list.name.to_s

			$z = 0
			while $z > Random.rand(3...10) do
				email = Email.create(email_address: Faker::Internet.email,
				                     name:          Faker::Name.name,
				                     app_id:        app.id,
				                     email_list_id: list.id)
				puts list.name.to_s + ": Email Created " + email.email.to_s
				$z += 1
			end

			$y +=1
		end

		$j = 0
		while $j < Random.rand(10...30) do
			job = Job.create(execute_frequency:   "execute_once",
			                 execute_time:        Random.rand(0...23),
			                 execute_set_time:    now,
			                 subject:             Faker::Lorem.sentence,
			                 content:             Faker::Lorem.paragraphs(1),
			                 name:                Faker::Commerce.product_name,
			                 app_id:              app.id,
			                 hook_identifier:     Hook.offset(rand(Hook.count)).first.identifier,
			                 executed:            false,
			)
			puts "Job Created for " + job.hook_identifier.to_s
			$j += 1
		end

		$x +=1
	end


end