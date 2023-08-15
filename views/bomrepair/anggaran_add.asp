<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_bomrepair.asp"-->
<% 
  if session("PP7A") = false then 
    Response.Redirect("./")
  end if

  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.Agenid, dbo.DLK_T_BOMRepairH.bmrid, dbo.DLK_T_BOMRepairH.bmrpdrid FROM  dbo.DLK_T_BOMRepairH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_BOMRepairH.BmrAgenId = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_BOMRepairH.BmrID = '"& id &"') AND (dbo.DLK_T_BOMRepairH.BmrAktifYN = 'Y')"
  set data = data_cmd.execute

  if data.eof then
    Response.Redirect("./")
  end if
  
  ' get divisi
  data_cmd.commandText = "SELECT DivNama, DivID FROM HRD_M_Divisi WHERE DivAktifYN = 'Y' ORDER BY DivNama ASC"
  set pdivisi = data_cmd.execute    

  ' cek kebutuhan
  data_cmd.commandText = "SELECT K_ID,K_Name FROM DLK_M_Kebutuhan WHERE K_AktifYN = 'Y' and k_id = 1 ORDER BY K_ID ASC"

  set ckkebutuhan = data_cmd.execute

  call header("From Permintaan Anggaran") 
%>

<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-lg-12 mt-3 text-center">
      <h3>FORM PERMINTAAN ANGGARAN B.O.M REPAIR</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 text-center labelId">
      <h3><%=left(data("BMRID"),3)&"-"&MID(data("BMRID"),4,3)&"/"&MID(data("BMRID"),7,4)&"/"&right(data("BMRID"),3)%></h3>
    </div>
  </div>
  <form action="anggaran_add.asp?id=<%= data("bmrid") %>" method="post" id="formAnggaranH" onsubmit="validasiForm(this,event,'Permintaan Anggaran','warning')">
    <input type="hidden" id="bmrid" class="form-control" name="bmrid" value="<%= data("bmrid") %>" required>
    <input type="hidden" id="bmrpdrid" class="form-control" name="bmrpdrid" value="<%= data("bmrpdrid") %>" required>
    <div class="row">
      <div class="col-sm-2">
        <label for="tgl" class="col-form-label">Tanggal</label>
      </div>
      <div class="col-sm-4 mb-3">
        <input type="text" id="tgl" class="form-control" name="tgl" value="<%= Date() %>" onfocus="(this.type='date')" required>
      </div>
      <div class="col-sm-2">
        <label for="agen" class="col-form-label">Cabang / Agen</label>
      </div>
      <div class="col-sm-4 mb-3">
        <select class="form-select" aria-label="Default select example" name="agen" id="agenpb" readonly> 
          <option value="<%=data("Agenid")%>"><%=data("agenname")%></option>
        </select>
      </div>
    </div>
    <div class="row">
      <div class="col-sm-2">
        <label for="divisi" class="col-form-label">Divisi</label>
      </div>
      <div class="col-sm-4 mb-3">
        <select class="form-select" aria-label="Default select example" name="divisi" id="bomrepairdivisi" required> 
          <option value="">Pilih</option>
          <% do while not pdivisi.eof %>
          <option value="<%= pdivisi("divId") %>"><%= pdivisi("divNama") %></option>
          <%  
          pdivisi.movenext
          loop
          %>
        </select>
      </div>
      <div class="col-sm-2">
        <label for="departement" class="col-form-label">Departement</label>
      </div>
      <div class="col-sm-4  deplamarepair">
        <select class="form-select" aria-label="Default select example" name="ldep" id="ldep" > 
          <option value="" readonly disabled>Pilih Divisi dahulu</option>
        </select>
      </div>
      <div class="col-sm-4  depbarurepair">
          <!-- kontent departement -->
      </div>
    </div>
    <div class="row">
      <div class="col-sm-2">
        <label for="kebutuhan" class="col-form-label">Kebutuhan</label>
      </div>
      <div class="col-sm-4 mb-3">
        <select class="form-select" aria-label="Default select example" name="kebutuhan" id="kebutuhan" required> 
          <option value="<%= ckkebutuhan("K_ID") %>"><%= ckkebutuhan("K_Name") %></option>
        </select>
      </div>
      <div class="col-sm-2">
        <label for="keterangan" class="col-form-label">Keterangan</label>
      </div>
      <div class="col-sm-4 mb-3">
        <input type="text" id="keterangan" class="form-control" name="keterangan" maxlength="50" autocomplete="off">
      </div>
    </div>
     
    <!-- end button -->
    <div class="row">
      <div class="col-lg-12 text-center">
        <button type="button" onclick="window.location.href='./'" class="btn btn-danger">Kembali</button>
        <button type="submit" class="btn btn-primary">Tambah</button>
      </div>
    </div>
  </form>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
  call anggaran()
end if
call footer() 
%>