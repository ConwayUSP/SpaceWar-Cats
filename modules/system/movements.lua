function moveLeft(e, dt)
  e.body:setLinearVelocity(-e.speed * dt, 0)
end

function moveRight(e, dt)
  e.body:setLinearVelocity(e.speed * dt, 0)
end