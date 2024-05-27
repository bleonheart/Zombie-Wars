local ITEM = {}
local WEAPON = {}


ITEM.ID = "wep_M82"

ITEM.Name = "AS50-Sniper"
ITEM.ClassSpawn = "Engineer"
ITEM.Scrap = 50
ITEM.Small_Parts = 50
ITEM.Chemicals = 100
ITEM.Chance = 100
ITEM.Info = "Uses 357 Ammo."
ITEM.Type = "weapon"
ITEM.Remove = true
ITEM.Energy = 5
ITEM.Ent = "tacrp_as50"
ITEM.Model = "models/weapons/tacint/w_as50.mdl"
ITEM.Script = ""
ITEM.Weight = 8
ITEM.ShopHide = true
ITEM.AllHide = true

WEAPON.ID = ITEM.ID
WEAPON.AmmoType = "357"

function ITEM.ToolCheck( p )
	return true
end

function ITEM.Use( ply )
	local WepName = "tacrp_as50"
	local gotWep = false
	for k, v in pairs(ply:GetWeapons()) do
		if v:GetClass() == WepName then gotWep = true end
	end
	if gotWep == false then 
		ply:Give(WepName) 
		ply:GetWeapon(WepName):SetClip1(0)
		return true
	else
		ply:ChatPrint("Weapon already equipped.")
		return false
	end
end

function ITEM.Create( ply, class, pos )
	local ent = ents.Create("tacrp_as50")
	--ent:SetNetworkedInt("Ammo", self.Energy)
	ent:SetNWString("WepClass", ITEM.Ent)
	ent:SetModel(ITEM.Model)
	ent:SetAngles(Angle(0,0,0))
	ent:SetPos(pos)
	ent:Spawn()
	
	return ent
end

PNRP.AddItem(ITEM)
PNRP.AddWeapon(WEAPON)