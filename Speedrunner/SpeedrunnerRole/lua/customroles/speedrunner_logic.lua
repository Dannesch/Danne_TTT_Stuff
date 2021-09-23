if CLIENT then return end
--print("[SpeedrunnerRole]: Code has been started!")
hook.Add("TTTBeginRound", "SpeedrunnerRoundStart", function()
    --print("[SpeedrunnerRole]: The Round has begun!")
	local speed_time = GetConVar("ttt_speedrunner_time")
    for i, v in ipairs( player.GetAll() ) do
        --print("[SpeedrunnerRole]: Player " .. v:Nick())
        if v:IsSpeedrunner() then
            --print("[SpeedrunnerRole]: " .. v:Nick() .. " is a speedrunner!")
            timer.Create( "SpeedrunnerKillNStuff", speed_time:GetInt(), 1, function() 
                if v:IsSpeedrunner() then
                    --print("[SpeedrunnerRole]: Kill initialized")
                    if v:Alive() then
                        v:Kill()
                        --print("[SpeedrunnerRole]: Player has been killed!")
                    end 
                end
            end )
        end
    end
end)
hook.Add("TTTEndRound", "SpeedrunnerRoundEnd", function()
    --print("[SpeedrunnerRole]: Round has ended!")
    timer.Remove("SpeedrunnerKillNStuff")
    --print("[SpeedrunnerRole]: Timer has been removed!")
end)
hook.Add("PlayerDeath", "SpeedrunnerOnDeath", function(victim)
    if GetRoundState() ~= ROUND_ACTIVE then return end
    --print("[SpeedrunnerRole]: " .. victim:Nick() .. " has died")
    if victim:IsSpeedrunner() then
        --print("[SpeedrunnerRole]: " .. victim:Nick() .. " is a speedrunner!")
        timer.Pause("SpeedrunnerKillNStuff")
        --print("[SpeedrunnerRole]: Timer has been paused")
    end
end)
hook.Add("PlayerSpawn", "SpeedrunnerOnSpawn", function(ply)
    if GetRoundState() ~= ROUND_ACTIVE then return end
    --print("[SpeedrunnerRole]: " .. ply:Nick() .. " has spawned")
    if not ply:IsSpeedrunner() then return end
    --print("[SpeedrunnerRole]: " .. ply:Nick() .. " is a speedrunner!")
    if timer.Exists("SpeedrunnerKillNStuff") then
        --print("[SpeedrunnerRole]: Timer exists")
        timer.UnPause("SpeedrunnerKillNStuff")
        --print("[SpeedrunnerRole]: Timer is UnPaused")
    else
        ply:Kill()
        --print("[SpeedrunnerRole]: " .. ply:Nick() .. " was killed")
    end
end)