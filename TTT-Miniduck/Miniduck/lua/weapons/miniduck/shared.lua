if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "crossbow"

if CLIENT then
   SWEP.PrintName = "Miniduck"
   SWEP.Slot = 6
   SWEP.Icon = "VGUI/ttt/icon_m249"
   SWEP.ViewModelFlip = false
end

-- Convert to normal TTT --
SWEP.AmmoEnt = "item_ammo_smg1_ttt"
SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.InLoadoutFor = nil
SWEP.LimitedStock = false
SWEP.EquipMenuData = {
        type = "Weapon",
        desc = "Minigun but DUCK!"
};
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.NoSights = true
---------------------------

SWEP.Base = "weapon_tttbase"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_EQUIP1
SWEP.WeaponID = AMMO_M249


SWEP.Primary.Damage = 16
SWEP.Primary.Delay = 0.08
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 500
SWEP.Primary.ClipMax = 500
SWEP.Primary.DefaultClip = 500
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "AirboatGun"
SWEP.AutoSpawnable = false
SWEP.Primary.Recoil = 0.6
SWEP.Primary.Sound = Sound("weapons/deathmachine/death-1.wav")

SWEP.AutoSpawnable = false

SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 80
SWEP.ViewModel = "models/weapons/v_deat_m249para.mdl"
SWEP.WorldModel = "models/weapons/w_blopsminigun.mdl"

SWEP.HeadshotMultiplier = 5

SWEP.IronSightsPos = Vector(-5.96, -5.119, 2.349)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.SightsPos = Vector(0, 0, 0)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(0, 1.496, 4.645)
SWEP.RunSightsAng = Vector(-23.425, 0, 0)
SWEP.Offset = {
        Pos = {
                Up = 2,
                Right = 32,
                Forward = 0.0,
        },
        Ang = {
                Up = -10,
                Right = 0,
                Forward = 270,
        }
}

function SWEP:DrawWorldModel( )
        local hand, offset, rotate
        local pl = self:GetOwner()
        if IsValid( pl ) then
                        local boneIndex = pl:LookupBone( "ValveBiped.Bip01_R_Hand" )
                        if boneIndex then
                                local pos, ang = pl:GetBonePosition( boneIndex )
                                pos = pos + ang:Forward() * self.Offset.Pos.Forward + ang:Right() * self.Offset.Pos.Right + ang:Up() * self.Offset.Pos.Up

                                ang:RotateAroundAxis( ang:Up(), self.Offset.Ang.Up)
                                ang:RotateAroundAxis( ang:Right(), self.Offset.Ang.Right )
                                ang:RotateAroundAxis( ang:Forward(),  self.Offset.Ang.Forward )

                                self:SetRenderOrigin( pos )
                                self:SetRenderAngles( ang )
                                self:DrawModel()
                        end
        else
                self:SetRenderOrigin( nil )
                self:SetRenderAngles( nil )
                self:DrawModel()
        end
end