fx_version 'cerulean'
game 'gta5'

description 'Blue Sky Peek'
name 'Blue Sky: [bs_peek]'
author 'Scorz'
version 'v1.0.0'
url 'https://www.blueskyrp.com'

server_scripts {
  'server/sv_*.lua',
}

client_scripts {
  '@PolyZone/client.lua',
  '@PolyZone/BoxZone.lua',
  '@PolyZone/EntityZone.lua',
  '@PolyZone/CircleZone.lua',
  '@PolyZone/ComboZone.lua',
  'client/cl_*.lua',
}

dependencies {
  "PolyZone"
}
