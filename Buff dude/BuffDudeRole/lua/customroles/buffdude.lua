local ROLE = {}

ROLE.nameraw = "buffdude"
ROLE.name = "BuffDude"
ROLE.nameplural = "Buff Dudes"
ROLE.nameext = "a Buff Dude"
ROLE.nameshort = "bd"

ROLE.desc = [[You are {role}! 
  
The Buff Dude is an independent role who only gets a crowbar, additional healt and does more damage. 
]]

ROLE.team = ROLE_TEAM_INDEPENDENT

ROLE.shop = nil
ROLE.loadout = {}

ROLE.startingcredits = nil

ROLE.startinghealth = 150
ROLE.maxhealth = 150

ROLE.translations = {}

if SERVER then
    CreateConVar("ttt_buffdude_damage", "40", FCVAR_NONE, "How much damage a Buff Dude does")
end
ROLE.convars = {}
table.insert(ROLE.convars, {
    cvar = "ttt_buffdude_damage",
    type = ROLE_CONVAR_TYPE_NUM,
    decimal = 0
})

RegisterRole(ROLE)

hook.Add("Initialize", "bd_Initialize", function()
    WIN_BUFFDUDE = GenerateNewWinID and GenerateNewWinID() or 291
    if CLIENT then
        LANG.AddToLanguage("english", "win_buffdude", "The {role} has beat everyone up!")
    end
end)

if SERVER then
    hook.Add("TTTBeginRound", "bd_roundbegin", function()
        for _, ply in ipairs(player.GetAll()) do
            if (ply:IsBuffDude()) then
                ply:StripAll()
                ply:Give("weapon_zm_improvised")
                ply:Give("weapon_ttt_unarmed")
                ply:Give("weapon_zm_carry")
            end
        end
    end)
    hook.Add("PlayerCanPickupWeapon", "bd_nopickup", function( ply, weapon )
        if(ply:IsBuffDude()) then
            return false
        end
    end )
    hook.Add("ScalePlayerDamage", "bd_damagechanger", function(ply, hitgroup, dmginfo)
        if(ply:IsBuffDude()) then
            dmginfo:SetDamage(GetConVar("ttt_buffdude_damage"):GetInt())
        end 
    end)
    hook.Add("TTTCheckForWin", "bd_chckforwin", function()
        if not GetConVar("ttt_debug_preventwin"):GetInt() then
            local nonBDAlive = false
            local hasBD = false
            for _, ply in ipairs(player.GetAll()) do
                if ply:IsBuffDude() and ply:Alive() then
                    hasBD = true
                end
        
                if not ply:IsSpec() and ply:Alive() and not ply:IsBuffDude() and not ply:IsJesterTeam() then
                    nonBDAlive = true
                end
            end
        
            if nonBDAlive and hasBD then
                return WIN_NONE
            elseif hasBD then
                return WIN_BUFFDUDE
            end
        end
    end)
    hook.Add("TTTPrintResultMessage", "bd_PrintResultMessage", function(type)
        if type == WIN_BUFFDUDE then
            LANG.Msg("win_buffdude", { role = ROLE_STRINGS[ROLE_BUFFDUDE] })
            ServerLog("Result: " .. ROLE_STRINGS[ROLE_BUFFDUDE] .. " wins.\n")
            return true
        end
    end)
    AddCSLuaFile()
else
    hook.Add("PreDrawHalos", "bd_Halos", function()
        local tohalo = {}
        local client = LocalPlayer()
        if client:IsBuffDude() then
            for _,v in ipairs(player.GetAll()) do
                if v:IsJesterTeam() and v:Alive() then
                    table.insert(tohalo, v)
                end
            end
            halo.Add(tohalo, ROLE_COLORS[ROLE_JESTER], 1, 1, 1, true, true)
        end
    end)
    hook.Add("TTTScoringWinTitle", "bd_ScoringWinTitle", function(wintype, wintitles, title, secondaryWinRole)
        if wintype == WIN_BUFFDUDE then
            return { txt = "hilite_win_role_singular", params = { role = ROLE_STRINGS[ROLE_BUFFDUDE] }, c = ROLE_COLORS[ROLE_BUFFDUDE] }
        end
    end)
end