fx_version 'cerulean'
game 'gta5'

author 'Scorz'
description 'Bluesky Inventory.'
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
