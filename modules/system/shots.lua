function defaultConicalAttackFunc(min, max, ang)
	return function(atk, attacker, origin, direction)
		
		return function(dt)
			for i = min, max do
				local dirIncrement = ang and (ang / (max - min) * i) or math.rad(360 / (max - min)) * i
				local newDirection = direction + dirIncrement
				atk:shot(attacker, origin, newDirection)
			end
			
			return true
		end
	end
end
