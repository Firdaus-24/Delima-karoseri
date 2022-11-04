<% 
	dim id 
	id = trim(Request.QueryString("id"))
%>
<!DOCTYPE html>
<html>
<head>
    <title>Document</title>
</head>
<body>
<% 
	Response.ContentType = "application/pdf"
    Response.AddHeader "content-disposition", "Filename=" & id & ".PDF"
    Const adTypeBinary = 1	

    strFilePath ="D:Delima\document\pdf\"& id &".pdf" 'This is the path to the file on disk. 

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