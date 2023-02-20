---@class PlayerLostEvent: BaseEvent
PlayerLostEvent = BaseEvent:extend()

---@class PlayerWonEvent: BaseEvent
PlayerWonEvent = BaseEvent:extend()

---@class EnemyKilledEvent: BaseEvent
EnemyKilledEvent = BaseEvent:extend()

---@param enemy_class table
function EnemyKilledEvent:new(enemy_class)
    self.enemy_class = enemy_class
end