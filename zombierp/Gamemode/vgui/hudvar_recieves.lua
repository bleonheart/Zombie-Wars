---  This file receives variable-sending 
---  usermessages
----------------------------------------
Hunger = 100
Endurance = 100

function ReceiveEndurance( )
    Endurance = math.Round(net:ReadDouble())
end
net.Receive("endurancemsg", ReceiveEndurance)

function ReceiveHunger( )
    Hunger = math.Round(net:ReadDouble())
end
net.Receive("hungermsg", ReceiveHunger)

function ReceiveGas( )
    local ply = net:ReadEntity()
    local car = net:ReadEntity()
    local gas = net:ReadDouble()
    local tank = net:ReadDouble()
    
    car.gas = gas
    car.tank = tank
    
--    ply:ChatPrint(tostring(gas))
end
net.Receive("sndCarGas", ReceiveGas)

function ReceiveComDipl()
    local count = net.ReadUInt(32) 
    local diplTbl = {}

    for i = 1, count do
        local key = net.ReadString() // key?
        local value = net.ReadDouble()  // value?
        diplTbl[key] = value
    end

    LocalPlayer().ComDiplomacy = diplTbl
end
net.Receive("sndComDipl", ReceiveComDipl) 