<%@ Language=VBScript %>
<% 
option explicit 
Response.Expires = -1
Server.ScriptTimeout = 600
' ****************************************************
' Change the value of the variable below to the pathname
' of a directory with write permissions, for example "C:\Inetpub\wwwroot"
Dim uploadsDirVar
' dim id
' 	id = request("id")
' 	if id = "" then
' 		response.AddHeader "REFRESH","0:URL=uploadtest.asp?id=000000000"
' 	end if
dim id, p, t, db, url, accept
id = request.querystring("id")
p = Request.QueryString("p")
t = Request.QueryString("T")
db = Request.QueryString("db")

if t = "image" then
	accept = "image/*"
else
	accept = ".pdf"
end if
uploadsDirVar = "D:\Delima\document\"&t
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
		if db <> "" then
			Response.Redirect("editImage.asp?id="&id&"&db="&db)
		else
			Response.Redirect("index.asp")	
		end if
    else
        SaveFiles = "The file name specified in the upload form does not correspond to a valid file in the system."
    end if
	
end function
%>
<!--#include file="../../init.asp"-->
<% call header("UPLOAD DOCUMENT") %>
<!--#include file="../../navbar.asp"-->	

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
 

<script>
function onSubmitForm(objForm) {
    var formDOMObj = document.frmSend;
    var arrExtensions=new Array("jpg");
	var objInput = objForm.elements["filter"];
	var strFilePath = objInput.value;
	var arrTmp = strFilePath.split(".");
	var strExtension = arrTmp[arrTmp.length-1].toLowerCase();
	var blnExists = false;
	
	
	for (var i=0; i<arrExtensions.length; i++) 
	{
		if (strExtension == arrExtensions[i]) 
		{
			blnExists = true;
			break;
		}
	}
	
	if (!blnExists)
		alert("Only upload Photo with JPG extension only","File Upload Failed");
	return blnExists;
	
    if (formDOMObj.attach1.value == "" && formDOMObj.attach2.value == "" && formDOMObj.attach3.value == "" && formDOMObj.attach4.value == "" )
        alert("Please press the Browse button and pick a file.")
    else
        return true;
    return false;
}
</script>

<style>
    .container{
        margin-top:25vh;
        background-color:whitesmoke;
        border:2px solid black;
        border-radius:20px;
    }
    .upload{
        margin-left:30%;
    }
    .upload button[type=button]{
        margin-left:-34px;
    }
    .upload img{
        max-width:15%;
        margin-top:-8%;
        float: right;
    }
</style>
<div class="container">
    <div class='row'>
        <div class='col text-center'>
            <h3>UPLOAD DOCUMENT PENDUKUNG</h3>
        </div>
    </div>
    <div class="upload">
        <form name="frmSend" method="POST" enctype="multipart/form-data" action="uploadtest.asp?id=<%=id%>&p=<%=p%>&t=<%= t %>&db=<%= db %>" >   	<p style="margin-top: 0; margin-bottom: 0">&nbsp;</p>
        
        <p style="margin-top: 0; margin-bottom: 0"><b>File To Upload : </b>
        <input name="filter" type="file" size="20" accept="<%= accept %>" required/>
        <button type="submit" class="btn btn-primary" value="submit">UPLOAD</button>
        </p>
        </form> 
        <%
        Dim diagnostics
        if Request.ServerVariables("REQUEST_METHOD") <> "POST" then
            diagnostics = TestEnvironment()
            if diagnostics<>"" then
                response.write "<div style=""margin-left:20; margin-top:30; margin-right:30; margin-bottom:30;"">"
                response.write diagnostics
                response.write "<p>After you correct this problem, reload the page."
                response.write "</div>"
            else
                response.write "<div style=""margin-left:150"">"
                OutputForm()
                response.write "</div>"
            end if
        else
            response.write "<div style=""margin-left:150"">"
            OutputForm()
            response.write SaveFiles()
            response.write "<br><br></div>"
			response.redirect "index.asp"
        end if
        %>
        <u><b>Ketentuan :</b></u><ul>
        <li>Pastikan nama file sudah sesuai dengan nomor transaksi</li>
        <li>CONTOH : 0010821003.<%= p %></li>
        <li>Kami hanya menerima document dalam bentuk format file *.<%= p %></li>

        <button type="button" onclick="window.location.href='index.asp'" class="btn btn-danger mt-4">Kembali</button>
        <img src="../../public/img/delimalogo.png">
    </div>
