' Copyright (c) 2018 Roku, Inc. All rights reserved.

sub Init()  
    appInfo = CreateObject("roAppInfo")
    m.buttons = m.top.FindNode("buttons")
    m.username = m.top.FindNode("username")
    ' m.logo = m.top.FindNode("logo")
    ' m.logo.uri = m.global.logoURI
    ' m.username.text = channel_data.username 
    ' m.usernameLabel = m.top.FindNode("usernameLabel")
    ' m.usernameLabel.text = tr("Username:")
    ' m.subscription = m.top.FindNode("subscription")
    ' m.subscriptionLabel = m.top.FindNode("subscriptionLabel")
    ' m.subscriptionLabel.text = tr("Subscription:")
    ' m.versionValue = m.top.FindNode("versionValue")
    ' m.versionValue.text = appInfo.GetVersion()
    ' m.versionLabel = m.top.FindNode("versionLabel")
    ' m.versionLabel.text = tr("Channel Version:")
    ' m.title = m.top.FindNode("title")
    ' m.title.text = tr("Calm Radio Account")

    rootNode = createObject("roSGNode","ContentNode") 
    item = Utils_AAToContentNode({CONTENTTYPE:"SECTION", TITLE: tr("Channel")}, "ContentNode")
    entry = Utils_AAToContentNode({title: tr("Play"), id:"play", checkedItem:false}, "ContentNode")
    item.appendChild(entry)
    entry = Utils_AAToContentNode({title: tr("No Play"), id:"play", checkedItem:true}, "ContentNode")
    item.appendChild(entry)
    rootNode.appendChild(item)


    m.buttons.content = rootNode
    m.buttons.SetFocus(true)
    ' Observe SGDEXComnponent fields
    m.top.ObserveField("wasShown", "OnWasShown")
    m.top.ObserveField("wasClosed", "OnWasClosed")

end sub

sub OnWasShown()
    ' m.logo.uri = m.global.logoURI
end sub

sub OnWasClosed()
    ' ?"OPTIONS VIEW WAS CLOSED"
end sub
