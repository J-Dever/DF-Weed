fx_version 'cerulean'
game 'gta5'

author 'Development Factory'
description 'Weed Script By DF'
version '1.0.0'


client_scripts {
    'shared/config.lua',
    'client/actions.lua',
    'client/visuals.lua',
    'client/targets.lua',
    'client/main.lua'
}

server_scripts {
    'shared/config.lua',
    '@qb-core/shared/locale.lua',
    'server/main.lua'
}

shared_script {
    'shared/config.lua',
    'shared/shared.lua',
}

dependencies {
    'qb-core',
    'qb-target'
}