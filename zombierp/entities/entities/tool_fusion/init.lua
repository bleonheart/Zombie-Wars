AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')

util.AddNetworkString("loadfusgen_stream")
util.AddNetworkString("unloadfusgen_stream")
util.AddNetworkString("togglefusgen_stream")
util.AddNetworkString("emerfusgen_stream")
util.AddNetworkString("repfusgen_stream")

util.PrecacheModel ("models/props_combine/combine_generator01.mdl")

function ENT:Initialize()	
	self.Entity:SetModel("models/props_combine/combine_generator01.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self.Entity:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetHealth( 200 )
	self.entOwner = "none"
	self.moveActive = true
	self.Entity:PhysWake()
	
	self.Status = false
	self.PowerLevel = 0
	self.FuelLevel = 0
	self.PowerItem = true
	self.PowerGenerator = true
	self.MeltingDown = false
	self.NoReturn = false
	self.entOwner = "none"
	self.toMeltdown = 30
	self.toCrit = 30
	
	self.UnitLeft = 0
	
	self.alarmSound = CreateSound( self, "ambient/alarms/combine_bank_alarm_loop1.wav" )
	self.genSound = CreateSound( self, "ambient/machines/combine_shield_loop3.wav" )
	
	-- This var will store the Entity that controls the power network information.
	self.NetworkContainer = nil
	
	self.LinkedItems = {}
	self.DirectLinks = {}
	
	self.Entity:NextThink(CurTime() + 1.0)
end

function ENT:Use( activator, caller )
	if activator:KeyPressed( IN_USE ) then
		if self.Repairing then
			if self.Repairing == activator then
				self.Repairing = nil
				activator:ChatPrint("You stop repairing the generator.")
				
				activator:SetMoveType(MOVETYPE_WALK)
				net.Start("stopProgressBar")
				net.Send(activator)
				self.Repairing = nil
				if self:IsValid() then 
					timer.Stop(activator:UniqueID().."_repair_"..tostring(self))
				end
			else
				activator:ChatPrint("This generator is currently being repaired.")
			end
		else
			if activator:IsAdmin() and getServerSetting("adminCreateAll") == 1 then
				if activator:Team() ~= TEAM_SCIENCE then
					activator:ChatPrint("Admin overide.")
				end
			else
				if activator:Team() ~= TEAM_SCIENCE then
					activator:ChatPrint("You have a feeling you'd kill yourself if you tried.")
					return
				end
			end
					
			if self.entOwner == "none" then
				self.entOwner = activator:Nick()
			end
			
			local actInv = PNRP.Inventory( activator )
			local availFuel = actInv["fuel_h2"]
						 
			net.Start("fusgen_menu")
				net.WriteDouble(self:Health())
				if self.NetworkContainer then
					net.WriteDouble(self.NetworkContainer.NetPower or self.PowerLevel)
				else
					net.WriteDouble(self.PowerLevel)
				end
				net.WriteDouble(self.FuelLevel)
				net.WriteDouble(self.UnitLeft or 0)
				net.WriteDouble(availFuel or 0)
				net.WriteBit(self.Status)
				net.WriteBit(self.MeltingDown)
				net.WriteDouble(self.toMeltdown or 0)
				net.WriteBit(self.NoReturn)
				net.WriteDouble(self.toCrit or 0)
				net.WriteEntity(self.Entity)
				net.WriteEntity(activator)
			net.Send(activator)
		end
	end
end
util.AddNetworkString("fusgen_menu")

function ENT:OnTakeDamage(dmg)
	self:SetHealth(self:Health() - dmg:GetDamage())
--	if self:Health() < 200 then self.BlockF2 = true end
	if self:Health() <= 0 then --run on death
		self:SetHealth( 0 )
		
		if not self.MeltingDown and self.Status then
			--self:EmitSound( "ambient/alarms/alarm1.wav", 100, 100)
			self.alarmSound:Play()
			self.MeltingDown = true
			
			local effectdata = EffectData()
				effectdata:SetEntity(self)
				effectdata:SetStart(util.LocalToWorld( self, Vector(0,0,-50)))
				effectdata:SetOrigin(util.LocalToWorld(self, Vector(0,0,150)))
				effectdata:SetAttachment( 1 )
			
			effectdata:SetOrigin(util.LocalToWorld(self, Vector(math.random(-50,50),math.random(-50,50),math.random(-25,150) )))
			util.Effect("ToolTracer", effectdata, true, true)
			effectdata:SetOrigin(util.LocalToWorld(self, Vector(math.random(-50,50),math.random(-50,50),math.random(-25,150) )))
			util.Effect("ToolTracer", effectdata, true, true)
			effectdata:SetOrigin(util.LocalToWorld(self, Vector(math.random(-50,50),math.random(-50,50),math.random(-25,150) )))
			util.Effect("ToolTracer", effectdata, true, true)
			timer.Create( "tesla"..tostring(self), 0.5, 60, function ()
				effectdata:SetOrigin(util.LocalToWorld(self, Vector(math.random(-50,50),math.random(-50,50),math.random(-25,150) )))
				util.Effect("ToolTracer", effectdata, true, true)
				effectdata:SetOrigin(util.LocalToWorld(self, Vector(math.random(-50,50),math.random(-50,50),math.random(-25,150) )))
				util.Effect("ToolTracer", effectdata, true, true)
				effectdata:SetOrigin(util.LocalToWorld(self, Vector(math.random(-50,50),math.random(-50,50),math.random(-25,150) )))
				util.Effect("ToolTracer", effectdata, true, true)
			end )
			timer.Create( "meltdownCountdown"..tostring(self), 1, 30, function()
				self.toMeltdown = self.toMeltdown - 1
			end)
			timer.Create( "meltdown"..tostring(self), 30, 1, function()
				self.alarmSound:Stop()
				self:MeltDown()
			end )
		end
	end
	
	PNRP.SaveState(nil, self, "world")
end 

function ENT:MeltDown()
	self.NoReturn = true
	
	local alarmSound = CreateSound( self, "ambient/alarms/combine_bank_alarm_loop4.wav" )
	alarmSound:Play()
	
	local effectdata = EffectData()
		effectdata:SetEntity(self)
		effectdata:SetStart(util.LocalToWorld( self, Vector(0,0,-50)))
		effectdata:SetOrigin(util.LocalToWorld(self, Vector(0,0,150)))
		effectdata:SetAttachment( 1 )
	
	effectdata:SetOrigin(util.LocalToWorld(self, Vector(math.random(-50,50),math.random(-50,50),math.random(-25,150) )))
	util.Effect("ToolTracer", effectdata, true, true)
	effectdata:SetOrigin(util.LocalToWorld(self, Vector(math.random(-50,50),math.random(-50,50),math.random(-25,150) )))
	util.Effect("ToolTracer", effectdata, true, true)
	effectdata:SetOrigin(util.LocalToWorld(self, Vector(math.random(-50,50),math.random(-50,50),math.random(-25,150) )))
	util.Effect("ToolTracer", effectdata, true, true)
	
	timer.Create( "tesla"..tostring(self), 0.2, 140, function ()
		effectdata:SetOrigin(util.LocalToWorld(self, Vector(math.random(-50,50),math.random(-50,50),math.random(-25,150) )))
		util.Effect("ToolTracer", effectdata, true, true)
		effectdata:SetOrigin(util.LocalToWorld(self, Vector(math.random(-50,50),math.random(-50,50),math.random(-25,150) )))
		util.Effect("ToolTracer", effectdata, true, true)
		effectdata:SetOrigin(util.LocalToWorld(self, Vector(math.random(-50,50),math.random(-50,50),math.random(-25,150) )))
		util.Effect("ToolTracer", effectdata, true, true)
	end )
	
	timer.Create("toCritTimer"..tostring(self), 1, 30, function()
		self.toCrit = self.toCrit - 1
	end)
	
	timer.Simple(30, function()
		alarmSound:Stop()
		local effectData = EffectData()
		effectData:SetStart( util.LocalToWorld(self, Vector(0,0,-70)) )
		effectData:SetOrigin( util.LocalToWorld(self, Vector(0,0,-70)) )
		effectData:SetNormal( Vector(0,0,0) )
		effectData:SetRadius( 500 )
		effectData:SetScale( 1 )
		util.Effect( "AR2Explosion", effectData, true, true  )
		
		effectdata = EffectData()
		effectdata:SetStart( self:GetPos() ) 
		effectdata:SetOrigin( self:GetPos() )
		effectdata:SetNormal( Vector(0,0,1) )
		effectdata:SetScale( 0.7 )
		util.Effect( "Sparks", effectdata )
		
		util.BlastDamage( self, self, self:GetPos(), 1000, 1000 )
		
		self:EmitSound( "weapons/physcannon/energy_sing_explosion2.wav", 100, 100)
		local ownerEnt = self:GetNetVar( "ownerent" )
		if ownerEnt then
			PNRP.TakeFromWorldCache( ownerEnt, "tool_fusion" )
		end
		timer.Destroy( "klaxon"..tostring(self) )
		
		local radPos = self:GetPos()
		timer.Create( "radsound"..tostring(self), 0.2, 1500, function ()
			local foundEnts = ents.FindInSphere( radPos, 1700 )
			for k, v in pairs( foundEnts ) do
				if v:IsPlayer() then
					if v:Alive() then
						if radPos:Distance(v:GetPos()) > 1000 then
							if math.random(4) > 3 then
								v:EmitSound( "player/geiger1.wav", 60, math.random( 90, 110 ) )
							end
						else
							if math.random(4) > 1 then
								v:EmitSound( "player/geiger2.wav", 60, math.random( 90, 110 ) )
							end
						end
					end
				end
			end
		end)
		
		timer.Create( "rad"..tostring(self), 1, 300, function ()
			local foundEnts = ents.FindInSphere( radPos, 1000 )
			for k, v in pairs( foundEnts ) do
				if v:IsPlayer() then
					if v:Alive() then
						local dmginfo = DamageInfo()
						dmginfo:SetDamageType(DMG_RADIATION)
						dmginfo:SetDamage(1)
						dmginfo:SetDamagePosition(radPos)
						dmginfo:SetInflictor(v)
						dmginfo:SetAttacker(v)
						
						v:TakeDamageInfo(dmginfo)
						
					end
				elseif v:IsNPC() then
					local dmginfo = DamageInfo()
					dmginfo:SetDamageType(DMG_RADIATION)
					dmginfo:SetDamage(1)
					dmginfo:SetDamagePosition(radPos)
					dmginfo:SetInflictor(v)
					dmginfo:SetAttacker(v)
					
					v:TakeDamageInfo(dmginfo)
				end
			end
		end )
		self:Remove()
		PNRP.DelPersistItem(self.iid)
	end )
end

function ENT:TogglePower()
	if not self.Status then
		self.Status = true
		self.PowerLevel = 1000
		
		self:GetPhysicsObject():EnableMotion(false)
		self.moveActive = false
		if self.NetworkContainer then
			self.NetworkContainer:UpdatePower()
		else
			self:UpdatePower()
		end
		self.genSound:Play()
	elseif self.Status then
		self.Status = false
		self.PowerLevel = 0
		
		self.moveActive = true
		if self.NetworkContainer then
			self.NetworkContainer:UpdatePower()
		else
			self:UpdatePower()
		end
		self.genSound:Stop()
	end
end

function ENT.TogglePowerNet()
	local ply = net.ReadEntity()
	local ent = net.ReadEntity()
	
	if not ent.Status then
		ply:ChatPrint("You switch the power on.")
	elseif ent.Status then
		ply:ChatPrint("You switch the power off.")
	end
	
	ent:TogglePower()
end
net.Receive( "togglefusgen_stream", ENT.TogglePowerNet )

function ENT.EmergencyShutdown()
	local ply = net.ReadEntity()
	local ent = net.ReadEntity()
	
	if ent.NoReturn then
		ply:ChatPrint("This reactor is already past the point of no return!")
		return
	end
	
	timer.Destroy( "meltdownCountdown"..tostring(ent) )
	ent.toMeltdown = 30
	
	ent.alarmSound:Stop()
	timer.Destroy( "tesla"..tostring(ent) )
	timer.Destroy( "meltdown"..tostring(ent) )
	ent.MeltingDown = false
	
	if ent.Status then
		ent:TogglePower()
	end
	
	ply:ChatPrint("You saved it just in time!")
end
net.Receive( "emerfusgen_stream", ENT.EmergencyShutdown )

function ENT.Repair()
	local ply = net.ReadEntity()
	local ent = net.ReadEntity()
	
	ply:SelectWeapon("weapon_simplekeys")
	ply:SetMoveType(MOVETYPE_NONE)
	ent.Repairing = ply
	
	net.Start("startProgressBar")
		net.WriteDouble(200 - ent:Health())
	net.Send(ply)
	
	timer.Create( ply:UniqueID().."_repair_"..tostring(ent), 0.25, ((200 - ent:Health())*4)/2, function()
		ply:SelectWeapon("weapon_simplekeys")
		if (not ent:IsValid()) or (not ply:Alive()) then
			ply:SetMoveType(MOVETYPE_WALK)
			net.Start("stopProgressBar")
			net.Send(ply)
			ent.Repairing = nil
			if ent:IsValid() then 
				timer.Stop(ply:UniqueID().."_repair_"..tostring(ent))
				PNRP.SaveState(nil, ent, "world")
			end
			return
		end
	end )
end
net.Receive( "repfusgen_stream", ENT.Repair )

function ENT.AddFuel()
	local amnt = net.ReadDouble()
	local ply = net.ReadEntity()
	local ent = net.ReadEntity()
	
	
	local plyInv = PNRP.Inventory( ply )
	local avail = plyInv["fuel_h2"]
	if amnt == nil then amnt = 0 end
	if avail == nil then avail = 0 end
	if amnt > avail then
		ply:ChatPrint("You don't have that much fuel.")
		return
	end
	
	ent.FuelLevel = ent.FuelLevel + amnt
	PNRP.TakeFromInventoryBulk(ply, "fuel_h2", amnt)
	
	PNRP.SaveState(nil, ent, "world")
	ply:ChatPrint("You have added "..tostring(amnt).." units of fuel.")
end
net.Receive( "loadfusgen_stream", ENT.AddFuel )

function ENT.RemFuel()
	local amnt = net.ReadDouble()
	local ply = net.ReadEntity()
	local ent = net.ReadEntity()
	
	if ent.FuelLevel < amnt then
		ply:ChatPrint( "There isn't that much fuel inside the reactor." )
	end
	
	ent.FuelLevel = ent.FuelLevel - amnt
	ply:AddToInventory("fuel_h2", amnt)
	
	PNRP.SaveState(nil, ent, "world")
	ply:ChatPrint("You have removed "..tostring(amnt).." units of fuel.")
end
net.Receive( "unloadfusgen_stream", ENT.RemFuel )

function ENT:Think()
	if self.Repairing then
		self:SetHealth(self:Health() + 2)
		
		if self:Health() >= 200 then
			self:SetHealth(self:Health() + 2)
			self.Repairing:ChatPrint("You finish repairing the generator.")
			
			self.Repairing:SetMoveType(MOVETYPE_WALK)
			net.Start("stopProgressBar")
			net.Send(self.Repairing)
			if self:IsValid() then 
				timer.Stop(self.Repairing:UniqueID().."_repair_"..tostring(self))
				PNRP.SaveState(nil, self, "world")
			end
			self.Repairing = nil
			self.BlockF2 = false
		end
	end
	
	if self.Status then
		if self.UnitLeft <= 0 then
			if self.FuelLevel <= 0 then
				self:TogglePower()
			else
				self.FuelLevel = self.FuelLevel - 1
				self.UnitLeft = 60
			end
			
			PNRP.SaveState(nil, self, "world")
		else
			self.UnitLeft = self.UnitLeft - 1
		end
	end
	self.Entity:NextThink(CurTime() + 1)
	return true
end

function ENT:OnRemove()
	self:PowerUnLink()
end

function ENT:PostEntityPaste(pl, Ent, CreatedEntities)
	self:Remove()
end
