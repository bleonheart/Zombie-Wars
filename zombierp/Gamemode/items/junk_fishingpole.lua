local ITEM = {}
local WEAPON = {}

ITEM.ID = "fishing_pole"
ITEM.Name = "Fishing Pole"
ITEM.ClassSpawn = "All"
ITEM.Scrap = 1
ITEM.Small_Parts = 1
ITEM.Chemicals = 1
ITEM.Chance = 100
ITEM.Info = "For Passive Gameplay ONLY, B to open shop menu and R to drop your catch."
ITEM.Type = "junk"
ITEM.Remove = true
ITEM.Energy = 15
ITEM.Ent = "weapon_fishing_rod"
ITEM.Model = "models/props_junk/harpoon002a.mdl"
ITEM.Script = ""
ITEM.Weight = 2
ITEM.ShopHide = false

WEAPON.ID = ITEM.ID
WEAPON.AmmoType = "none"

function ITEM.ToolCheck( p )
	return true
end

function ITEM.Use( ply )
	local WepName = "weapon_fishing_rod"
	local gotWep = false
	for k, v in pairs(ply:GetWeapons()) do
		if v:GetClass() == WepName then gotWep = true end
	end
	if gotWep == false then 
		ply:Give(WepName)
		return true
	else
		ply:ChatPrint("Weapon already equipped.")
		return false
	end
end

function ITEM.Create( ply, class, pos )
	local ent = ents.Create("weapon_fishing_rod")
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