</div>
<% call footer() %>


<%
'  For examples, documentation, and your own free copy, go to:
'  http://www.freeaspupload.net
'  Note: You can copy and use this script for free and you can make changes
'  to the code, but you cannot remove the above comment.
'Changes:
'Aug 2, 2005: Add support for checkboxes and other input elements with multiple values
'Jan 6, 2009: Lars added ASP_CHUNK_SIZE
const DEFAULT_ASP_CHUNK_SIZE = 200000
Class FreeASPUpload
	Public UploadedFiles
	Public FormElements
	Private VarArrayBinRequest
	Private StreamRequest
	Private uploadedYet
	Private internalChunkSize
	Private Sub Class_Initialize()
		Set UploadedFiles = Server.CreateObject("Scripting.Dictionary")
		Set FormElements = Server.CreateObject("Scripting.Dictionary")
		Set StreamRequest = Server.CreateObject("ADODB.Stream")
		StreamRequest.Type = 2	' adTypeText
		StreamRequest.Open
		uploadedYet = false
		internalChunkSize = DEFAULT_ASP_CHUNK_SIZE
	End Sub
	
	Private Sub Class_Terminate()
		If IsObject(UploadedFiles) Then
			UploadedFiles.RemoveAll()
			Set UploadedFiles = Nothing
		End If
		If IsObject(FormElements) Then
			FormElements.RemoveAll()
			Set FormElements = Nothing
		End If
		StreamRequest.Close
		Set StreamRequest = Nothing
	End Sub
	Public Property Get Form(sIndex)
		Form = ""
		If FormElements.Exists(LCase(sIndex)) Then Form = FormElements.Item(LCase(sIndex))
	End Property
	Public Property Get Files()
		Files = UploadedFiles.Items
	End Property
	
    Public Property Get Exists(sIndex)
            Exists = false
            If FormElements.Exists(LCase(sIndex)) Then Exists = true
    End Property
        
    Public Property Get FileExists(sIndex)
        FileExists = false
            if UploadedFiles.Exists(LCase(sIndex)) then FileExists = true
    End Property
        
    Public Property Get chunkSize()
		chunkSize = internalChunkSize
	End Property
	Public Property Let chunkSize(sz)
		internalChunkSize = sz
	End Property
	'Calls Upload to extract the data from the binary request and then saves the uploaded files
	Public Sub Save(path)
		Dim streamFile, fileItem
		if Right(path, 1) <> "\" then path = path & "\"
		if not uploadedYet then Upload
		For Each fileItem In UploadedFiles.Items
			Set streamFile = Server.CreateObject("ADODB.Stream")
			streamFile.Type = 1
			streamFile.Open
			StreamRequest.Position=fileItem.Start
			StreamRequest.CopyTo streamFile, fileItem.Length
			streamFile.SaveToFile path & fileItem.FileName, 2
			streamFile.close
			Set streamFile = Nothing
			fileItem.Path = path & fileItem.FileName
		Next
	End Sub
	
	public sub SaveOne(path, num, byref outFileName, byref outLocalFileName)
		Dim streamFile, fileItems, fileItem, fs
        set fs = Server.CreateObject("Scripting.FileSystemObject")
		if Right(path, 1) <> "\" then path = path & "\"
		if not uploadedYet then Upload
		if UploadedFiles.Count > 0 then
			fileItems = UploadedFiles.Items
			set fileItem = fileItems(num)
		
			outFileName = fileItem.FileName
			outLocalFileName = GetFileName(path, outFileName)
		
			Set streamFile = Server.CreateObject("ADODB.Stream")
			streamFile.Type = 1
			streamFile.Open
			StreamRequest.Position = fileItem.Start
			StreamRequest.CopyTo streamFile, fileItem.Length
			streamFile.SaveToFile path & outLocalFileName, 2
			streamFile.close
			Set streamFile = Nothing
			fileItem.Path = path & filename
		end if
	end sub
	Public Function SaveBinRequest(path) ' For debugging purposes
		StreamRequest.SaveToFile path & "\debugStream.bin", 2
	End Function
	Public Sub DumpData() 'only works if files are plain text
		Dim i, aKeys, f
		response.write "Form Items:<br>"
		aKeys = FormElements.Keys
		For i = 0 To FormElements.Count -1 ' Iterate the array
			response.write aKeys(i) & " = " & FormElements.Item(aKeys(i)) & "<BR>"
		Next
		response.write "UPLOAD FILE SUCCESS :<br>"
		For Each f In UploadedFiles.Items
			response.write "Name: " & f.FileName & "<br>"
			response.write "Type: " & f.ContentType & "<br>"
			response.write "Start: " & f.Start & "<br>"
			response.write "Size: " & f.Length & "<br>"
		Next
   	End Sub
	Public Sub Upload()
		Dim nCurPos, nDataBoundPos, nLastSepPos
		Dim nPosFile, nPosBound
		Dim sFieldName, osPathSep, auxStr
		Dim readBytes, readLoop, tmpBinRequest
		
		'RFC1867 Tokens
		Dim vDataSep
		Dim tNewLine, tDoubleQuotes, tTerm, tFilename, tName, tContentDisp, tContentType
		tNewLine = String2Byte(Chr(13))
		tDoubleQuotes = String2Byte(Chr(34))
		tTerm = String2Byte("--")
		tFilename = String2Byte("filename=""")
		tName = String2Byte("name=""")
		tContentDisp = String2Byte("Content-Disposition")
		tContentType = String2Byte("Content-Type:")
		uploadedYet = true
		on error resume next
			readBytes = internalChunkSize
			VarArrayBinRequest = Request.BinaryRead(readBytes)
			VarArrayBinRequest = midb(VarArrayBinRequest, 1, lenb(VarArrayBinRequest))
			for readLoop = 0 to 300000
				tmpBinRequest = Request.BinaryRead(readBytes)
				if readBytes < 1 then exit for
				VarArrayBinRequest = VarArrayBinRequest & midb(tmpBinRequest, 1, lenb(tmpBinRequest))
			next
			if Err.Number <> 0 then 
				response.write "<br><br><B>System reported this error:</B><p>"
				response.write Err.Description & "<p>"
				response.write "The most likely cause for this error is the incorrect setup of AspMaxRequestEntityAllowed in IIS MetaBase. Please see instructions in the <A HREF='http://www.freeaspupload.net/freeaspupload/requirements.asp'>requirements page of freeaspupload.net</A>.<p>"
				Exit Sub
			end if
		on error goto 0 'reset error handling
		nCurPos = FindToken(tNewLine,1) 'Note: nCurPos is 1-based (and so is InstrB, MidB, etc)
		If nCurPos <= 1  Then Exit Sub
		 
		'vDataSep is a separator like -----------------------------21763138716045
		vDataSep = MidB(VarArrayBinRequest, 1, nCurPos-1)
		'Start of current separator
		nDataBoundPos = 1
		'Beginning of last line
		nLastSepPos = FindToken(vDataSep & tTerm, 1)
		Do Until nDataBoundPos = nLastSepPos
			
			nCurPos = SkipToken(tContentDisp, nDataBoundPos)
			nCurPos = SkipToken(tName, nCurPos)
			sFieldName = ExtractField(tDoubleQuotes, nCurPos)
			nPosFile = FindToken(tFilename, nCurPos)
			nPosBound = FindToken(vDataSep, nCurPos)
			
			If nPosFile <> 0 And  nPosFile < nPosBound Then
				Dim oUploadFile
				Set oUploadFile = New UploadedFile
				
				nCurPos = SkipToken(tFilename, nCurPos)
				auxStr = ExtractField(tDoubleQuotes, nCurPos)
                ' We are interested only in the name of the file, not the whole path
                ' Path separator is \ in windows, / in UNIX
                ' While IE seems to put the whole pathname in the stream, Mozilla seem to 
                ' only put the actual file name, so UNIX paths may be rare. But not impossible.
                osPathSep = "\"
                if InStr(auxStr, osPathSep) = 0 then osPathSep = "/"
				oUploadFile.FileName = Right(auxStr, Len(auxStr)-InStrRev(auxStr, osPathSep))
				if (Len(oUploadFile.FileName) > 0) then 'File field not left empty
					nCurPos = SkipToken(tContentType, nCurPos)
					
                    auxStr = ExtractField(tNewLine, nCurPos)
                    ' NN on UNIX puts things like this in the stream:
                    '    ?? python py type=?? python application/x-python
					oUploadFile.ContentType = Right(auxStr, Len(auxStr)-InStrRev(auxStr, " "))
					nCurPos = FindToken(tNewLine, nCurPos) + 4 'skip empty line
					
					oUploadFile.Start = nCurPos+1
					oUploadFile.Length = FindToken(vDataSep, nCurPos) - 2 - nCurPos
					
					If oUploadFile.Length > 0 Then UploadedFiles.Add LCase(sFieldName), oUploadFile
				End If
			Else
				Dim nEndOfData
				nCurPos = FindToken(tNewLine, nCurPos) + 4 'skip empty line
				nEndOfData = FindToken(vDataSep, nCurPos) - 2
				If Not FormElements.Exists(LCase(sFieldName)) Then 
					FormElements.Add LCase(sFieldName), Byte2String(MidB(VarArrayBinRequest, nCurPos, nEndOfData-nCurPos))
				else
                    FormElements.Item(LCase(sFieldName))= FormElements.Item(LCase(sFieldName)) & ", " & Byte2String(MidB(VarArrayBinRequest, nCurPos, nEndOfData-nCurPos)) 
                end if 
			End If
			'Advance to next separator
			nDataBoundPos = FindToken(vDataSep, nCurPos)
		Loop
		StreamRequest.WriteText(VarArrayBinRequest)
	End Sub
	Private Function SkipToken(sToken, nStart)
		SkipToken = InstrB(nStart, VarArrayBinRequest, sToken)
		If SkipToken = 0 then
			Response.write "Error in parsing uploaded binary request. The most likely cause for this error is the incorrect setup of AspMaxRequestEntityAllowed in IIS MetaBase. Please see instructions in the <A HREF='http://www.freeaspupload.net/freeaspupload/requirements.asp'>requirements page of freeaspupload.net</A>.<p>"
			Response.End
		end if
		SkipToken = SkipToken + LenB(sToken)
	End Function
	Private Function FindToken(sToken, nStart)
		FindToken = InstrB(nStart, VarArrayBinRequest, sToken)
	End Function
	Private Function ExtractField(sToken, nStart)
		Dim nEnd
		nEnd = InstrB(nStart, VarArrayBinRequest, sToken)
		If nEnd = 0 then
			Response.write "Error in parsing uploaded binary request."
			Response.End
		end if
		ExtractField = Byte2String(MidB(VarArrayBinRequest, nStart, nEnd-nStart))
	End Function
	'String to byte string conversion
	Private Function String2Byte(sString)
		Dim i
		For i = 1 to Len(sString)
		   String2Byte = String2Byte & ChrB(AscB(Mid(sString,i,1)))
		Next
	End Function
	'Byte string to string conversion
	Private Function Byte2String(bsString)
		Dim i
		dim b1, b2, b3, b4
		Byte2String =""
		For i = 1 to LenB(bsString)
		    if AscB(MidB(bsString,i,1)) < 128 then
		        ' One byte
    		    Byte2String = Byte2String & ChrW(AscB(MidB(bsString,i,1)))
    		elseif AscB(MidB(bsString,i,1)) < 224 then
    		    ' Two bytes
    		    b1 = AscB(MidB(bsString,i,1))
    		    b2 = AscB(MidB(bsString,i+1,1))
    		    Byte2String = Byte2String & ChrW((((b1 AND 28) / 4) * 256 + (b1 AND 3) * 64 + (b2 AND 63)))
    		    i = i + 1
    		elseif AscB(MidB(bsString,i,1)) < 240 then
    		    ' Three bytes
    		    b1 = AscB(MidB(bsString,i,1))
    		    b2 = AscB(MidB(bsString,i+1,1))
    		    b3 = AscB(MidB(bsString,i+2,1))
    		    Byte2String = Byte2String & ChrW(((b1 AND 15) * 16 + (b2 AND 60)) * 256 + (b2 AND 3) * 64 + (b3 AND 63))
    		    i = i + 2
    		else
    		    ' Four bytes
    		    b1 = AscB(MidB(bsString,i,1))
    		    b2 = AscB(MidB(bsString,i+1,1))
    		    b3 = AscB(MidB(bsString,i+2,1))
    		    b4 = AscB(MidB(bsString,i+3,1))
    		    ' Don't know how to handle this, I believe Microsoft doesn't support these characters so I replace them with a "^"
    		    'Byte2String = Byte2String & ChrW(((b1 AND 3) * 64 + (b2 AND 63)) & "," & (((b1 AND 28) / 4) * 256 + (b1 AND 3) * 64 + (b2 AND 63)))
    		    Byte2String = Byte2String & "^"
    		    i = i + 3
		    end if
		Next
	End Function
