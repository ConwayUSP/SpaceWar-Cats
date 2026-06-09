function screenToGamePosition(x, y)
	return (x - SCREEN_OFFSET_X) / SCREEN_SCALE, (y - SCREEN_OFFSET_Y) / SCREEN_SCALE
end

function gameToScreenPosition(x, y)
	return x * SCREEN_SCALE + SCREEN_OFFSET_X, y * SCREEN_SCALE + SCREEN_OFFSET_Y
end

function updateScreenTransform()
	SCREEN_WIDTH, SCREEN_HEIGHT = love.graphics.getDimensions()
	SCREEN_SCALE = math.min(SCREEN_WIDTH / VIRTUAL_WIDTH, SCREEN_HEIGHT / VIRTUAL_HEIGHT)
	SCREEN_OFFSET_X = (SCREEN_WIDTH - VIRTUAL_WIDTH * SCREEN_SCALE) / 2
	SCREEN_OFFSET_Y = (SCREEN_HEIGHT - VIRTUAL_HEIGHT * SCREEN_SCALE) / 2
end

function toggleFullscreen()
	isFullscreen = not isFullscreen
	love.window.setFullscreen(isFullscreen)
end