sub RunScreenSaver()
  screen = createObject("roSGScreen") 'Creates screen to display screensaver
  port = createObject("roMessagePort") 'Port to listen to events on screen
  screen.setMessagePort(port)

  di = CreateObject("roDeviceInfo")
  m.global = screen.getGlobalNode()
  m.global.AddField("GetModel", "string", true)
  m.global.GetModel = di.GetModel()
  m.global.AddField("GetModelDisplayName", "string", true)
  m.global.GetModelDisplayName = di.GetModelDisplayName()
  m.global.AddField("GetModelType", "string", true)
  m.global.GetModelType = di.GetModelType()
  m.global.AddField("GetModelDetails", "assocarray", true)
  m.global.GetModelDetails = di.GetModelDetails()
  m.global.AddField("GetFriendlyName", "string", true)
  m.global.GetFriendlyName = di.GetFriendlyName()
  m.global.AddField("GetOSVersion", "assocarray", true)
  m.global.GetOSVersion = di.GetOSVersion()
  m.global.AddField("GetVersion", "string", true)
  m.global.GetVersion = di.GetVersion()

  m.global.AddField("GetChannelClientId", "string", true)
  m.global.GetChannelClientId = di.GetChannelClientId()

  m.global.AddField("GetCurrentLocale", "string", true)
  m.global.GetCurrentLocale = di.GetCurrentLocale()
  m.global.AddField("GetUserCountryCode", "string", true)
  m.global.GetUserCountryCode = di.GetUserCountryCode()
  m.global.AddField("GetTimeZone", "string", true)
  m.global.GetTimeZone = di.GetTimeZone()
  m.global.AddField("GetCountryCode", "string", true)
  m.global.GetCountryCode = di.GetCountryCode()
  m.global.AddField("GetPreferredCaptionLanguage", "string", true)
  m.global.GetPreferredCaptionLanguage = di.GetPreferredCaptionLanguage()
  m.global.AddField("GetClockFormat", "string", true)
  m.global.GetClockFormat = di.GetClockFormat()

  m.global.AddField("GetLinkStatus", "bool", true)
  m.global.GetLinkStatus = di.GetLinkStatus()
  m.global.AddField("GetConnectionType", "string", true)
  m.global.GetConnectionType = di.GetConnectionType()
  m.global.AddField("GetExternalIp", "string", true)
  m.global.GetExternalIp = di.GetExternalIp()
  m.global.AddField("GetIPAddrs", "assocarray", true)
  m.global.GetIPAddrs = di.GetIPAddrs()
  m.global.AddField("GetConnectionInfo", "assocarray", true)
  m.global.GetConnectionInfo = di.GetConnectionInfo()

  m.global.AddField("GetDisplayType", "string", true)
  m.global.GetDisplayType = di.GetDisplayType()
  m.global.AddField("GetDisplayMode", "string", true)
  m.global.GetDisplayMode = di.GetDisplayMode()
  m.global.AddField("GetDisplayAspectRatio", "string", true)
  m.global.GetDisplayAspectRatio = di.GetDisplayAspectRatio()
  m.global.AddField("GetDisplaySize", "assocarray", true)
  m.global.GetDisplaySize = di.GetDisplaySize()
  m.global.AddField("GetVideoMode", "string", true)
  m.global.GetVideoMode = di.GetVideoMode()
  m.global.AddField("GetDisplayProperties", "assocarray", true)
  m.global.GetDisplayProperties = di.GetDisplayProperties()
  m.global.AddField("GetSupportedGraphicsResolutions", "array", true)
  m.global.GetSupportedGraphicsResolutions = di.GetSupportedGraphicsResolutions()
  m.global.AddField("GetUIResolution", "assocarray", true)
  m.global.GetUIResolution = di.GetUIResolution()
  m.global.AddField("GetGraphicsPlatform", "string", true)
  m.global.GetGraphicsPlatform = di.GetGraphicsPlatform()

  m.global.AddField("GetAudioOutputChannel", "string", true)
  m.global.GetAudioOutputChannel = di.GetAudioOutputChannel()
  ' m.global.AddField("CanDecodeAudio", "assocarray", true)
  ' m.global.CanDecodeAudio = di.CanDecodeAudio()

  scene = screen.createScene("Screensaver") 'Creates scene to display on screen. Scene name (AnimatedScreensaver) must match ID of XML Scene Component
  screen.show()

  while(true) 'Uses message port to listen if channel is closed
      msg = wait(0, port)
      if (msg <> invalid)
          msgType = type(msg)
          if msgType = "roSGScreenEvent"
              if msg.isScreenClosed() then return
          end if
      end if
  end while
end sub

' sub RunUserInterface(args)
'   RunScreenSaver()
' end sub

' sub RunScreenSaverSettings() 
'   RunScreenSaver()
' end sub