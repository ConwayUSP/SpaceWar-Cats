function flexCenter(count, itemWidth, gap)
	local totalWidth = count * itemWidth + (count - 1) * gap
	return (VIRTUAL_WIDTH - totalWidth) / 2
end