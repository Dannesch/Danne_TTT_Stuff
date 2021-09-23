if Server then
    hook.Add("TTTBeginRound", "SpeedrunnerRoundStart", function()
        for i, v in ipairs( player.GetAll() ) do
            if v:IsSpeedrunner() then
                timer.Create( "SpeedrunnerKillNStuff", GetConVar("ttt_speedrunner_time"):GetInt(), 1, function() 
                    if v:Alive() then
                        v:Kill()
                    end 
                end )
            end
        end
    end)
    hook.Add("TTTEndRound", "SpeedrunnerRoundEnd", function()
        timer.Remove("SpeedrunnerKillNStuff")
    end)
    hook.Add("PlayerDeath", "SpeedrunnerOnDeath", function(victim)
        if victim:IsSpeedrunner() then
            timer.Pause("SpeedrunnerKillNStuff")
        end
    end)
    hook.Add("PlayerSpawn", "SpeedrunnerOnSpawn", function(ply)
        if timer.Exists("SpeedrunnerKillNStuff") then
            if ply:IsSpeedrunner() then
                timer.UnPause("SpeedrunnerKillNStuff")
                if timer.RepsLeft("SpeedrunnerKillNStuff") == 0 then
                    ply:Kill()
                end
            end
        end
    end)
end