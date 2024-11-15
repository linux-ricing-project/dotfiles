#!/bin/bash

os_name=$(grep "^NAME=" /etc/os-release | cut -d '=' -f2 | sed 's/"//g')

case $os_name in
  Ubuntu) os_color="#E95420" ;;
  Arch) os_color="#1793D1" ;;
  *)
    print_message "Unsupported OS"
    exit 1
    ;;
esac

vm=$(gum choose \
        --header "What the OS?" \
        --header.foreground="#FFFFFF" \
		--cursor.foreground="$os_color" \
		--selected.foreground="$os_color" \
		--no-show-help \
		"ubuntu" "arch")

if [ -z "$vm" ];then
    exit 0
fi

vm_name="$vm-dotfiles-vm"
vm_search=$(incus list "$vm_name" -f json | jq -r '.[].name')

if [[ -n "$vm_search" ]];then
	vm_ip=$(incus list "$vm_name" -f json | jq -r '.[].state.network.enp5s0.addresses[0].address')
	rsync --delete -avz . "ubuntu@${vm_ip}:dotfiles/"
else
	echo "$vm doens't exists"
	exit 0
fi
