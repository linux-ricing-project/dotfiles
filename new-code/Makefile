
ubuntu-build:
	@docker system prune -f && \
	clear && \
	cd dev && \
	docker compose build && \
	docker compose up -d && \
	docker exec -it dotfiles-ubuntu bash

# ubuntu-exec:
# 	@docker exec -it dotfiles-ubuntu bash