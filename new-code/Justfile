
start-vm:
	@bash dev/start-vm.sh

update-code-vm:
	@bash dev/update-code-on-vm.sh

reset-vm:
	@bash dev/reset-vm.sh

delete-vm:
	@bash dev/delete-vm.sh

ubuntu-build:
	@docker system prune -f && \
	clear && \
	cd dev && \
	docker compose build && \
	docker compose up -d && \
	docker exec -it dotfiles-ubuntu bash