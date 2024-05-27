local ITEM = {}
local WEAPON = {}


ITEM.ID = "wep_scrapmp"

ITEM.Name = "Uzi"
ITEM.ClassSpawn = "Engineer"
ITEM.Scrap = 20
ITEM.Small_Parts = 75
ITEM.Chemicals = 30
ITEM.Chance = 100
ITEM.Info = "Uses Pistol Ammo"
ITEM.Type = "weapon"
ITEM.Remove = true
ITEM.Energy = 40
ITEM.Ent = "tacrp_uzi"
ITEM.Model = "models/weapons/tacint/w_uzi.mdl"
ITEM.Script = ""
ITEM.Weight = 5
ITEM.ShopHide = true

WEAPON.ID = ITEM.ID
WEAPON.AmmoType = "pistol"

function ITEM.ToolCheck( p )
	return true
end

function ITEM.Use( ply )
	local WepName = "tacrp_uzi"
	local gotWep = false
	for k, v in pairs(ply:GetWeapons()) do
		if v:GetClass() == WepName then gotWep = true end
	end
	if gotWep == false then 
		ply:Give(WepName) 
		ply:GetWeapon(WepName):SetClip1(0)
		return true
	else
		ply:ChatPrint("Weapon allready equipped.")
		return false
	end
end

function ITEM.Create( ply, class, pos )
	local ent = ents.Create("tacrp_uzi")
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