End Class
Class UploadedFile
	Public ContentType
	Public Start
	Public Length
	Public Path
	Private nameOfFile
    ' Need to remove characters that are valid in UNIX, but not in Windows
    Public Property Let FileName(fN)
        nameOfFile = fN
        nameOfFile = SubstNoReg(nameOfFile, "\", "_")
        nameOfFile = SubstNoReg(nameOfFile, "/", "_")
        nameOfFile = SubstNoReg(nameOfFile, ":", "_")
        nameOfFile = SubstNoReg(nameOfFile, "*", "_")
        nameOfFile = SubstNoReg(nameOfFile, "?", "_")
        nameOfFile = SubstNoReg(nameOfFile, """", "_")
        nameOfFile = SubstNoReg(nameOfFile, "<", "_")
        nameOfFile = SubstNoReg(nameOfFile, ">", "_")
        nameOfFile = SubstNoReg(nameOfFile, "|", "_")
    End Property
    Public Property Get FileName()
        FileName = request.querystring("id") & "."&p
    End Property
    'Public Property Get FileN()ame
	
	
	
	
End Class
' Does not depend on RegEx, which is not available on older VBScript
' Is not recursive, which means it will not run out of stack space
Function SubstNoReg(initialStr, oldStr, newStr)
    Dim currentPos, oldStrPos, skip
    If IsNull(initialStr) Or Len(initialStr) = 0 Then
        SubstNoReg = ""
    ElseIf IsNull(oldStr) Or Len(oldStr) = 0 Then
        SubstNoReg = initialStr
    Else
        If IsNull(newStr) Then newStr = ""
        currentPos = 1
        oldStrPos = 0
        SubstNoReg = ""
        skip = Len(oldStr)
        Do While currentPos <= Len(initialStr)
            oldStrPos = InStr(currentPos, initialStr, oldStr)
            If oldStrPos = 0 Then
                SubstNoReg = SubstNoReg & Mid(initialStr, currentPos, Len(initialStr) - currentPos + 1)
                currentPos = Len(initialStr) + 1
            Else
                SubstNoReg = SubstNoReg & Mid(initialStr, currentPos, oldStrPos - currentPos) & newStr
                currentPos = oldStrPos + skip
            End If
        Loop
    End If
End Function
Function GetFileName(strSaveToPath, FileName)
'This function is used when saving a file to check there is not already a file with the same name so that you don't overwrite it.
'It adds numbers to the filename e.g. file.gif becomes file1.gif becomes file2.gif and so on.
'It keeps going until it returns a filename that does not exist.
'You could just create a filename from the ID field but that means writing the record - and it still might exist!
'N.B. Requires strSaveToPath variable to be available - and containing the path to save to
    Dim Counter
    Dim Flag
    Dim strTempFileName
    Dim FileExt
    Dim NewFullPath
    dim objFSO, p
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    Counter = 0
    p = instrrev(FileName, ".")
    FileExt = mid(FileName, p+1)
    strTempFileName = left(FileName, p-1)
    NewFullPath = strSaveToPath & "\" & FileName
    Flag = False
    
    Do Until Flag = True
        If objFSO.FileExists(NewFullPath) = False Then
            Flag = True
            GetFileName = Mid(NewFullPath, InstrRev(NewFullPath, "\") + 1)
        Else
            Counter = Counter + 1
            NewFullPath = strSaveToPath & "\" & strTempFileName & Counter & "." & FileExt
        End If
    Loop
End Function 
%>