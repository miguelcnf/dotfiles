-- General
hs.console.clearConsole()

-- Audio Device Watching
logger = hs.logger.new("audioDevice", "debug")

audioDeviceWatcher = nil
currentDevice = hs.audiodevice.defaultOutputDevice():name()

function audioDeviceChangedCallback()
    newDevice = hs.audiodevice.defaultOutputDevice():name()

    spotifyIsPlaying = hs.spotify.isPlaying()

    if currentDevice ~= "miguel-bose" and newDevice == "Built-in Output" and spotifyIsPlaying == true then
        hs.spotify.pause();
        hs.notify.new({title="Hammerspoon", informativeText="Paused Spotify"}):send()
        logger.d("Paused Spotify")
    end

    currentDevice = newDevice
end

audioDeviceWatcher = hs.audiodevice.watcher
audioDeviceWatcher.setCallback(audioDeviceChangedCallback)
audioDeviceWatcher:start()
