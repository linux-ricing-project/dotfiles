#!/bin/bash

function print_info(){
    local message="$1"
    gum style --bold --foreground="$vm_color" "$message"
}

function print_spin(){
    local message="$1"

    gum spin --title="$message" \
        --spinner.foreground="$vm_color" \
        --timeout "${init_timeout}s" -- \
        sleep "$init_timeout"
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
    init_timeout=20
else
    echo "$vm not supported yet"
    exit 0
fi

vm_search=$(incus list "$vm_name" -f json | jq -r '.[].name')
if [[ -n "$vm_search" ]];then
    vm_status=$(incus list "$vm_name" -f json | jq -r '.[].status')

    if [ "$vm_status" == "Running" ];then
        print_info "Stopping VM..."
        incus stop "$vm_name"
    fi

    incus snapshot restore "$vm_name" snap-init
    print_spin "Restoring initial Snapshot..."

    incus start "$vm_name"
    print_spin "Starting VM..."

    print_info "Updating Code inside VM"
    vm_ip=$(incus list "$vm_name" -f json | jq -r '.[].state.network.enp5s0.addresses[0].address')
    rsync --delete -avz . "ubuntu@${vm_ip}:dotfiles/"

    print_info "Initializing VM"
    incus console "$vm_name" --type=vga
else
    print_info "VM $vm_name: not found"
    exit 0
fi

