local ITEM = {}
local WEAPON = {}


ITEM.ID = "wep_57luck"

ITEM.Name = "Glock 17"
ITEM.ClassSpawn = "Engineer"
ITEM.Scrap = 2
ITEM.Small_Parts = 25
ITEM.Chemicals = 10
ITEM.Chance = 100
ITEM.Info = "Uses Pistol Ammo."
ITEM.Type = "weapon"
ITEM.Remove = true
ITEM.Energy = 20
ITEM.Ent = "tacrp_ex_glock"
ITEM.Model = "models/weapons/tacint_extras/w_glock_new.mdl"
ITEM.Script = ""
ITEM.Weight = 2

WEAPON.ID = ITEM.ID
WEAPON.AmmoType = "pistol"


function ITEM.ToolCheck( p )
	return true
end

function ITEM.Use( ply )
	local WepName = "tacrp_ex_glock"
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
	local ent = ents.Create("tacrp_ex_glock")
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