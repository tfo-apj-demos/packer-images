# General variables
role        = "mssql"
owner       = "Grant Orchard"

# VMware variables
template = "base-windows-2022-20231112221243"
cluster   = "cluster"
datastore = "vsanDatastore"
network   = "seg-general"

# Base Install ISO and Script
role_iso_file = "SQLServer2022-x64-ENU-Dev.iso"
powershell_scripts = [
    "builds/windows/scripts/install-sql.ps1"
]