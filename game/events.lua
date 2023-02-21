---@class PlayerLostEvent: BaseEvent
PlayerLostEvent = BaseEvent:extend()

---@class PlayerWonEvent: BaseEvent
PlayerWonEvent = BaseEvent:extend()

---@class EnemyKilledEvent: BaseEvent
EnemyKilledEvent = BaseEvent:extend()

---@class EnemySpawnedEvent: BaseEvent
EnemySpawnedEvent = BaseEvent:extend()

---@class UpgradeRoomFinishedEvent: BaseEvent
UpgradeRoomFinishedEvent = BaseEvent:extend()


---@param enemy_class table
function EnemyKilledEvent:new(enemy_class)
    self.enemy_class = enemy_class
end

---@param enemy_class table
function EnemySpawnedEvent:new(enemy_class)
    self.enemy_class = enemy_class
end