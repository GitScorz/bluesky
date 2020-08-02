fx_version 'bodacious'
games { 'gta5' }

client_scripts {
    'cl_config.lua',
    'client/*.lua'
}

server_scripts {
    'sv_config.lua',
    'server/*.lua',
}

file 'token.lua'

exports {
    'SetupClient'
}

server_exports {
    'SetupServer'
}