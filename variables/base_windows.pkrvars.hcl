# General variables
role        = "base"
os_password = "Hashi123!"
owner       = "Grant Orchard"

# vCenter credentials
# Use environment variables or pass with build command

# vCenter details

vcenter_sslconnection = true
vcenter_datacenter = "Datacenter"
vcenter_cluster = "cluster"
vcenter_datastore = "vsanDatastore"
vcenter_folder = "templates"

# VM Hardware Configuration
vm_os_type = "windows9Server64Guest"
vm_firmware = "efi"
vm_hardware_version = 17
vm_cpu_sockets = 2
vm_cpu_cores = 1
vm_ram = 4096
vm_nic_type = "vmxnet3"
vm_network = "seg-general"
vm_disk_controller = ["pvscsi"]
vm_disk_size = 61440
vm_disk_thin = true
config_parameters = {
        "devices.hotplug" = "FALSE",
        "guestInfo.svga.wddm.modeset" = "FALSE",
        "guestInfo.svga.wddm.modesetCCD" = "FALSE",
        "guestInfo.svga.wddm.modesetLegacySingle" = "FALSE",
        "guestInfo.svga.wddm.modesetLegacyMulti" = "FALSE"
}

# Removable Media Configuration
vcenter_iso_datastore = "vsanDatastore"
os_iso_path = "ISO"
os_iso_file = "en-us_windows_server_2022_updated_oct_2022_x64_dvd_c5b651c9.iso"
vmtools_iso_path = "ISO"
vmtools_iso_file = "VMware-Tools-windows-12.3.5-22544099.iso"
vm_cdrom_remove = true

# Build Settings
vm_convert_template = true
winrm_username = "Administrator"
# Use environment variables or pass with build command
winrm_password = "VMware1!"

# Provisioner Settings
powershell_scripts = [
    "builds/windows/scripts/config-os.ps1"
]
