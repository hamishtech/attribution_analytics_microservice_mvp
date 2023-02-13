build:
	docker-compose build

bundle:
	docker-compose run --rm web bundle install

dbsetup:
	docker-compose run --rm web bundle exec rails db:setup

dbcreate:
	docker-compose run --rm web bundle exec rails db:create

dbmigrate:
	docker-compose run --rm web bundle exec rails db:migrate

dbreset:
	docker-compose run --rm web bundle exec rails db:reset

dbrollback:
	docker-compose run --rm web bundle exec rails db:rollback

server:
	docker-compose run --rm --service-ports web

console:
	docker-compose run --rm web bundle exec rails console

bash:
	docker-compose run --rm web bash

tests:
	docker-compose run --rm web bundle exec rspec

routes:
	docker-compose run --rm web bundle exec rails routes

seed:
	docker compose run --rm web bundle exec rails db:seed