fx_version 'cerulean'
game 'gta5'

description 'Blue Sky Inventory'
name 'Blue Sky: [bs_inventory]'
author 'Scorz'
version '1.0.0'

lua54 'yes'

ui_page 'ui/build/index.html'

client_script "client/**/*"
server_script "server/**/*"
shared_script "shared/sh_*"

files {
  'ui/build/index.html',
  'ui/build/**/*'
}
