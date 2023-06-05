<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_pdi.asp"-->
<% 
  if session("MQ3A") = false then
    Response.Redirect("index.asp")
  end if

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  call header("Form PDI")

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
      <h3>FORM PRE DELIVERY INSPECTION</h3>
    </div>
  </div>
  <form action="pdi_add.asp" method="post" onsubmit="validasiForm(this,event,'APA ANDA YAKIN??','warning')">
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="cabangPdi" class="col-form-label">Cabang / Agen</label>
    </div>
    <div class="col-lg-4 mb-3">
      <select class="form-select" aria-label="Default select example" id="cabangPdi" name="cabang" required>
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
      <label for="divisi" class="col-form-label">Divisi</label>
    </div>
    <div class="col-lg-4 mb-3">
      <select class="form-select" aria-label="Default select example" id="divisiPdi" name="divisi" onchange="getDepartement(this.value)" required>
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
    <div class="col-lg-4 mb-3 pdiDepartement">
      <select class="form-select" aria-label="Default select example" id="depPdi" name="deppdi">
        <option value="" readonly disabled>Pilih Divisi dahulu</option>
      </select>
    </div>
  </div>

  <div class="row align-items-center">
     <div class="col-lg-2 mb-3">
        <label for="pdiprod" class="col-form-label">No.Produksi</label>
    </div>
    <div class="col-lg-4 mb-3 pdiprodlama">
      <select class="form-select" aria-label="Default select example" name="pdiprod" id="pdiprod"> 
        <option value="" readonly disabled>Pilih Cabang dahulu</option>
      </select>
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
    call tambahPDI()
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