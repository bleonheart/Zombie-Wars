local ITEM = {}
local WEAPON = {}

ITEM.ID = "wep_saw"

ITEM.Name = "HK MG4"
ITEM.ClassSpawn = "Engineer"
ITEM.Scrap = 100
ITEM.Small_Parts = 150
ITEM.Chemicals = 100
ITEM.Chance = 100
ITEM.Info = "Uses Fusion Ammo."
ITEM.Type = "weapon"
ITEM.Remove = true
ITEM.Energy = 100
ITEM.Ent = "tacrp_mg4"
ITEM.Model = "models/weapons/tacint/w_mg4.mdl"
ITEM.Script = ""
ITEM.Weight = 16
ITEM.ShopHide = true

WEAPON.ID = ITEM.ID
WEAPON.AmmoType = "ar2"


function ITEM.ToolCheck( p )
	return true
end

function ITEM.Use( ply )
	local WepName = "tacrp_mg4"
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
	local ent = ents.Create("tacrp_mg4")
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