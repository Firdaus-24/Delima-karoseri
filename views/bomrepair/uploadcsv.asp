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
            <h3>UPLOAD DOCUMENT B.O.M REPAIR</h3>
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

        <button type="button" onclick="window.location.href='bmrd_add.asp?id=<%=id%>'" class="btn btn-danger mt-4">Kembali</button>
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
        data_cmd.commandText = "SELECT ('"&id&"' + Right('000' + Convert(varchar,Convert(int,(Right(isnull(Max(BMRDID),'000'),3)))+1),3)) as newid From DLK_T_BOMRepairD Where Left(BMRDID,13) = '"& id &"'"

        set p = data_cmd.execute

        ' ' get id barang by nama
        data_cmd.CommandText = "SELECT Brg_ID FROM DLK_M_Barang LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.kategoriid = DLK_M_Kategori.kategoriid LEFT OUTER JOIN DLK_M_Jenisbarang ON  DLK_M_Barang.jenisid = DLK_M_Jenisbarang.jenisid WHERE LOWER(Brg_Nama) = '"&trim(Lcase(arrRows(2)))&"' AND LOWER(DLK_M_Kategori.Kategorinama) = '"& trim(Lcase(arrRows(0))) &"' AND LOWER(DLK_M_Jenisbarang.jenisnama) = '"& trim(Lcase(arrRows(1))) &"'"
        ' Response.Write data_cmd.commandTExt & "<br>"

        set databarang = data_cmd.execute
        ' get id satuan by nama  
        data_cmd.CommandText = "SELECT sat_id FROM DLK_M_SatuanBarang WHERE UPPER(sat_Nama) = '"& ucase(arrRows(4)) &"'"
        set datasatuan = data_cmd.execute

        if not datasatuan.eof then
          satuan = datasatuan("sat_id")
        else
          satuan = ""
        end if

        if not databarang.eof then
          data_cmd.commandTExt = "SELECT * FROM DLK_T_BOMRepairD WHERE BmrdBrgID = '"& databarang("brg_id") &"' and LEFT(BmrdID,13) = '"& id &"'"
          set ckdata = data_cmd.execute

          if ckdata.eof then
            call query("INSERT INTO DLK_T_BOMRepairD (BmrdID,BmrdBrgID,BmrdQtysatuan,BmrdSatID,BmrdUpdateID,BmrdKeterangan) values ('"& p("newid") &"', '"& databarang("brg_id") &"', '"& replace(arrRows(3),",",".") &"', '"& satuan &"', '"& session("userid") &"', '"& arrRows(5) &"') ")
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