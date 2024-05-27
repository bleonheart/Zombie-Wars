local ITEM = {}
local WEAPON = {}


ITEM.ID = "wep_ak-comp"

ITEM.Name = "AK-47"
ITEM.ClassSpawn = "Engineer"
ITEM.Scrap = 50
ITEM.Small_Parts = 100
ITEM.Chemicals = 50
ITEM.Chance = 100
ITEM.Info = "Uses Fusion Ammo"
ITEM.Type = "weapon"
ITEM.Remove = true
ITEM.Energy = 30
ITEM.Ent = "tacrp_ex_ak47"
ITEM.Model = "models/weapons/tacint_extras/w_ak47.mdl"
ITEM.Script = ""
ITEM.Weight = 5
ITEM.ShopHide = true

WEAPON.ID = ITEM.ID
WEAPON.AmmoType = "ar2"


function ITEM.ToolCheck( p )
	return true
end

function ITEM.Use( ply )
	local WepName = "tacrp_ex_ak47"
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
	local ent = ents.Create("tacrp_ex_ak47")
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