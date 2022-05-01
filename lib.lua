-- Variables
debug = true

-- General Functions
function sleep(s)
    event.pull(s)
end
   
function getObj(s)
    local res = component.proxy(component.findComponent(s))

    for i,k in pairs(res) do
        if k ~= nil then if debug then print("Object " .. s .. " found: ", k) end end
        return k
    end

    if debug then print("No object found for ", s) end
end

function log(message)
    local NetworkCard = computer.getPCIDevices(findClass("NetworkCard"))[1]
    if debug then print(message) end
    NetworkCard:send("654D04274F62C9562665E299A8024E60", 80, message) 
end

-- Central Storage
ItemConnector = {splitter = {}, amount = 0}
function ItemConnector:new(o, splitter, amount)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.splitter = splitter
    self.amount = amount
    return o
end

Factory = {name = "", itemConnectors = {}}
function Factory:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

-- Threading
thread = {
    threads = {},
    current = 1
}
   
function thread.create(func, ...)
    local t = {}
    t.co = coroutine.create(func)
    t.params = ...
    function t:stop()
        for i,th in pairs(thread.threads) do
            if th == t then
                table.remove(thread.threads, i)
            end
        end
    end
    table.insert(thread.threads, t)
    return t
end

function thread:run()
    while true do
        if #thread.threads < 1 then
            return
        end
        if thread.current > #thread.threads then
            thread.current = 1
        end
        coroutine.resume(true, thread.threads[thread.current].co, thread.threads[thread.current].params)
        thread.current = thread.current + 1
    end
end