fx_version 'cerulean'
game 'gta5'

author 'JericoFX'
description 'Ruler with ox_lib'
version '1.0.0'

lua54 'yes'

shared_script "@ox_lib/init.lua"

client_script 'client/client.lua'

dependencies {
    'ox_lib'
}