local ITEM = {}


ITEM.ID = "food_booze1"

ITEM.Name = "Orange Liqueur"
ITEM.ClassSpawn = "Cultivator"
ITEM.Scrap = 0
ITEM.Small_Parts = 0
ITEM.Chemicals = 2
ITEM.Chance = 100
ITEM.Info = "A jug of orange liqueur.  Oranges being about the only thing you can grow, it's what you've got."
ITEM.Type = "food"
ITEM.Remove = true
ITEM.Energy = 30
ITEM.Ent = "food_booze1"
ITEM.Model = "models/props_junk/glassjug01.mdl"
ITEM.Script = ""
ITEM.Weight = 1


function ITEM.ToolCheck( p )
	return {["food_orange"]=3}
end

function ITEM.Use( ply )
	local drunkness = ply:GetTable().Drunkness
		
	if not drunkness then
		ply.Drunkness = 0
	end
	
	local sound = Sound("npc/ichthyosaur/snap.wav")
	ply:EmitSound( sound )
	
	ply:GiveHunger( 30 )
	ply:GiveDrunkness(20)
	
	if ply.Drunkness >= 100 then
		ply:ChatPrint("You've passed out completely!")
		
		ply.Endurance = 0
		SendEndurance( ply )
		
		EnterSleep(ply)
	end
	
	return true
end

function ITEM.Create( ply, class, pos )
	local ent = ents.Create(class)
	ent:SetAngles(Angle(0,0,0))
	ent:SetPos(pos)
	ent:Spawn()
end

PNRP.AddItem(ITEM)


