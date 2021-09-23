SWEP.PrintName = "Stop Bullets" 
SWEP.Author = "ALEX (Adaptation to TTT by Danne_sch)"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom	= false

SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel	= "models/weapons/c_arms.mdl"

StoppingBullets = false
SWEP.ArmAnimation = 0

-- Convert to TTT
SWEP.Base = "weapon_tttbase"
SWEP.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE }
SWEP.Kind = WEAPON_EQUIP1
SWEP.LimitedStock = true
SWEP.InLoadoutFor = nil
SWEP.EquipMenuData = {
	type = "Weapon",
	desc = "It's like the hands from the matrix you know."
}
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.NoSights = true
SWEP.AutoSpawnable = false

OWNER = Entity(0)

--sound.Add( {
--	name = "bullet_catch",
--	channel = CHAN_WEAPON,
--	volume = 0.8,
--	level = 80,
--	sound = "weapon/bullet_catch.wav"
--} )

function bool_to_number(value)
  return value and 1 or 0
end

function SWEP:Initialize()
	self:SetHoldType( "normal" )

	if( !CLIENT ) then return end
	if( self.WepViewModel == nil ) then

		self.WepViewModel = ClientsideModel( "models/weapons/c_medkit.mdl" )
		self.WepViewModel:SetNoDraw( true )

	end
end

function SWEP:Deploy()
	OWNER = self.Owner
	self:SetHoldType( "normal" )

	if( !CLIENT ) then return end
	if( self.WepViewModel == nil or self.WepViewModel == ClientsideModel( "models/weapons/c_medkit.mdl" ) ) then
		self.WepViewModel = ClientsideModel( self.Owner:GetHands():GetModel() )
		self.WepViewModel:SetNoDraw( true )
	end

	if( self.WepViewModel:GetModel() != self.Owner:GetHands():GetModel() ) then
		self.WepViewModel:SetModel( self.Owner:GetHands():GetModel() ) 
	end

end

function SWEP:OnDrop()
	self:SetHoldType( "normal" )
	if( !CLIENT ) then return end
	self.WepViewModel = ClientsideModel( "models/weapons/c_medkit.mdl" )
	self.WepViewModel:SetNoDraw( true )
end

function SWEP:OnDrop()
	StoppingBullets = false
end

function PrintBones( entity )
    for i = 0, entity:GetBoneCount() - 1 do
        print( i, entity:GetBoneName( i ) )
    end
end


function SWEP:Think()

	StoppingBullets = self.Owner:KeyDown( IN_ATTACK ) 

	if( StoppingBullets ) then
		self:SetHoldType( "pistol" )
		self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" ) ,Angle(60,0,-90));

		for k, v in ipairs( ents.FindByClass( "npc_manhack" ) ) do
			PhysObj = v:GetPhysicsObject()
			if( IsValid(PhysObj) and v:GetPos():Distance( self.Owner:EyePos() + Vector(0,0,-20) + self.Owner:EyeAngles():Forward()*10 ) < 100 ) then
				PhysObj:SetVelocity( PhysObj:GetVelocity()*0.1 + ( v:GetPos() - self.Owner:EyePos() )*20 )
			end
		end
	else
		self:SetHoldType( "normal" )
		self.Owner:ManipulateBoneAngles( self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" ) ,Angle(0,0,0));
	end
end

function SpawnBullet( pos , src )
	--self.Owner:EmitSound( "bullet_catch" )
	local bullet = ents.Create( "prop_physics" )
	bullet:SetModel( "models/props_phx2/garbage_metalcan001a.mdl" )
	bullet:SetAngles( (src-pos):Angle() + Angle(90,0,0) )
	bullet:SetColor( Color( 200, 200, 70, 255 ) )
	bullet:SetMaterial( "debug/env_cubemap_model.vmt" )
	bullet:SetModelScale( 0.3, 0 )
	bullet:SetPos( pos )
	bullet:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	bullet:Spawn()
	bullet:GetPhysicsObject():EnableGravity( false )

	timer.Simple( 0.4, function() 
		bullet:GetPhysicsObject():EnableGravity( true )
	end )

	timer.Simple( 2, function() 
		bullet:Remove()
	end )

end

hook.Add( "EntityFireBullets", "StopBullets", function( entity, data )
	
	if( !StoppingBullets ) then return true end

	TraceToEnd = util.QuickTrace( data.Src + data.Dir*100, data.Dir*100000000 )

	for i=0,100 do
		CurPoint = LerpVector(i/100, TraceToEnd.StartPos, TraceToEnd.HitPos )

		if( ( OWNER:EyePos() + Vector(0,0,-20) + OWNER:EyeAngles():Forward()*40 ):Distance( CurPoint ) < 50 ) then
			SpawnBullet(CurPoint , TraceToEnd.StartPos)

			data.Damage = 0
			data.Force = 1000
			data.Distance = TraceToEnd.StartPos:Distance( CurPoint )

			return true
		end
	end
end )

function SWEP:PostDrawViewModel( vm, weapon, ply )


	self.ArmAnimation = Lerp( 5*FrameTime(), self.ArmAnimation, bool_to_number(StoppingBullets) )


	self.WepViewModel:SetPos(vm:GetPos() + vm:GetAngles():Up()*-69 + vm:GetAngles():Right()*6 + vm:GetAngles():Forward()*(-20+self.ArmAnimation*25) )
	self.WepViewModel:SetAngles(vm:GetAngles() )

	self.WepViewModel:ManipulateBoneAngles(self.WepViewModel:LookupBone("ValveBiped.Bip01_L_UpperArm"),Angle(50,30,0));
	self.WepViewModel:ManipulateBoneAngles( self.WepViewModel:LookupBone("ValveBiped.Bip01_R_UpperArm"),Angle(0,-70-self.ArmAnimation*40 + math.cos(CurTime()*2),-30 + math.sin(CurTime()*2) +  self.ArmAnimation*-30));
	self.WepViewModel:ManipulateBoneAngles( self.WepViewModel:LookupBone("ValveBiped.Bip01_R_Hand") ,Angle(self.ArmAnimation*10 +  math.sin(CurTime()*4),-20 + self.ArmAnimation*50 + math.cos(CurTime()*5),0));

	ImportantFinger = self.WepViewModel:LookupBone("ValveBiped.Bip01_R_Finger4")
	for i=0,10 do
		self.WepViewModel:ManipulateBoneAngles(ImportantFinger+i,Angle(0,-50 + self.ArmAnimation*75 + math.cos(CurTime()*5 + i*20)*0.3,0));
	end


	self.WepViewModel:SetupBones()
	self.WepViewModel:DrawModel()

end

if CLIENT then
	function SWEP:DrawWorldModel()

	end
end

