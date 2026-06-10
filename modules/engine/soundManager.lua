----------------------------------------
-- Importações de Módulos
----------------------------------------

local SFX_ASSETS = {
    morte1 = "assets/sounds/sfx/mortes/mortes-1.wav",
    morte2 = "assets/sounds/sfx/mortes/mortes-2.wav",
    morte3 = "assets/sounds/sfx/mortes/mortes-3.wav",
    tiro1 = "assets/sounds/sfx/tiros/tiros-1.mp3",
    tiro2 = "assets/sounds/sfx/tiros/tiros-2.wav",
    buy1 = "assets/sounds/sfx/buy/buy-1.mp3",
    buy2 = "assets/sounds/sfx/buy/buy-2.mp3",
    select1 = "assets/sounds/sfx/select/select-1.wav",
    select2 = "assets/sounds/sfx/select/select-2.wav",
    evil_laugh = "assets/sounds/sfx/evil_laugh.mp3",
    hit1 = "assets/sounds/sfx/hit/hit-1.wav",
    end_wave = "assets/sounds/sfx/end_wave.mp3",
    win = "assets/sounds/sfx/win.mp3"
}

local MUSIC_ASSETS = {
    ambience = "assets/sounds/music/ambience.mp3",
    battle = "assets/sounds/music/battle.wav",
}

----------------------------------------------
--- Classe SoundManager
----------------------------------------------

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

function SoundManager:load()
    for name, path in pairs(SFX_ASSETS) do
        local sfxInstance = SoundSFX.new(name, path, SFX)
        soundManager:add(sfxInstance)
    end

    for name, path in pairs(MUSIC_ASSETS) do
        local musicInstance = SoundMusic.new(name, path, MUSIC)
        soundManager:add(musicInstance)
    end
end

function SoundManager:update()
    for _, sound in pairs(self.sounds) do
        sound.source:update()
    end
end

function SoundManager:play(name, randPitch, loop)
    if self.sounds[name] then
        if randPitch then
            local k = 1.2
            local min, max = 1/k, k
            local r = math.random() * (max - min) + min
            self.sounds[name].source:setPitch(r)
        end
        self.sounds[name]:play(loop)
    end
end

function SoundManager:stop(name)
    if self.sounds[name] then
        self.sounds[name]:stop()
    end
end

function SoundManager:pause(name)
    if self.sounds[name] then
        self.sounds[name]:pause()
    end
    
end

function SoundManager:setSFXVolume(volume)
    self.sfxVolume = math.max(0, math.min(10, volume))

    for _, sound in pairs(self.sounds) do
        if sound.category == SFX then
            sound.source:setVolume(self.sfxVolume / 10)
        end
    end
end

function SoundManager:setMusicVolume(volume)
    self.musicVolume = math.max(0, math.min(10, volume))

    for _, sound in pairs(self.sounds) do
        if sound.category == MUSIC then
            sound.source:setVolume(self.musicVolume / 10)
        end
    end
end

function SoundManager:stopAll()
    for _, sound in pairs(self.sounds) do
        sound:stop()
    end
end

return SoundManager