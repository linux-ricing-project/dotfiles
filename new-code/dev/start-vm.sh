#!/bin/bash

function print_info(){
    local message="$1"
    gum style --bold --foreground="$os_color" "$message"
}

function print_spin(){
    local message="$1"

    gum spin --title="$message" \
        --spinner.foreground="$os_color" \
        --timeout "${init_timeout}s" -- \
        sleep "$init_timeout"
}

############################################################
# MAIN
############################################################

# VM Variables
vm_disk_size="30GiB"
vm_cpu=2
vm_memory="4GiB"

# UBuntu Variables
ubuntu_version=24.04

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

case "$vm" in
    ubuntu)
        vm_name="ubuntu-dotfiles-vm"
        vm_image=ubuntu/${ubuntu_version}/desktop
        init_timeout=30
    ;;

    arch)
        echo "$vm not supported yet"
        exit 0
    ;;

    *)
        echo "$vm not supported"
        exit 0
    ;;
esac

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
    incus exec "$vm_name" -- apt remove --autoremove gnome-initial-setup -y
    incus exec "$vm_name" -- systemctl enable ssh
    incus exec "$vm_name" -- systemctl start ssh
    incus exec "$vm_name" -- mkdir ~/home/ubuntu/dotfiles
    incus exec "$vm_name" -- chown -R ubuntu:ubuntu ~/home/ubuntu/dotfiles
    incus exec "$vm_name" -- passwd ubuntu

    vm_ip=$(incus list "$vm_name" -f json | jq -r '.[].state.network.enp5s0.addresses[0].address')
    rsync -avz . "ubuntu@${vm_ip}:dotfiles/"

    incus exec "$vm_name" -- shutdown -r now
    print_spin "Reinitializing the VM..."

    incus snapshot create "$vm_name" snap-init

    # print_info "Initializing the VM..."
    incus console "$vm_name" --type=vga
fi
