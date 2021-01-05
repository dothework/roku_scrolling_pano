function GetContent()
    url = CreateObject("roUrlTransfer")
    url.SetUrl("https://api.unsplash.com/collections/58979/photos?client_id=NzS7v222nOjZI4W7q_r-kDaq_-1rjaDT4Q5o36xpFko")
    url.SetCertificatesFile("common:/certs/ca-bundle.crt")
	url.InitClientCertificates()
    response = ParseJson(url.GetToString())
    m.global.photosRaw = response
end function