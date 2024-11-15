#!/bin/bash

function print_info(){
    local message="$1"
    gum style --bold --foreground="$vm_color" "$message"
}

############################################################
# MAIN
############################################################

vm=$(gum choose \
		--cursor.foreground="#E95420" \
		--selected.foreground="#E95420" \
		--no-show-help \
		"ubuntu" "arch")


if [ "$vm" == "ubuntu" ];then
    vm_name="ubuntu-dotfiles-vm"
    vm_color=#E95420
else
    echo "$vm not supported yet"
    exit 0
fi

vm_search=$(incus list "$vm_name" -f json | jq -r '.[].name')
if [[ -n "$vm_search" ]];then
    vm_status=$(incus list "$vm_name" -f json | jq -r '.[].status')

    print_info "removing VM $vm_name"
    if [ "$vm_status" == "Running" ];then
        incus stop "$vm_name"
    fi

    incus delete "$vm_name"
else
    print_info "VM $vm_name: not found"
    exit 0
fi