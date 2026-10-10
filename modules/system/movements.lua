function moveLeft(e, dt)
  e.body:setLinearVelocity(-e.speed, 0)
end

function moveRight(e, dt)
  e.body:setLinearVelocity(e.speed, 0)
end

function moveDirection(e, dt)
  local vx = e.speed * math.cos(e.dir)
  local vy = e.speed * math.sin(e.dir)
  e.body:setLinearVelocity(vx, vy)
end

function moveCircular(e, dt)
  e.dir = e.dir + e.turnSpeed * dt
  local vx = e.speed * math.cos(e.dir) - e.speed
  local vy = e.speed * math.sin(e.dir)
  e.body:setLinearVelocity(vx, vy)
end
