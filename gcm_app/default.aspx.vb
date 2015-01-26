Imports System.IO
Imports System.Xml
Imports System.Net
Imports System.Web.Configuration.WebConfigurationManager
Public Class _default
    Inherits System.Web.UI.Page
    Private Const Cashost As String = "https://thekey.me/cas/"
    Public _service As String = ""
    ' Dim target_service = "http://localhost:52195/api/measurements/token"
    ' Dim target_service = "https://stage.sbr.global-registry.org/api/measurements/token"
    Dim target_service = AppSettings("service_api") & "/token"

    Public st = ""
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'hf_api_url.value = AppSettings("service_api")
        If Not String.IsNullOrEmpty(Session("pgt")) Then

            Dim validateurl As String = Cashost + "proxy?targetService=" & target_service & "&pgt=" & CStr(Session("pgt")).Trim().ToString()
            Dim reader1 As StreamReader = New StreamReader(New WebClient().OpenRead(validateurl))
            Dim doc As New XmlDocument()
            doc.Load(reader1)
            Dim namespaceMgr = New XmlNamespaceManager(doc.NameTable)
            namespaceMgr.AddNamespace("cas", "http://www.yale.edu/tp/cas")
            'Check for success
            Dim successNode = doc.SelectSingleNode("/cas:serviceResponse/cas:proxySuccess", namespaceMgr)
            If Not successNode Is Nothing Then
                st = successNode.InnerText

                Return

            End If


        End If

        Dim tkt As String = Request.QueryString("ticket")
        _service = HttpContext.Current.Request.Url.AbsoluteUri
        If _service.Contains("?") Then
            _service = Left(_service, _service.IndexOf("?"))
        End If


        If (tkt Is Nothing) Then

            Response.Redirect("https://thekey.me/cas/login.htm?service=" & _service)


        Else
            StaffLogin()
        End If
    End Sub
    Private Sub StaffLogin()

        Dim tkt As String = Request.QueryString("ticket")


        ' Second time (back from CAS) there is a ticket= to validate
        Dim validateurl As String = Cashost + "proxyValidate?" & "ticket=" & tkt & "&" & "service=" & _service & "&pgtUrl=https://agapeconnect.me/CasLogin.aspx"


        Dim reader1 As StreamReader = New StreamReader(New WebClient().OpenRead(validateurl))
        Dim doc As New XmlDocument()
        doc.Load(reader1)
        Dim namespaceMgr As New XmlNamespaceManager(doc.NameTable)
        namespaceMgr.AddNamespace("cas", "http://www.yale.edu/tp/cas")
        'Check for success
        Dim serviceResponse As XmlNode = doc.SelectSingleNode("/cas:serviceResponse/cas:authenticationFailure", namespaceMgr)
        If Not serviceResponse Is Nothing Then
            '   Response.Redirect("https://thekey.me/cas/login.htm?service=" & _service)

            Response.Write("Error: " & serviceResponse.InnerText)
            Return
        End If

        Dim successNode As XmlNode = doc.SelectSingleNode("/cas:serviceResponse/cas:authenticationSuccess", namespaceMgr)

        If Not successNode Is Nothing Then 'User Is authenticated
            Dim netid As String = String.Empty

            Dim firstName As String = String.Empty
            Dim lastName As String = String.Empty
            Dim ssoGuid As String = String.Empty
            Dim pgtiou As String = String.Empty

            If Not successNode.SelectSingleNode("./cas:user", namespaceMgr) Is Nothing Then
                netid = successNode.SelectSingleNode("./cas:user", namespaceMgr).InnerText
            End If
            If Not successNode.SelectSingleNode("./cas:attributes/firstName", namespaceMgr) Is Nothing Then
                firstName = successNode.SelectSingleNode("./cas:attributes/firstName", namespaceMgr).InnerText
            End If
            If Not successNode.SelectSingleNode("./cas:attributes/lastName", namespaceMgr) Is Nothing Then
                lastName = successNode.SelectSingleNode("./cas:attributes/lastName", namespaceMgr).InnerText
            End If
            If Not successNode.SelectSingleNode("./cas:attributes/ssoGuid", namespaceMgr) Is Nothing Then
                ssoGuid = successNode.SelectSingleNode("./cas:attributes/ssoGuid", namespaceMgr).InnerText
            End If
            If Not successNode.SelectSingleNode("./cas:proxyGrantingTicket", namespaceMgr) Is Nothing Then

                pgtiou = successNode.SelectSingleNode("./cas:proxyGrantingTicket", namespaceMgr).InnerText

            End If



            ' If there was a problem, leave the message on the screen. Otherwise, return to original page.
            If (netid = String.Empty) Then

                Response.Write("There was an error during login.")
            Else
                

                '    lblUsername.Text = netid
                Dim getPGT As New theKeyProxyTicket.PGTCallBack
                Dim pgt = getPGT.RetrievePGTCallback("CASAUTH", System.Web.Configuration.WebConfigurationManager.AppSettings("cas_callback_key"), pgtiou)
                Session("pgt") = pgt

                If Not String.IsNullOrEmpty(pgt) Then
                    validateurl = Cashost + "proxy?targetService=" & target_service & "&pgt=" & pgt.Trim().ToString()
                    reader1 = New StreamReader(New WebClient().OpenRead(validateurl))
                    doc = New XmlDocument()
                    doc.Load(reader1)
                    namespaceMgr = New XmlNamespaceManager(doc.NameTable)
                    namespaceMgr.AddNamespace("cas", "http://www.yale.edu/tp/cas")
                    'Check for success
                    successNode = doc.SelectSingleNode("/cas:serviceResponse/cas:proxySuccess", namespaceMgr)
                    If Not successNode Is Nothing Then
                        st = successNode.InnerText
                      


                    End If

                End If



            End If

        End If
    End Sub

End Class