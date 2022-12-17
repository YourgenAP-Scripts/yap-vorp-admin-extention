# yap-vorp-admin-extention
Small extension for VORP-Admin

The Script is not supported. Feel free to edit it and share under the GNU Public License v3.

## Installation
1) Download all the files and add to your resources folder
2) Run SQL-File provided in the repository
3) Add to your vorp_perms.cfg `add_ace resource.yap-vorp-admin-extension command.add_principal allow`
4) Add to resources.cfg `ensure yap-vorp-admin-extension` below vorp_admin

## Usage
This script is designed to make it easier adding of admins and moderators. You do not need anymore to edit vorp_perms.cfg and to restart the server to give or remove admin or moderator rights.

The usage is simple
```
add_perm <user_id> <role name>
remove_perm <user_id> <role name>

Where:
user_id = static id from whitelist table available to see in VORP_Admin
role name = "admin", "moderator", etc as prescribed in add_ace in vorp_perms.cfg
```

## License and further use
This script is under GNU General Public License version 3. You are free to use and edit it, as well to use it partly or fully in your code independant whether it is payware or freeware. However, you must provide all the users the possibiility to access the source code (**this** script) and to mention me as the author of the source code used in your script in references.
