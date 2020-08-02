fx_version 'bodacious'
games { 'gta5' }

description 'Blue Sky Limb Damage'

version '2.0.0'

client_scripts {
	-- Config Files
	'strings.lua',
	'config.lua',
	'definitions.lua',
	'functional_config.lua',
	'client/*.lua',

	-- Wound Files
	'client/wound/*.lua',
}

server_scripts {
	'strings.lua',
	'config.lua',
	'definitions.lua',
	'server/*.lua',
}