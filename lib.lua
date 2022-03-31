function sleep(s)
    event.pull(s)
end
   
function getObj(s)
    local res = component.proxy(component.findComponent(s))

    for i,k in pairs(res) do
        if k ~= nil then print("Object " .. s .. " found: ", k) end
        return k
    end

    print("No object found for ", s)
end

function log(message)
    local NetworkCard = computer.getPCIDevices(findClass("NetworkCard"))[1]
    print(message)
    NetworkCard:send("654D04274F62C9562665E299A8024E60", 80, message) 
end