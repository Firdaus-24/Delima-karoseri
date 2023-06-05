<!--#include file="../../functions/func_uploadpdf.asp"-->	
<% 
	dim id, responback
    id = trim(Request.QueryString("id"))
    responback = Request.ServerVariables("HTTP_REFERER")	
    call header("Upload Document")
%>
<!--#include file="../../navbar.asp"-->	
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<script>
function onSubmitForm(objForm) {
   var formDOMObj = document.frmSend;
   var arrExtensions=new Array("pdf");
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

</HEAD>

<BODY>
<div class="container">
    <div class='row'>
        <div class='col text-center'>
            <h3>UPLOAD DOCUMENT</h3>
        </div>
    </div>
    <div class="upload">
        <form name="frmSend" method="POST" enctype="multipart/form-data" action="uploadImage.asp?id=<%=request.querystring("id")%>&pathidh=<%=request.querystring("id")%>" onSubmit="return onSubmitForm(this);">   	<p style="margin-top: 0; margin-bottom: 0">&nbsp;</p>
        
        <p style="margin-top: 0; margin-bottom: 0"><b>File To Upload : </b>
        <input name="filter" type="file" size="20" accept="application/pdf" />
        <button type="submit" class="btn btn-primary" value="submit">UPLOAD</button>
        </p>
        </form> 
        <u><b>Ketentuan :</b></u><ul>
        <li>Pastikan nama faktur sama dengan id traksaksi yang terdaftar</li>
        <li>CONTOH : 0010821003.pdf</li>
        <li>Kami hanya menerima file dalam bentuk format file *.pdf</li>

        <button type="button" onclick="window.location.href='./'" class="btn btn-danger mt-4">Kembali</button>
        <img src="../../public/img/delimalogo.png">
    </div>
</div>

<%
        dim diagnostics
        if Request.ServerVariables("REQUEST_METHOD") <> "POST" then
            diagnostics = TestEnvironment()
            if diagnostics<>"" then
                response.write "<div style=""margin-left:20; margin-top:30; margin-right:30; margin-bottom:30;"">"
                response.write diagnostics
                response.write "<p>After you correct this problem, reload the page."
                response.write "</div>"
            else
                OutputForm()
            end if
        else
            call query("UPDATE DLK_T_InvPemH SET IPH_Image = '"& id &"' WHERE IPH_ID = '"& id &"'")

            OutputForm()
            response.write SaveFiles()
        end if
   call footer() %>