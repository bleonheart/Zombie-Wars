local ITEM = {}
local WEAPON = {}


ITEM.ID = "wep_smg"

ITEM.Name = "HK UMP45"
ITEM.ClassSpawn = "Engineer"
ITEM.Scrap = 20
ITEM.Small_Parts = 75
ITEM.Chemicals = 30
ITEM.Chance = 100
ITEM.Info = "Uses Pistol Ammo"
ITEM.Type = "weapon"
ITEM.Remove = true
ITEM.Energy = 25
ITEM.Ent = "tacrp_ex_ump45"
ITEM.Model = "models/weapons/tacint_extras/w_ump45.mdl"
ITEM.Script = ""
ITEM.Weight = 7
ITEM.ShopHide = true

WEAPON.ID = ITEM.ID
WEAPON.AmmoType = "pistol"


function ITEM.ToolCheck( p )
	return true
end

function ITEM.Use( ply )
	local WepName = "tacrp_ex_ump45"
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
	local ent = ents.Create("tacrp_ex_ump45")
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