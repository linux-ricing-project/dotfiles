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
        init_timeout=20
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

    incus snapshot restore "$vm_name" snap-init
    print_spin "Restoring initial Snapshot..."

    print_info "Updating Code inside VM"
    vm_ip=$(incus list "$vm_name" -f json | jq -r '.[].state.network.enp5s0.addresses[0].address')
    rsync --delete -avz . "ubuntu@${vm_ip}:dotfiles/"

    print_info "Initializing VM"
    incus console "$vm_name" --type=vga
else
    print_info "VM $vm_name: not found"
    exit 0
fi

