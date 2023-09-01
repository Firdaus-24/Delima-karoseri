<!--#include file="../../functions/func_uploadcsv.asp"-->
<%
  dim id, responback
  id = trim(Request.QueryString("id"))
  responback = Request.ServerVariables("HTTP_REFERER")	

  set data_cmd = Server.CreateObject("ADODB.Command")
  data_cmd.activeConnection = mm_delima_string

  call header("upload csv")
%>

<!--#include file="../../navbar.asp"-->
<script>
function onSubmitForm(objForm) {
  var formDOMObj = document.frmSend;
  var arrExtensions=new Array("csv");
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
		alert("Only upload Photo with CSV extension only","File Upload Failed");
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
            <h3>UPLOAD DOCUMENT B.O.M</h3>
        </div>
    </div>
    <div class="upload">
        <form method="POST" enctype="multipart/form-data" action="uploadcsv.asp?id=<%=request.querystring("id")%>" onSubmit="return onSubmitForm(this);">   	<p style="margin-top: 0; margin-bottom: 0">&nbsp;</p>
        
        <p style="margin-top: 0; margin-bottom: 0"><b>File To Upload : </b>
        <input name="filter" type="file" size="20"  accept=".csv, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel"  />
        <button type="submit" class="btn btn-primary" value="submit">UPLOAD</button>
        </p>
        </form> 
        <u><b>Ketentuan : </b></u><ul>
        <li>Pastikan nomor B.O.M sudah terdaftar dan aktif</li>
        <li>Kami hanya menerima file dalam bentuk format file *.csv dengan detain CSV (comma delimited) </li>
        <li>Pastikan Nama barang sudah terdaftar di master barang</li>

        <button type="button" onclick="window.location.href='bom_u.asp?id=<%=id%>'" class="btn btn-danger mt-4">Kembali</button>
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
    OutputForm()
    response.write SaveFiles()
    Dim objFSO,oInStream,sRows,arrRows , ckdata
    Dim p, databarang, datasatuan, satuan    
      
    '*** Create Object ***'  
    Set objFSO = CreateObject("Scripting.FileSystemObject")  
      
    '*** Check Exist Files ***'  
    If Not objFSO.FileExists(pathCsv & id & ".CSV") Then  
       OutputForm()  
    Else  
      '*** Open Files ***'  
      Set oInStream = objFSO.OpenTextFile(pathCsv & id & ".CSV",1,False) 
      Do Until oInStream.AtEndOfStream  
        sRows = oInStream.readLine  
        arrRows = Split(sRows,";")  

        ' cek nomor buntut
        data_cmd.commandText = "Select ('"& trim(Request.QueryString("id")) &"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(BMDBMID),'000'),3)))+1),3)) as newid From DLK_M_Bomd Where Left(BMDBMID,12) = '"& trim(Request.QueryString("id")) &"'"

        set p = data_cmd.execute

        ' get id barang by nama
        data_cmd.CommandText = "SELECT Brg_ID FROM DLK_M_Barang WHERE LOWER(Brg_Nama) = '"&trim(Lcase(arrRows(0)))&"'"
        ' Response.Write data_cmd.commandTExt & "<br>"
        set databarang = data_cmd.execute
        ' get id satuan by nama
        data_cmd.CommandText = "SELECT sat_id FROM DLK_M_SatuanBarang WHERE UPPER(sat_Nama) = '"& ucase(arrRows(2)) &"'"
        set datasatuan = data_cmd.execute

        if not datasatuan.eof then
          satuan = datasatuan("sat_id")
        else
          satuan = ""
        end if

        if not databarang.eof then
          data_cmd.commandTExt = "SELECT * FROM DLK_M_Bomd WHERE BMDItem = '"& databarang("brg_id") &"' and LEFT(BMDBMID,12) = '"& id &"'"
          set ckdata = data_cmd.execute

          if ckdata.eof then
            call query("INSERT INTO DLK_M_BOMD (BMDBMID,BMDItem,BMDQtty,BMDJenisSat) values ('"& p("newid") &"', '"& databarang("brg_id") &"', '"& replace(arrRows(1),",",".") &"', '"& satuan &"') ")
          end if
        end if
        
      Loop  
      oInStream.Close()  
      Set oInStream = Nothing  
    end if
    
  end if
  dim fs
  Set fs=server.CreateObject("Scripting.FileSystemObject")
  if fs.FileExists(pathCsv& Request.QueryString("id") & ".CSV") then
    fs.DeleteFile(pathCsv& Request.QueryString("id") & ".CSV")
  end if
  
  set fs=nothing
   call footer() 
%>