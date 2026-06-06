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