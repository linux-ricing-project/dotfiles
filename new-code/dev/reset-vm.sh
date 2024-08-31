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
    init_timeout=20
else
    echo "$vm not supported yet"
    exit 0
fi

vm_search=$(incus list "$vm_name" -f json | jq -r '.[].name')
if [[ -n "$vm_search" ]];then
    print_info "Restoring Snapshot"

    incus snapshot restore "$vm_name" snap-init

    gum spin --title="Restoring initial Snapshot..." \
            --spinner.foreground="$vm_color" \
            --timeout "${init_timeout}s" -- \
            sleep "$init_timeout"

    print_info "Initializing VM"

    incus console "$vm_name" --type=vga
else
    print_info "VM $vm_name: not found"
    exit 0
fi

