-- Logging Options
EnableLogging = true
Debug = true
LogServerAddress = "654D04274F62C9562665E299A8024E60"
NetworkCard = computer.getPCIDevices(findClass("NetworkCard"))[1]

-- Threading Options
ThreadSleepTime = 0.0

-- General Functions
function sleep(s)
    event.pull(s)
end
   
function getObj(s)
    local res = component.proxy(component.findComponent(s))

    for i,k in pairs(res) do
        if k ~= nil then if Debug then print("Object " .. s .. " found: ", k) end end
        return k
    end

    if Debug then print("No object found for ", s) end
end

function getTime()
    return computer.time()
end

function printTime(time)
    time = math.floor(time / 12)
    local days = math.floor(time/86400)
    local hours = math.floor(math.fmod(time, 86400)/3600)
    local minutes = math.floor(math.fmod(time,3600)/60)
    local seconds = math.floor(math.fmod(time,60))
    print(string.format("%d:%02d:%02d:%02d",days,hours,minutes,seconds))
end

function log(message)
    if EnableLogging then 
        if Debug then print(message) end
        NetworkCard:send(LogServerAddress, 80, message) 
    end
end

-- Threading
threadManager = {threads = {}}
   
function threadManager:add(func, ...)
    local t = {}
    t.co = coroutine.create(func)
    t.params = {...}
    table.insert(self.threads, t)
end

function threadManager:run()
    while true do
        for i = 1, #self.threads, 1 do
            if coroutine.status(self.threads[i].co) == "dead" then 
                table.remove(self.threads, i)
                if #self.threads == 0 then return end
                break
            else
                coroutine.resume(self.threads[i].co, table.unpack(self.threads[i].params))
            end
        end
        sleep(ThreadSleepTime)
    end
end