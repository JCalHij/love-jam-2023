--[[
The `EventLayer` class is responsible for notifying interested
objects (tables) of events that are registered to it.

**Example**

```lua
-- We create a layer object
local layer = EventLayer("example", {BaseEvent, OtherEvent})
-- Simple object
local a = {b = 1}
-- Register object to `BaseEvent` events
layer:register(a, BaseEvent, function(event) 
    print(event:class_name())
    print(event.i)
end)
-- Notify the layer of a `BaseEvent`. The callback will be executed.
layer:notify(BaseEvent(5))
-- Notify the layer of an `OtherEvent`. The callback will not be executed.
layer:notify(OtherEvent(6))
-- Unregister object from event layer.
layer:unregister(a)
```
--]]
---@class EventLayer: Object
---@operator call(): EventLayer
---@field name string Name of the layer
---@field events { [table]: { [table]: fun(e: BaseEvent) } } Table containing class references to which this event layer will provide notifications for
EventLayer = Object:extend()

--[[
Create a new `EventLayer` object.

**Example**

```lua
-- BaseEvent and OtherEvent are event classes
local layer = EventLayer("example", {BaseEvent, OtherEvent})
```
--]]
---@param name string name of the event layer
---@param event_list BaseEvent[] list containing the classes to which this event layer will provide notifications for
function EventLayer:new(name, event_list)
    self.name = name
    self.events = {}
    for _, event_class in ipairs(event_list) do
        self.events[event_class] = {}
    end
end


--[[
Notifies all registered objects that given event has occurred.

**Example**

```lua
-- BaseEvent is an event class
layer:notify(BaseEvent(5))
```
--]]
---@param event BaseEvent event object
function EventLayer:notify(event)
    -- Object received is of type BaseEvent
    assert(event:is(BaseEvent), string.format("EventLayer:notify - Object received on layer '%s' is not a BaseEvent child (%s)", self.name, event))
    -- Layer listens to this type of event
    assert(self.events[event:class()], string.format("EventLayer:notify - Event '%s' not assigned to EventLayer '%s'", event:class_name(), self.name))

    for _, callback in pairs(self.events[event:class()]) do
        callback(event)
    end
end


--[[
Register given `listener` (a table or an object) with given 
`callback` function under event type `event_class`.

Future notifications on the event layer for events of type
`event_class` will notify the `listener` as well.

**Parameters**
- `listener` [table]: object that requests to be notified in the future
- `event_class` [table]: event type, which inherits from 
- `callback` [function]: function to be used when notifying the `listener`.
It takes as a single parameter the event object that is being notified, which
is of type `event_class`.

**Example**

```lua
-- Register object to `BaseEvent` events
layer:register(obj, BaseEvent, function(event) 
    print(event:class_name())
end)
```
--]]
---@param listener table
---@param event_class BaseEvent
---@param callback fun(e: BaseEvent)
function EventLayer:register(listener, event_class, callback)
    -- Table received is of type BaseEvent
    assert(event_class:is(BaseEvent), string.format("EventLayer:register - Object received on layer '%s' is not a BaseEvent child", self.name))
    -- Layer listens to this type of event
    assert(self.events[event_class], string.format("EventLayer:register - Event '%s' not assigned to EventLayer '%s'", event_class:class_name(), self.name))

    self.events[event_class][listener] = callback
end


--[[
Unregisters given `listener` from the event layer, for all events.
In case that an `event_class_list` is provided, it unregisters
the `listener` only for given events.

**Parameters**
- `listener` [table]: object that requests removal of notifications
- `event_class_list` [table]: optional table containing a list of all
classes to which the `listener` is not interested in anymore.

**Example**

```lua
-- Unregister object from event layer.
layer:unregister(obj)
-- Unregister object from event layer, only for specific events.
layer:unregister(obj, {BaseEvent, OtherEvent})
```
--]]
---@param listener table
---@param event_class_list? BaseEvent[]
function EventLayer:unregister(listener, event_class_list)
    if event_class_list then -- Specific-class removal
        for _, event_class in ipairs(event_class_list) do
            -- Table received is of type BaseEvent
            assert(event_class:is(BaseEvent), string.format("EventLayer:register - Object received on layer '%s' is not a BaseEvent child", self.name))
            -- Layer listens to this type of event
            assert(self.events[event_class], string.format("EventLayer:unregister - Event '%s' not assigned to EventLayer '%s'", event_class:class_name(), self.name))

            self.events[event_class][listener] = nil
        end
    else
        -- Remove listener from everywhere
        for _, event_registry in pairs(self.events) do
            event_registry[listener] = nil
        end
    end
end


--[[
The `BaseEvent` class serves as base for all event classes
that want to be used on an `EventLayer`.
--]]
---@class BaseEvent: Object
BaseEvent = Object:extend()

local BaseEventExtend = BaseEvent.extend

function BaseEvent:extend()
    -- AllEventClasses auto-registering mechanism
    local event_class = BaseEventExtend(BaseEvent)
    table.insert(AllEventClasses, event_class)
    return event_class
end


function BaseEvent:class_name()
  return "BaseEvent"
end


function BaseEvent:__tostring()
  return "BaseEvent"
end


--[[
A list of all existing event classes. Use it as a default
when creating all-purpose event layers.

There is no need to append event classes to this table. 
Simply by inheriting from the `BaseEvent` class is enough.

**Example**

```lua
-- BaseEvent and OtherEvent are event classes
local layer = EventLayer("example", AllEventClasses)
```
--]]
---@type BaseEvent[]
AllEventClasses = {}