fx_version 'bodacious'
games { 'gta5' }

name 'Blue Sky Progress Bar'
author 'Alzar - https://github.com/Alzar'
version 'v1.0.0'

ui_page('html/index.html') 

client_scripts {
    'client/functions.lua',
    'client/events.lua',
}

files {
    'html/index.html',
    'html/css/style.css',
    'html/js/script.js',

    'html/css/bootstrap.min.css',
    'html/js/jquery.min.js',
}