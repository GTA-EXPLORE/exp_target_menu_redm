fx_version "adamant"
game "rdr3"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
lua54 'yes'

author 'EXPLORE, MilyonJames'
description 'https://www.gta-explore.com'

ui_page "client/ui/index.html"

client_scripts {
  "locales/*.lua",
  "config.lua",
  "client/*",
  "client/modules/*"
}

server_scripts {
  "server/modules/*"
}

files {
  "client/ui/**/*"
}

escrow_ignore {
    "config.lua",
    "locales/*"
}