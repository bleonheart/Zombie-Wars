AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

util.PrecacheModel ("models/items/boxsrounds.mdl")

function ENT:Initialize()
	self.Entity:SetModel("models/items/boxsrounds.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self.Entity:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self.Entity:PhysWake()
	
	self.Entity:SetNetVar("NormalAmmo", "20")
	if not self.Entity:GetNetVar("Ammo") then
		self.Entity:SetNetVar("Ammo", "20")
	end
end

function ENT:Use( activator, caller )
	if ( activator:IsPlayer() ) then
		local sound = Sound("items/ammo_pickup.wav")
		self.Entity:EmitSound( sound )
		
		local ammo
		if self.Entity:GetNetVar("Ammo") then
			ammo = tonumber(self.Entity:GetNetVar("Ammo"))
		else
			self.Entity:SetNetVar("Ammo", "20")
			ammo = 20
		end
	
		self.Entity:Remove()
		
		activator:GiveAmmo( ammo, "pistol")
 
	end
 
end

function ENT:PostEntityPaste(pl, Ent, CreatedEntities)
	self:Remove()
end
