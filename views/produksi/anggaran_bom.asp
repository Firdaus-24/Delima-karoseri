<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_produksi.asp"-->
<% 
  if session("PP8A") = false then 
    Response.Redirect("./")
  end if

  id = trim(Request.QueryString("id"))

  set data =  Server.CreateObject ("ADODB.Command")
  data.ActiveConnection = mm_delima_string

  ' get header data produksi
  data.commandTExt = "SELECT DLK_T_ProduksiH.*, GLB_M_Agen.AgenName FROM DLK_T_ProduksiH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_ProduksiH.PDH_AgenID = GLB_M_Agen.AgenID WHERE PDH_ID = '"& id &"'"
  set datah = data.execute

  if datah.eof then
    Response.Redirect("./")
  end if
  
  ' get divisi
  data.commandText = "SELECT DivNama, DivID FROM HRD_M_Divisi WHERE DivAktifYN = 'Y' ORDER BY DivNama ASC"
  set pdivisi = data.execute    

  ' cek kebutuhan
  data.commandText = "SELECT K_ID,K_Name FROM DLK_M_Kebutuhan WHERE K_AktifYN = 'Y' AND K_id = 1 ORDER BY K_ID ASC"

  set ckkebutuhan = data.execute

  call header("From Permintaan Anggaran") 
%>

<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-lg-12 mt-3 text-center">
      <h3>FORM PERMINTAAN ANGGARAN PRODUKSI</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 text-center labelId">
      <h3><%= left(id,2) %>-<%= mid(id,3,3) %>/<%= mid(id,6,4) %>/<%= right(id,4)  %></h3>
    </div>
  </div>
  <form action="anggaran_bom.asp?id=<%=id%>" method="post" id="formAnggaranH" onsubmit="validasiForm(this,event,'Permintaan Anggaran Produksi','warning')">
    <input type="hidden" id="anggaranpdhid" class="form-control" name="pdhid" value="<%= id %>" required>
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
        <input type="hidden" id="agenanggaranbom" class="form-control" name="agen" value="<%= datah("pdh_agenid") %>" required>
        <input type="text" id="agenanggaranbom" class="form-control" name="agenname" value="<%= datah("agenname") %>" readonly>
      </div>
    </div>
    <div class="row">
        <div class="col-sm-2">
            <label for="divisi" class="col-form-label">Divisi</label>
        </div>
        <div class="col-sm-4 mb-3">
            <select class="form-select" aria-label="Default select example" name="divisi" id="pbdivisi" required> 
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
        <div class="col-sm-4  deplama">
            <select class="form-select" aria-label="Default select example" name="ldep" id="ldep" > 
                <option value="" readonly disabled>Pilih Divisi dahulu</option>
            </select>
        </div>
        <div class="col-sm-4  depbaru">
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
            <input type="text" id="keterangan" class="form-control" name="keterangan" maxlength="50" autocomplete="off" required>
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
  call reqAnggaran()
end if
call footer() 
%>