
SWEP.Author		= "LostInTheWired"
SWEP.Contact		= "LostInTheWired@gmail.com"
SWEP.Purpose		= "Flaregun.  Send messages!"
SWEP.Instructions	= "Right click for iron sights.\nWALK-Right click to hold passive."

SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_pistol.mdl"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 	= true
SWEP.DrawCrosshair 		= false

SWEP.Base 				= "weapon_base"

SWEP.MuzzleAttachment		= "muzzle" -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment	= "1" -- Should be "2" for CSS models or "1" for hl2 models

SWEP.Primary.Sound 			= Sound("weapons/flaregun/fire.wav")
SWEP.Primary.Recoil 		= 1.2
SWEP.Primary.Damage 		= 16
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 			= 0.017
SWEP.Primary.ClipSize 		= -1
SWEP.Primary.Delay 			= 1
SWEP.Primary.DefaultClip 	= -1
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 			= "none"

SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.HoldType				= "pistol"
SWEP.ViewModelFlip			= false

SWEP.IronSightsPos = Vector(-5.907, -7.008, 4.099)
SWEP.IronSightsAng = Vector(0, -1.379, 1.378)

function SWEP:Initialize()
	util.PrecacheModel( self.ViewModel )
	util.PrecacheModel( self.WorldModel )
	util.PrecacheSound(self.Primary.Sound)
	util.PrecacheSound("weapons/pistol/pistol_reload1.wav")
    self:SetWeaponHoldType(self.HoldType)
end

function SWEP:SetupDataTables()
	self:DTVar("Bool", 0, "Holsted")
	self:DTVar("Bool", 1, "Ironsights")
end 

function SWEP:Equip()
	-- self.Weapon:SetNWBool("IronSights", false)
	-- self.Weapon:SetNWBool("IsPassive", false)
	self.Weapon:SetDTBool(0, false)
	self.Weapon:SetDTBool(1, false)
end

function SWEP:PrimaryAttack()

	if self.Owner:WaterLevel() > 2 then return end
	if self.Weapon:GetDTBool(0) or self.Owner:KeyDown( IN_SPEED ) then return end
	
	self.Weapon:EmitSound(self.Primary.Sound)
	--self:TakePrimaryAmmo(self.Primary.NumShots)
	
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
	local handlingSkill = self.Owner:GetSkill("Weapon Handling")
	
	if self.Weapon:GetDTBool(1) then
		self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil - (0.1 * handlingSkill)), math.Rand(-1,1) * ((self.Primary.Recoil - (0.1 * handlingSkill)) / 2), 0))
		if (SERVER) then
			local flare = ents.Create("ent_pnrp_flare")
				flare:SetOwner(self.Owner)
				
				flare:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector()))
				
				flare:SetAngles(self.Owner:GetAngles())
				flare:Spawn()
				flare:Activate()

			local phys = flare:GetPhysicsObject()
			phys:ApplyForceCenter(self.Owner:GetAimVector() * 10000)
		end
	else
		self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (self.Primary.Recoil - (0.1 * handlingSkill)), math.Rand(-1,1) * (self.Primary.Recoil - (0.1 * handlingSkill)), 0))
		if (SERVER) then
			local flare = ents.Create("ent_pnrp_flare")
				flare:SetOwner(self.Owner)
				
				flare:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector()))
				
				flare:SetAngles(self.Owner:GetAngles())
				flare:Spawn()
				flare:Activate()

			local phys = flare:GetPhysicsObject()
			phys:ApplyForceCenter(self.Owner:GetAimVector() * 10000)
		end
	end
	
	if (SERVER) then self.Owner:StripWeapon("weapon_pnrp_flaregun") end
	
end

