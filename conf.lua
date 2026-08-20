function love.conf(t)
    -- Fixed canvas size for web builds
    t.window.width = 1280
    t.window.height = 720

    t.window.title = "SpaceWar Cats"
    t.window.icon = "assets/icon.png"
    t.window.resizable = false

    t.console = true

    t.modules.joystick = false
    t.externalstorage = true

    -- Threads are not available on the web, so keep this disabled
    t.modules.thread = false
end
