LANGUAGE = "en"

KEY_CURSOR = 0x80F28E95 -- L (INPUT_PLAYER_MENU). See https://github.com/femga/rdr3_discoveries/tree/master/Controls
RANGE = 1.5

function GetAspectRatio()   -- DO NOT EDIT
    local x, y = GetScreenResolution()
    return x/y
end

ENTITY_SPRITE = {
    DICT = "rpg_meter_track",
    NAME = "rpg_meter_track_9",
    WIDTH = 0.02,
    HEIGHT = 0.02*GetAspectRatio(),
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
    HEIGHT = 0.02*GetAspectRatio(),
    ROT = 45.0,
    COLOR_R = 216,
    COLOR_G = 13,
    COLOR_B = 13,
    COLOR_A = 255
}