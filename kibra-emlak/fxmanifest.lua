fx_version "adamant"

game "gta5"

description "Kibra-V2 - kibra#9999"

client_script {
    "client/client.lua",
    "config.lua"
}

server_script {
    '@mysql-async/lib/MySQL.lua',
    "server/server.lua",
    "config.lua"
}