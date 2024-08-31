#!/bin/bash

vm=$(gum choose \
		--cursor.foreground="#E95420" \
		--selected.foreground="#E95420" \
		--no-show-help \
		"ubuntu" "arch")

if [ "$vm" == "ubuntu" ];then
    vm_name="ubuntu-dotfiles-vm"
else
    echo "$vm not supported yet"
    exit 0
fi

vm_ip=$(incus list "$vm_name" -f json | jq -r '.[].state.network.enp5s0.addresses[0].address')
rsync --delete -avz . "ubuntu@${vm_ip}:dotfiles/"