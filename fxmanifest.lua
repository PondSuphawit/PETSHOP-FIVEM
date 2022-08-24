fx_version 'cerulean'
games 'gta5'

author 'pond.suphawit'
description 'Example resource free'
version '1.0.0'

-- What to run
client_scripts { 
	'Config.lua', 
	'Client.lua' 
} 
 
server_scripts { 
    'Config.lua', 
	'Utils.lua', 
	'@mysql-async/lib/MySQL.lua',
	'Source/Server.lua' 
} 
 
files { 
	'Interface/ui.html',
	'Interface/script.js',
	'Interface/images/*.png',
	'Interface/css/fonts/*.ttf',
	'Interface/css/*.css',
} 