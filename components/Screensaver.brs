Function init()
  ' Prepare timer that will load images 
  m.timer = m.top.findNode("timer")
  m.timer.ObserveField("fire", "timerFired") 

  m.fetchImageListAPI = CreateObject("roSGNode", "FetchImageListAPI")
  m.FetchImageAPI = CreateObject("roSGNode", "FetchImageAPI")
  m.FetchImageAPI.ObserveField("transferComplete", "onTransferComplete")

  m.global.AddField("photosRaw", "array", false)
  m.global.ObserveField("photosRaw", "dataIsReady")

  ' Initialize else it may be accessed too early
  m.masterAnimation = m.top.findNode("masterAnimation")
  m.PA1 = m.top.findNode("PA1")
  m.PA2 = m.top.findNode("PA2")

  m.timer.duration = "50" '1/4 of a single animation
  m.PA1.duration = "200"
  m.PA2.duration = "200"

  m.Poster1 = m.top.findNode("Poster1")
  m.Poster2 = m.top.findNode("Poster2")

  m.V2D11 = m.top.findNode("2D11")
  m.V2D12 = m.top.findNode("2D12")

  m.V2D21 = m.top.findNode("2D21")
  m.V2D22 = m.top.findNode("2D22")

  m.loopCount = 0
  m.masterLoopCount = 0

  if m.global.GetUIResolution.name = "FHD" then
    ' RESIZE POSTERS
    m.Poster1.height = "1080"
    m.Poster1.loadHeight = "1080"
    m.Poster1.width = "3840"
    m.Poster1.loadWidth = "3840"
    m.Poster2.height = "1080"
    m.Poster2.loadHeight = "1080"
    m.Poster2.width = "3840"
    m.Poster2.loadWidth = "3840"

    'REKEY ANIMATIONS
    m.V2D11.keyValue = "[[0,0],[-3840,0]]"
    m.V2D12.keyValue = "[[3840,0],[0,0]]"
   
    m.V2D21.keyValue = "[[3840,0],[0,0]]"
    m.V2D22.keyValue = "[[0,0],[-3840,0]]"

  end if

  ' ?"GetContent RUN"
  m.fetchImageListAPI.functionName = "GetContent"
  m.fetchImageListAPI.control = "RUN"

end Function

sub dataIsReady()
  ' ?"dataIsReady FIRED"
  if m.global.photosRaw = invalid then
    ' ?"must fetch data... ugh"
    end 
  end if
  m.photoCount = m.global.photosRaw.Count()
  ' Fetch image data for first box.
  imageA = m.global.photosRaw[rnd(m.photoCount)-1]
  ' Set background color to match incoming image
  m.top.backgroundColor = imageA.color

  m.timer.control = "start"
  m.FetchImageAPI.uri = imageA.urls.small
  m.FetchImageAPI.poster = "1"
  m.FetchImageAPI.transferComplete = false
  m.FetchImageAPI.filename = ("tmp:/poster%1.jpg").replace("%1",Str(rnd(0)).replace(" ", ""))
  m.FetchImageAPI.functionName = "uriImageToTemp"
  ' ?"uriImageToTemp RUN"
  m.FetchImageAPI.control = "RUN"

  m.global.AddField("RSG_analytics", "node", false)
  m.global.RSG_analytics = createObject("roSGNode", "Roku_Analytics:AnalyticsNode")
  m.global.RSG_analytics.debug = false
  m.global.RSG_analytics.init = {
      Google: {
          trackingID: "UA-115638141-13"
          defaultParams: {
              an: "Scrolling Pano"
          }
      }
  }
  TrackEvent("app", "launch", "", "")

end sub

