----------------------------------------
-- Importações de Módulos
----------------------------------------

SoundManager = {}

SoundManager.sounds = {}
SoundManager.type = "SoundManager"
SoundManager.sfxVolume = 1
SoundManager.musicVolume = 1

function SoundManager:add(sound)
    self.sounds[sound.name] = sound
end

function SoundManager:remove(name)
    self.sounds[name] = nil
end

function SoundManager:load(name, path, category)
    local soundObj
    category = category or "sfx"

    if category == "sfx" then
        soundObj = SoundSFX.new(name, path)
    elseif category == "music" then
        soundObj = SoundMusic.new(name, path) 
    end

    if soundObj then
        self.sounds[name] = soundObj
    end
    return soundObj
end

function SoundManager:update()
    for _, sound in pairs(self.sounds) do
        sound:update()
    end
end

function SoundManager:play(name, randPitch)
    if self.sounds[name] then
        if randPitch then
            local k = 1.2
            local min, max = 1/k, k
            local r = math.random() * (max - min) + min
            self.sounds[name].source:setPitch(r)
        end
        self.sounds[name]:play()
    end
end

function SoundManager:stopAll()
    for _, sound in pairs(self.sounds) do
        sound:stop()
    end
end

return SoundManager