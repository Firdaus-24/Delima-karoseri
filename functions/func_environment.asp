<% @ Language=VBScript %>
<% 
option explicit 
Response.Expires = -1
Server.ScriptTimeout = 600
' ****************************************************
' Change the value of the variable below to the pathname
' of a directory with write permissions, for example "C:\Inetpub\wwwroot"
Dim uploadsDirVar
dim ID, p
' id = request.querystring("id")
' p = request.querystring("p")

uploadsDirVar = "D:\Delima\views\klaim\document"
' ****************************************************


function OutputForm()
%>


<%
end function
function TestEnvironment()
    Dim fso, fileName, testFile, streamTest
    TestEnvironment = ""
    Set fso = Server.CreateObject("Scripting.FileSystemObject")
    if not fso.FolderExists(uploadsDirVar) then
        TestEnvironment = "<B>Folder " & uploadsDirVar & " does not exist.</B><br>"
        exit function
    end if
    fileName = uploadsDirVar & id
    on error resume next
    Set testFile = fso.CreateTextFile(fileName, true)
    If Err.Number<>0 then
        TestEnvironment = "<B>Folder " & uploadsDirVar & " does not have write permissions.</B><br>The value of your uploadsDirVar is incorrect. Open uploadTester.asp in an editor and change the value of uploadsDirVar to the pathname of a directory with write permissions."
        exit function
    end if
    Err.Clear
    testFile.Close
    fso.DeleteFile(fileName)
    If Err.Number<>0 then
        TestEnvironment = "<B>Folder " & uploadsDirVar & " does not have delete permissions</B>, although it does have write permissions.<br>Change the permissions for IUSR_<I>computername</I> on this folder."
        exit function
    end if
    Err.Clear
    Set streamTest = Server.CreateObject("ADODB.Stream")
    If Err.Number<>0 then
        TestEnvironment = "<B>The ADODB object <I>Stream</I> is not available in your server.</B><br>Check the Requirements page for information about upgrading your ADODB libraries."
        exit function
    end if
    Set streamTest = Nothing
end function
function SaveFiles
    Dim Upload, fileName, fileSize, ks, i, fileKey
	
	
    Set Upload = New FreeASPUpload
    Upload.Save(uploadsDirVar)
	' If something fails inside the script, but the exception is handled
	If Err.Number<>0 then Exit function
    SaveFiles = ""
    ks = Upload.UploadedFiles.keys
    if (UBound(ks) <> -1) then
        SaveFiles = "<B>Files uploaded Success : </B> "
        for each fileKey in Upload.UploadedFiles.keys
            SaveFiles = SaveFiles & Upload.UploadedFiles(fileKey).FileName & " (" & Upload.UploadedFiles(fileKey).Length & "B) "
			
        next
		Response.Redirect("../veiws/klaim/index.asp")
    else
        SaveFiles = "The file name specified in the upload form does not correspond to a valid file in the system."
    end if
	
end function

    ' if Request.ServerVariables("REQUEST_METHOD") <> "GET" then
    '     diagnostics = TestEnvironment()
    '     if diagnostics<>"" then
    '         response.write "<div style=""margin-left:20; margin-top:30; margin-right:30; margin-bottom:30;"">"
    '         response.write diagnostics
    '         response.write "<p>After you correct this problem, reload the page."
    '         response.write "</div>"
    '     else
    '         response.write "<div style=""margin-left:150"">"
    '         OutputForm()
    '         response.write "</div>"
    '     end if
    ' else
        
    '     response.write "<div style=""margin-left:150"">"
    '     OutputForm()
    '     response.write SaveFiles()
    '     response.write "<br><br></div>"
    '     response.redirect "../vviews/klaim/klaim_add.asp"
    ' end if

 %>
<!--#include file="func_uploadFile.asp"-->