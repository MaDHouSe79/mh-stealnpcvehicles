--[[ ===================================================== ]]--
--[[        MH Steel Npc Vehicles Script by MaDHouSe       ]]--
--[[ ===================================================== ]]--

fx_version 'cerulean'
games { 'gta5' }

author 'MaDHouSe'
description 'MH NPC Car Stealing and Selling'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua', -- change nl to your language
    'config.lua',
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

dependencies {
    'oxmysql',
    'qb-core',
}

lua54 'yes'
