.PHONY: dev

dev:
	docker-compose up web -d --build
	@echo "To view application logs, run \"make logs\""
	@echo "If you want to run commands in the same environment as the app, run \"make workspace\""
	@echo "When you're done with your work, run \"make stop\" to stop the running containers"

open:
	open -a 'Google Chrome' http://localhost:3000

workspace:
	docker-compose run --build workspace bash

logs:
	docker-compose logs -f

stop:
	docker-compose down