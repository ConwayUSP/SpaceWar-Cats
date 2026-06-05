function debugRender(obj)
  if not debugMode then
    return
  end

  if obj.body and obj.shape then
    local x, y = obj.body:getPosition()
    local shapeType = obj.shape:getType()

    love.graphics.setColor(1, 0, 0)

    if shapeType == "circle" then
      local radius = obj.shape:getRadius()
      love.graphics.circle("line", x, y, radius)
    elseif shapeType == "polygon" then
      love.graphics.polygon("line", obj.body:getWorldPoints(obj.shape:getPoints()))
    end
  end

  love.graphics.setColor(1, 1, 1)

end