sub onTransferComplete()
  di = CreateObject("roDeviceInfo")
  if m.FetchImageAPI.transferComplete = true then
    ' ?"Memory Level",di.GetGeneralMemoryLevel()
    if m.FetchImageAPI.poster = "1" then 
      m.Poster1.uri = m.FetchImageAPI.filename
    else 
      m.Poster2.uri = m.FetchImageAPI.filename
    end if 
    if m.masterAnimation.control <> "start" then
      m.masterAnimation.control = "start"
      m.timer.control = "start"
    end if 
  end if
end sub


sub timerFired()
  ' ?"m.loopCount", m.loopCount
  ' onbly run if animation is running
  ' if m.masterAnimation.state <> "running" then 
  '   end
  ' end if

  ' load new random images in posters that are now offscreen
  ' TODO: do not place the same image on the screen twice
  if m.loopCount = 0 then
    m.FetchImageAPI.poster = "2"
    m.FetchImageAPI.transferComplete = false
    m.FetchImageAPI.uri = m.global.photosRaw[rnd(m.photoCount)-1].urls.small
    m.FetchImageAPI.filename = ("tmp:/poster%1.jpg").replace("%1",Str(rnd(0)).replace(" ", ""))
    m.FetchImageAPI.lastfilename = m.Poster2.uri
    m.FetchImageAPI.functionName = "uriImageToTemp"
    m.FetchImageAPI.control = "RUN"
  else if m.loopCount = 4 then
    m.FetchImageAPI.poster = "1"
    m.FetchImageAPI.transferComplete = false
    m.FetchImageAPI.uri = m.global.photosRaw[rnd(m.photoCount)-1].urls.small
    m.FetchImageAPI.filename = ("tmp:/poster%1.jpg").replace("%1",Str(rnd(0)).replace(" ", ""))
    m.FetchImageAPI.lastfilename = m.Poster2.uri
    m.FetchImageAPI.functionName = "uriImageToTemp"
    m.FetchImageAPI.control = "RUN"
  end if

  ' increment counters as two posters have exited the screen
  if m.loopCount = 7 then
    m.loopCount = 0
    m.masterLoopCount += 1
  else 
    m.loopCount += 1
  end if
end sub

' GA Measurement Protocol
' https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters#sc
' Hit Builder
' https://ga-dev-tools.appspot.com/hit-builder/

Sub TrackEvent(ec as string, ea as string, el as string, ev as string)
  if m.global.RSG_analytics <> invalid then
    ni = invalid
    exd = invalid 'excpetion description
    exf = 0 'exception was fatal
    'cd<index> = something

    ua = "ROKU/"+m.global.GetOSVersion.Lookup("major")+"."+m.global.GetOSVersion.Lookup("minor")+"."+m.global.GetOSVersion.Lookup("revision")+"."+m.global.GetOSVersion.Lookup("build")
    ua += " ("+m.global.GetModelType+" - "+m.global.GetModel+") "+m.global.GetModelDisplayName
    
    vm = m.global.GetVideoMode
    if Instr(1, vm, "480") > 0 then
      sr = "720X480"
    else if Instr(1, vm, "576") > 0 then
      sr = "720X576"
    else if Instr(1, vm, "720") > 0 then
      sr = "1280X720"
    else if Instr(1, vm, "1080") > 0 then
      sr = "1920X1080"
    else
      sr = "3840X2160"
    end if

    sd = "8-bits"
    if right(m.global.GetVideoMode, 3) = "b10" then 
        sd = "10-bits"
    end if

    sc = invalid
    if ea = "launch" then sc = "start"

    m.global.RSG_analytics.trackEvent = {
        Google: {
            t: "event"
            ds: "app"
            cid: m.global.GetChannelClientId
            uid: ""
            sc: sc
            ec: ec
            ea: ea
            el: el
            ev: ev
            ni: ni 
            uip: m.global.GetExternalIp
            ua: ua
            geoid: m.global.GetCountryCode
            sr: sr
            vp: m.global.GetDisplayMode
            sd: sd
            ul: m.global.GetCurrentLocale
            cd: "screensaver"
            exd: exd
            exf: exf
        }
    }
  end if
end Sub