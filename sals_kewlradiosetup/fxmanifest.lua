-- fxmanifest.lua

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'sals_kewlradiosetup by C. Salvatore'

author 'C. Salvatore'
version '1.0.0'

client_scripts {
    'config.lua',
    'client.lua',
}

server_scripts {
    'config.lua',
    'server.lua',
}

dependencies {
    'qb-core',
    'qb-menu', -- Ensure you have qb-menu or replace with your preferred menu resource
}
