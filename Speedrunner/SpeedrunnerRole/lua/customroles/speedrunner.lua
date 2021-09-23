local ROLE = {}

ROLE.nameraw = "speedrunner"
ROLE.name = "Speedrunner"
ROLE.nameplural = "Speedrunners"
ROLE.nameext = "a Speedrunner"
ROLE.nameshort = "sr"

ROLE.desc = [[You are {role}! {comrades}

You must kill all {innocents} before your time runs out and you die! (90 seconds by default)

Press {menukey} to receive your equipment!]]

ROLE.team = ROLE_TEAM_TRAITOR

ROLE.shop = {"item_armor", "item_radar", "item_disg"}

ROLE.loadout = {}

ROLE.convars = {
    {
        cvar = "ttt_speedrunner_time",
        type = ROLE_CONVAR_TYPE_NUM,
        decimal = 0
    }
}

RegisterRole(ROLE)

if SERVER then
    CreateConVar("ttt_speedrunner_time", "90", FCVAR_NONE, "The amount of time the speedrunner has till it dies", 0, 240)
    resource.AddFile("materials/vgui/ttt/icon_sr.vmt")
    resource.AddFile("materials/vgui/ttt/sprite_sr.vmt")
    resource.AddSingleFile("materials/vgui/ttt/sprite_sr_noz.vmt")
    resource.AddSingleFile("materials/vgui/ttt/score_sr.png")
    resource.AddSingleFile("materials/vgui/ttt/tab_sr.png")
end