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

vm_disk_size="30GiB"
vm_cpu=2
vm_memory="4GiB"


ubuntu_version=24.04

if [ "$vm" == "ubuntu" ];then
    vm_name="ubuntu-dotfiles-vm"
    vm_image=ubuntu/${ubuntu_version}/desktop
    vm_color=#E95420
    init_timeout=30
else
    echo "$vm not supported yet"
    exit 0
fi

vm_search=$(incus list "$vm_name" -f json | jq -r '.[].name')
if [[ -n "$vm_search" ]];then
    vm_status=$(incus list "$vm_name" -f json | jq -r '.[].status')

    if [ "$vm_status" == "Running" ];then
        print_info "Starting VM"
        incus console "$vm_name" --type=vga
    else
        incus start "$vm_name"
        print_spin "Initializing the VM..."
        incus console "$vm_name" --type=vga
    fi
else
    incus launch "images:${vm_image}" "$vm_name" --vm \
    --device root,size=$vm_disk_size \
    --config limits.cpu=$vm_cpu \
    --config limits.memory=$vm_memory

    print_spin "Initializing the VM..."

    incus exec "$vm_name" -- apt update
    incus exec "$vm_name" -- apt upgrade -y
    incus exec "$vm_name" -- apt install openssh-server rsync -y
    incus exec "$vm_name" -- passwd ubuntu

    vm_ip=$(incus list "$vm_name" -f json | jq -r '.[].state.network.enp5s0.addresses[0].address')
    rsync -avz . "ubuntu@${vm_ip}:Documents/"

    incus snapshot create "$vm_name" snap-init

    print_info "Initializing the VM..."
    incus console "$vm_name" --type=vga
fi
