LANGUAGE = "en"

DEFAULTKEY_CURSOR = "LMENU"
RANGE = 1.5

CARWASH_INTERVAL = 2000 -- 2s

function GetAspectRatio()
    local x, y = GetScreenResolution()
    return x/y
end

ENTITY_SPRITE = {
    DICT = "rpg_meter_track",
    NAME = "rpg_meter_track_9",
    WIDTH = 0.02,
    HEIGHT = 0.02*GetAspectRatio(false),
    ROT = 45.0,
    COLOR_R = 216,
    COLOR_G = 13,
    COLOR_B = 13,
    COLOR_A = 170
}

ENTITY_SPRITE_HOVER = {
    DICT = "rpg_meter",
    NAME = "rpg_meter_99",
    WIDTH = 0.02,
    HEIGHT = 0.02*GetAspectRatio(false),
    ROT = 45.0,
    COLOR_R = 216,
    COLOR_G = 13,
    COLOR_B = 13,
    COLOR_A = 255
}