local ITEM = {}
local WEAPON = {}


ITEM.ID = "wep_grenade"

ITEM.Name = "Frag Grenade"
ITEM.ClassSpawn = "Science"
ITEM.Scrap = 5
ITEM.Small_Parts = 2
ITEM.Chemicals = 5
ITEM.Chance = 100
ITEM.Info = ""
ITEM.Type = "weapon"
ITEM.Remove = true
ITEM.Energy = 1
ITEM.Ent = "tacrp_nade_frag"
ITEM.Model = "models/weapons/tacint/frag.mdl"
ITEM.Script = ""
ITEM.Weight = 1

WEAPON.ID = ITEM.ID
WEAPON.AmmoType = "grenade"

function ITEM.ToolCheck( p )
	return true
end

function ITEM.Use( ply )
	local WepName = "tacrp_nade_frag"
	local gotWep = false
	for k, v in pairs(ply:GetWeapons()) do
		if v:GetClass() == WepName then gotWep = true end
	end
	if gotWep == false then 
		ply:Give(WepName) 
		
		return true
	else
		ply:GiveAmmo(1, "grenade")
		return true
	end
end

function ITEM.Create( ply, class, pos )
	local ent = ents.Create("tacrp_nade_frag")
	--ent:SetNetworkedInt("Ammo", self.Energy)
	ent:SetNetVar("WepClass", ITEM.Ent)
	ent:SetModel(ITEM.Model)
	ent:SetAngles(Angle(0,0,0))
	ent:SetPos(pos)
	ent:Spawn()
	
	return ent
end

PNRP.AddItem(ITEM)
PNRP.AddWeapon(WEAPON)