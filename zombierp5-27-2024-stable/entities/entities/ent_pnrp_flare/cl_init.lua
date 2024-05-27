include('shared.lua')
language.Add("ent_pnrp_flare", "Flare")
--[[---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------]]
function ENT:Initialize()
end

--[[---------------------------------------------------------
   Name: ENT:Draw()
---------------------------------------------------------]]
function ENT:Draw()
	self.Entity:DrawModel()
end

--[[---------------------------------------------------------
   Name: ENT:Think()
---------------------------------------------------------]]
function ENT:Think()
	if not self.Timer then self.Timer = CurTime() end
	if self.Timer < CurTime() then
		local light = DynamicLight(self:EntIndex())
		if light then
			light.Pos = self:GetPos()
			light.r = 255
			light.g = 100
			light.b = 100
			light.Brightness = 1
			light.Decay = math.random(500, 800) * 5
			light.Size = math.random(1000, 2000)
			light.DieTime = CurTime() + 1
		end
	end
end

--[[---------------------------------------------------------
   Name: ENT:IsTranslucent()
---------------------------------------------------------]]
function ENT:IsTranslucent()
	return true
end