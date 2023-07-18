<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_pdirepair.asp"-->
<% 
  if session("MQ5A") = false then
    Response.Redirect("./")
  end if

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  call header("Form PDI Repair")

  ' agen / cabang
  data_cmd.commandTExt = "SELECT AgenName, AgenID FROM GLB_M_Agen WHERE AgenAktifYN = 'Y' ORDER BY AgenNAme ASC"

  set agen = data_cmd.execute

  ' divisi
  data_cmd.commandTExt = "SELECT DivID, DIvNama FROM HRD_M_Divisi WHERE DivAktifYN = 'Y' ORDER BY DivNama ASC"
  set datadivisi = data_cmd.execute 

%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
  <div class="row">
    <div class="col-lg-12 mb-3 mt-3 text-center">
      <h3>FORM PRE DELIVERY INSPECTION REPAIR</h3>
    </div>
  </div>
  <form action="pdir_add.asp" method="post" onsubmit="validasiForm(this,event,'APA ANDA YAKIN??','warning')">
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="cabangPdirepair" class="col-form-label">Cabang / Agen</label>
    </div>
    <div class="col-lg-4 mb-3">
      <select class="form-select" aria-label="Default select example" id="cabangPdirepair" name="cabang" onchange="getPDIProRepair(this.value)" required>
        <option value="">Pilih</option>
        <% do while not agen.eof %>
        <option value="<%= agen("AgenID") %>"><%= agen("AgenName") %></option>
        <% 
        agen.movenext
        loop
        %>
      </select>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="tgl" class="col-form-label">Tanggal</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgl" name="tgl" class="form-control" value="<%= date() %>" onfocus="(this.type='date')" required>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="divisiPdiRepair" class="col-form-label">Divisi</label>
    </div>
    <div class="col-lg-4 mb-3">
      <select class="form-select" aria-label="Default select example" id="divisiPdiRepair" name="divisi" onchange="getDepPdiRepair(this.value)" required>
        <option value="">Pilih</option>
        <% do while not datadivisi.eof %>
        <option value="<%= datadivisi("divID") %>"><%= datadivisi("divNama") %></option>
        <% 
        datadivisi.movenext
        loop
        %>
      </select>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="departement" class="col-form-label">Departement</label>
    </div>
    <div class="col-lg-4 mb-3 pdiDepartementRepair">
      <select class="form-select" aria-label="Default select example" id="depPdi" name="deppdi">
        <option value="" readonly disabled>Pilih Divisi dahulu</option>
      </select>
    </div>
  </div>
  <div class="row align-items-center">
     <div class="col-lg-2 mb-3">
        <label for="pdiprodrepair" class="col-form-label">No.Produksi</label>
    </div>
    <div class="col-lg-4 mb-3">
       <select class="form-select pdiprodrepair" aria-label="Default select example" name="pdrid" id="pdridrepair" onchange="getDatailPdiProdRepair(this.value)" required> 
        <option value="" readonly disabled>Pilih Cabang dahulu</option>
      </select>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="brand" class="col-form-label">Brand</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="hidden" id="tfkidpdirepair" name="tfkid" class="form-control" autocomplete="off" readonly>
      <input type="hidden" id="irhidpdirepair" name="irhid" class="form-control" autocomplete="off" readonly>
      <input type="hidden" id="brandidpdirepair" name="brandid" class="form-control" autocomplete="off" readonly>
      <input type="text" id="brandname" name="brandname" class="form-control" autocomplete="off" readonly>
    </div>
  </div>
  <div class='row'>
    <div class="col-lg-2 mb-3">
      <label for="typepdirepair" class="col-form-label">Type</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="typepdirepair" name="typepdirepair" class="form-control" autocomplete="off" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="nopol" class="col-form-label">No.Polisi</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="nopolpdirepair" name="nopol" class="form-control" autocomplete="off" readonly>
    </div>
  </div>
  <div class='row'>
    <div class="col-lg-2 mb-3">
      <label for="ranka" class="col-form-label">No.Rangka</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="rankapdirepair" name="ranka" class="form-control" autocomplete="off" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="mesin" class="col-form-label">No.Mesin</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="mesinpdirepair" name="mesin" class="form-control" autocomplete="off" readonly>
    </div>
  </div>
  <div class='row'>
    <div class="col-lg-2 mb-3">
      <label for="warna" class="col-form-label">Color</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="warnapdirepair" name="warna" class="form-control" autocomplete="off" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="keterangan" class="col-form-label">Keterangan</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="100" autocomplete="off" required>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 text-center">
      <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
      <button type="submit" class="btn btn-primary">Save</button>
    </div>
  </div>
  </form>
  <hr style="border-top: 1px dotted red;">
   <footer style="font-size: 10px; text-align: center;">
      <p style="margin:0;padding:0;"> 		
         PT.DELIMA KAROSERI INDONESIA
      </p>
      <p style="text-transform: capitalize; color: #000;margin:0;padding:0;">User Login : <%= session("username") %>  | Cabang : <%= session("cabang") %> | <a href="<%=url%>logout.asp" target="_self">Logout</a></p>
      <p style="margin:0;padding:0;">Copyright MuhamadFirdausIT Division©2022-2023S.O.No.Bns.Wo.Instv</p>
      <p style="margin:0;padding:0;"> V.1 Mobile Responsive 2022 | V.2 On Progres 2023</p>
   </footer>
</div>  
<% 
  if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call tambah()
  end if
  call footer()
%>

<script>
  const getDepartement = (id) => {
    let divisi = id
    if (divisi != ""){
      $.post("../../ajax/getDepartement.asp", { divisi }, function (data) {
        $(".pdiDepartement").html(data);
      })
    }else{
      $(".pdiDepartement").html(`<select class="form-select" aria-label="Default select example" id="depPdi" name="deppdi"><option value="" readonly disabled>Pilih Divisi dahulu</option></select>`)
    }
  }

</script>