function SWEP:SecondaryAttack()
	if self.Owner:KeyDown( IN_WALK ) then
		-- local savedBool = (not self.Weapon:GetNWBool("IsPassive", false))
		local savedBool = (not self.Weapon:GetDTBool(0))
		
		if (SERVER) then
			self.Weapon:SetDTBool(0, (not self.Weapon:GetDTBool(0)))
			self.Owner:EmitSound("npc/combine_soldier/gear4.wav")
		end
		
		if savedBool then
			self:SetWeaponHoldType("normal")
			self.Owner:SetFOV( 0, 0.15 )
			self.Weapon:SetDTBool(1, false)
		else
			self:SetWeaponHoldType(self.HoldType)
		end
	else
		--if self.Weapon:GetNWBool("IsPassive", false) then return end
		if self.Weapon:GetDTBool(0) then return end
		-- local savedBool = (not self.Weapon:GetNWBool("IronSights", false))
		local savedBool = (not self.Weapon:GetDTBool(1))
		-- self.Weapon:SetNWBool("IronSights", (not self.Weapon:GetNWBool("IronSights", false))) 
		self.Weapon:SetDTBool(1, (not self.Weapon:GetDTBool(1)))
		
		if savedBool then
			self.Owner:SetFOV( 65, 0.15 )
		else
			self.Owner:SetFOV( 0, 0.15 )
		end
	end
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
end

function SWEP:Reload()
	-- if self.Weapon:Clip1() < self.Primary.ClipSize then
		-- self.Weapon:SetDTBool(1, false)
		-- self.Owner:SetFOV( 0, 0.15 )
		
		-- -- self.Weapon:SetNextPrimaryFire(CurTime() + 1.5)
		-- -- self.Weapon:SetNextSecondaryFire(CurTime() + 1.5)
		
		-- self.Weapon:SetWeaponHoldType(self.HoldType)
		-- self.Weapon:DefaultReload(ACT_VM_RELOAD) 
		-- self.Weapon:EmitSound("weapons/pistol/pistol_reload1.wav")
		
	-- end
end

function SWEP:Deploy()

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	-- self.Owner:SetNWBool("IronSights", false)
	-- self.Weapon:SetNWBool("IsPassive", false)
	
	self.Weapon:SetDTBool(0, false)
	self.Weapon:SetDTBool(1, false)

	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	return true
end

function SWEP:Think()
	-- if self.Weapon:GetNWBool("IsPassive", false) or self.Owner:KeyDown( IN_SPEED ) then
		-- self:SetWeaponHoldType("normal")
	-- else
		-- self:SetWeaponHoldType(self.HoldType)
	-- end
end

-- Ironsights code, based on CSS Realistic
local IRONSIGHT_TIME = 0.15

function SWEP:GetViewModelPosition(pos, ang)
	
	if self.Weapon:GetDTBool(0) or self.Owner:KeyDown( IN_SPEED ) then
		ang = ang * 1
		ang:RotateAroundAxis(ang:Right(), 		-37.2258)
		ang:RotateAroundAxis(ang:Up(), 		1.7237)
		ang:RotateAroundAxis(ang:Forward(), 	0)
		
		local Offset = Vector(1.6428, 0, 6.2286)
		local Right 	= ang:Right()
		local Up 		= ang:Up()
		local Forward 	= ang:Forward()
		
		pos = pos + Offset.x * Right
		pos = pos + Offset.y * Forward
		pos = pos + Offset.z * Up
		return pos, ang
	end
	
	if (not self.IronSightsPos) then return pos, ang end

	local bIron = self.Weapon:GetDTBool(1)

	if (bIron != self.bLastIron) then
		self.bLastIron = bIron
		self.fIronTime = CurTime()
		
		if (bIron) then
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.1
		else
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end
	end

	local fIronTime = self.fIronTime or 0

	if (not bIron and fIronTime < CurTime() - IRONSIGHT_TIME) then
		return pos, ang
	end

	local Mul = 1.0

	if (fIronTime > CurTime() - IRONSIGHT_TIME) then
		Mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)

		if not bIron then Mul = 1 - Mul end
	end
	
	local Offset	= self.IronSightsPos
	
	if (self.IronSightsAng) then
		ang = ang * 1
		ang:RotateAroundAxis(ang:Right(), 		self.IronSightsAng.x * Mul)
		ang:RotateAroundAxis(ang:Up(), 		self.IronSightsAng.y * Mul)
		ang:RotateAroundAxis(ang:Forward(), 	self.IronSightsAng.z * Mul)
	end

	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
end

function SWEP:ShootEffects()
 
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )	-- View model animation
	self.Owner:MuzzleFlash()				-- Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )		-- 3rd Person Animation
 
end