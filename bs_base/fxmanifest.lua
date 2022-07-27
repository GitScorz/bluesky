fx_version 'cerulean'
game 'gta5'

client_scripts {
    '@bs_pwnzor/token.lua',
    'sh_init.lua',
    'cl_init.lua',
    'core/sh_*.lua',
    'core/cl_*.lua',
    'cl_config.lua',
    'components/sh_*.lua',
    'components/cl_*.lua',
}

server_scripts {
    '@bs_pwnzor/token.lua',
    'sh_init.lua',
    'sv_init.lua',
    'sv_config.lua',
    'core/sv_database.js',
    'core/sh_*.lua',
    'core/sv_*.lua',
    'components/sh_*.lua',
    'components/sv_*.lua',
}

files {
    'weapons.meta',
    'weaponanimations.meta',
}

dependencies {
    'yarn'
}

data_file 'WEAPONINFO_FILE_PATCH' 'weapons.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'weaponanimations.meta'