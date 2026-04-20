fx_version 'cerulean'
game 'gta5'

author 'LCKY Scripts'
description 'Standalone Auction System - Immersive in-game auction experience'
version '1.0.0'

lua54 'yes'

dependencies {
    '/server:5181',
    'ox_lib'
}

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
    'shared/utils.lua'
}

client_scripts {
    'client/main.lua',
    'client/zone.lua',
    'client/ui.lua',
    'client/animation.lua',
    'client/keybinds.lua'
}

server_scripts {
    'server/main.lua',
    'server/auction.lua'
}