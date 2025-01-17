local ITEM = {}
local WEAPON = {}


ITEM.ID = "wep_badlands"

ITEM.Name = "Daewoo K1A"
ITEM.ClassSpawn = "Engineer"
ITEM.Scrap = 50
ITEM.Small_Parts = 90
ITEM.Chemicals = 35
ITEM.Chance = 100
ITEM.Info = "Uses SMG Ammo."
ITEM.Type = "weapon"
ITEM.Remove = true
ITEM.Energy = 15
ITEM.Ent = "tacrp_k1a"
ITEM.Model = "models/weapons/tacint/w_k1a.mdl"
ITEM.Script = ""
ITEM.Weight = 10
ITEM.ShopHide = true

WEAPON.ID = ITEM.ID
WEAPON.AmmoType = "smg1"


function ITEM.ToolCheck( p )
	return true
end

function ITEM.Use( ply )
	local WepName = "tacrp_k1a"
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
	local ent = ents.Create("tacrp_k1a")
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