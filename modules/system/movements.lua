function moveLeft(e, dt)
  e.body:setLinearVelocity(-e.speed * dt, 0)
end

function moveRight(e, dt)
  e.body:setLinearVelocity(e.speed * dt, 0)
end

function moveDirection(e, dt)
  local vx = e.speed * math.cos(e.dir) * dt
  local vy = e.speed * math.sin(e.dir) * dt
  e.body:setLinearVelocity(vx, vy)
end

function moveCircular(e, dt)
  e.dir = e.dir + e.turnSpeed * dt
  local vx = e.speed * math.cos(e.dir) * dt - e.speed * dt
  local vy = e.speed * math.sin(e.dir) * dt
  e.body:setLinearVelocity(vx, vy)
end
