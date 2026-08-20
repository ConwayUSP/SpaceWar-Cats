function returnFont(size)
  local path = "assets/fonts/"
  local name = "pixel-font"
  local fontPath = path .. name .. ".ttf"
	local font

  if love.filesystem.getInfo(fontPath) then
  	font = love.graphics.newFont(fontPath, size)
  else
    font = love.graphics.newFont(size)
  end
	
	font:setFilter("nearest", "nearest")
  return font
end

function capitalize(string)
  return string:gsub("^%l", string.upper)
end

-- Compare two floats with a precisio of epsilon
function compareFloats(a, b, epsilon)
    return math.abs(a - b) < epsilon
end


----------------------------------------
-- Funções para tabelas
----------------------------------------

---@param table table
---@param value any
---@return unknown
-- retorna a chave do valor `value` na tabela `table`
function tableFind(table, value)
	for k, v in pairs(table) do
		if v == value then
			return k
		end
	end
	return nil
end

---@param table table
---@param value any
---@return integer | nil
-- retorna o índice do valor `value` na tabela `table`
function tableIndexOf(table, value)
	for i, v in ipairs(table) do
		if v == value then
			return i
		end
	end
	return nil
end

---@param a table
---@param b table
-- retorna uma chave única para o par de tabelas `a` e `b`
function pairKey(a, b)
	return tostring(a) .. "|" .. tostring(b)
end

---@param table table
---@return number
-- equivalente ao operador #, mas para tabelas indexadas por não-números
function tableLen(table)
	local len = 0
	for _, _ in pairs(table) do
		len = len + 1
	end
	return len
end


----------------------------------------
-- Funções matemáticas
----------------------------------------
---
function truncate(number)
    return number >= 0 and math.floor(number) or math.ceil(number)
end

---@param x number
---@param a number
---@param b number
---@return number
-- retorna `x` limitado ao intervalo `[a, b]`
function clamp(x, a, b)
	if x < a then
		return a
	end
	if x > b then
		return b
	end
	return x
end

---@param a number
---@param b number
---@param t number
---@return number
-- retorna a interpolação linear entre `a` e `b` no ponto `t`
function lerp(a, b, t)
	return a + (b - a) * t
end

---@alias range {min: number, max: number}

---@param min number
---@param max number
---@return range
-- cria uma faixa de valores com mínimo e máximo
function range(min, max)
	return { min = min, max = max }
end

---@param value number
---@param inMin number
---@param inMax number
---@param outMin number
---@param outMax number
---@return number
-- remapeia um valor em um intervalo [inMin, inMax] para [outMin, outMax]
function remap(value, inMin, inMax, outMin, outMax)
	return outMin + (value - inMin) * (outMax - outMin) / (inMax - inMin)
end

---@param x number
---@return -1 | 0 | 1
-- retorna o sinal de `x`
function sign(x)
	return (x > 0 and 1) or (x == 0 and 0) or -1
end

---@param width number
---@param height number
---@return Size
-- construtor do tipo Size
function size(width, height)
	return { width = width, height = height }
end


----------------------------------------
-- Funções de sistema de arquivos
----------------------------------------

---@param s string
---@return string
-- transforma uma string em um formato padronizado para caminhos,
-- substituindo espaços por `_` e  letras maiúsculas em minúsculas
function pathlizeName(s)
	return string.lower(string.gsub(s, " ", "_"))
end

---@param parts string[]
---@return string
-- transforma uma lista de nomes de pastas em um caminho para o diretório final
function dirPathFormat(parts)
	local path = pathlizeName(parts[1])
	for i = 2, #parts, 1 do
		path = path .. "/" .. pathlizeName(parts[i])
	end
	print(path)
	return path
end

---@param parts string[]
---@return string
-- transforma uma lista de pastas e um nome de arquivo em um caminho para o arquivo
function pngPathFormat(parts)
	local path = ""
	for i, v in ipairs(parts) do
		if i ~= #parts then
			path = path .. pathlizeName(v) .. "/"
		else
			path = path .. pathlizeName(v) .. ".png"
		end
	end
	return path
end

----------------------------------------
-- Funções de Debug
----------------------------------------

function debugTable(tableName, table)
	print("--- TABLE: " .. tableName .. " ---")
	for k, v in pairs(table) do
		print(tostring(k) .. " = " .. tostring(v))
	end
	print("----------------------------------")
end

----------------------------------------
-- Renderização
----------------------------------------

function renderDots(x1, y1, x2, y2, size, step)
  step = step or 5
  size = size or 4

  local points = {}
  local deltaX, deltaY = x2 - x1, y2 - y1
  local len = math.max (math.abs(deltaX), math.abs(deltaY))

  for iStep = 0, len do
    if iStep % 4 == 0 then
      table.insert (points, x1 + deltaX * iStep/len)
      table.insert (points, y1 + deltaY * iStep/len)
    end
  end

  love.graphics.setPointSize(size)
  love.graphics.points(points)
  love.graphics.setPointSize(1)
end

----------------------------------------
-- String
----------------------------------------

function split(inputstr, sep)
	if sep == nil then
		sep = "%s" -- Default separator is whitespace
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

----------------------------------------
-- System
----------------------------------------

function checkMobile()
	local os = love.system.getOS()
	if os == "Android" or os == "iOS" then
		return true
	end
	return false
end
