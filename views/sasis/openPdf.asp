<!--#include file="../../url.asp"-->
<% 
	dim id 
	id = trim(Request.QueryString("id"))
   p = trim(Request.QueryString("p"))
   if p = "draw" then
      path = "stack\"
   else
      path = "pdf\"
   end if
%>
<!DOCTYPE html>
<html>
<head>   
   <title>Document</title>
   <link href= '<%= url %>public/img/delimalogo.png' rel='website icon' type='png' />
</head>
<body>
<% 
	Response.ContentType = "application/pdf"
   Response.AddHeader "content-disposition", "Filename=" & id & ".PDF"
   Const adTypeBinary = 1	

    strFilePath = "D:Delima\document\"& path &id&".pdf" 'This is the path to the file on disk. 
      ' response.write strFilePath
    Set objStream = Server.CreateObject("ADODB.Stream")
    objStream.Open
    objStream.Type = adTypeBinary
    objStream.LoadFromFile strFilePath

    Response.BinaryWrite objStream.Read

    objStream.Close
    Set objStream = Nothing

%>
</body>
</html>