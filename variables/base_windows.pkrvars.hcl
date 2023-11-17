# General variables
role        = "base"
owner       = "Grant Orchard"

# VMware variables
cluster = "cluster"
datastore = "vsanDatastore"
network = "seg-general"

# Base Install ISO and Script
os_iso_file = "en-us_windows_server_2022_updated_oct_2022_x64_dvd_c5b651c9.iso"
vmtools_iso_file = "VMware-Tools-windows-12.3.5-22544099.iso"
powershell_scripts = [
    "builds/windows/scripts/config-os.ps1"
]