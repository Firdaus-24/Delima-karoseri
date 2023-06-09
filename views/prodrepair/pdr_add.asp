<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_prodrepair.asp"-->
<% 
  if session("PP5A") = false then
    Response.Redirect("./")
  end if

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  call header("From Produksi Repair")

  ' agen / cabang
  data_cmd.commandTExt = "SELECT dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID FROM   dbo.DLK_T_IncRepairH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_IncRepairH.IRH_AgenID = dbo.GLB_M_Agen.AgenID GROUP BY dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID, dbo.DLK_T_IncRepairH.IRH_AktifYN HAVING (dbo.DLK_T_IncRepairH.IRH_AktifYN = 'Y') ORDER BY AgenNAme ASC"

  set agen = data_cmd.execute

%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
  <div class="row">
    <div class="col-lg-12 mb-3 mt-3 text-center">
      <h3>FORM PRODUKSI REPAIR</h3>
    </div>
  </div>
  <form action="pdr_add.asp" method="post" onsubmit="validasiForm(this,event,'APA ANDA YAKIN??','warning')">
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="cabangpdr" class="col-form-label">Cabang / Agen</label>
    </div>
    <div class="col-lg-4 mb-3">
      <select class="form-select" aria-label="Default select example" id="cabangpdr" name="cabang" required>
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
      <label for="startdate" class="col-form-label">Start Date</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="date" id="startdate" name="startdate" class="form-control" required>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="enddate" class="col-form-label">End Date</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="date" id="enddate" name="enddate" class="form-control" required>
    </div>
  </div>
  <div class="row align-items-center">
     <div class="col-lg-2 mb-3">
        <label for="irhidrepair" class="col-form-label">No.Incomming Unit</label>
    </div>
    <div class="col-lg-4 mb-3">
      <select class="form-select" aria-label="Default select example" name="irhidrepair" id="irhidrepair" required> 
        <option value="" readonly disabled>Pilih Cabang dahulu</option>
      </select>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="brandpdr" class="col-form-label">Brand</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="hidden" id="tfkidpdr" name="tfkid" class="form-control" autocomplete="off" required readonly>
      <input type="hidden" id="brandidpdr" name="brand" class="form-control" autocomplete="off" required readonly>
      <input type="text" id="brandnamepdr" name="brandname" class="form-control" autocomplete="off" required readonly>
    </div>
  </div>
  <div class='row'>
    <div class="col-lg-2 mb-3">
      <label for="typepdr" class="col-form-label">Type</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="typepdr" name="typepdr" class="form-control" autocomplete="off" required readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="nopolpdr" class="col-form-label">No.polisi</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="nopolpdr" name="nopol" class="form-control" autocomplete="off" required readonly>
    </div>
  </div>  
  <div class='row'>
    <div class="col-lg-2 mb-3">
      <label for="nomesin" class="col-form-label">No.Mesin</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="nomesinpdr" name="nomesin" class="form-control" autocomplete="off" required readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="rangkapdr" class="col-form-label">No.Rangka</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="rangkapdr" name="rangka" class="form-control" autocomplete="off" required readonly>
    </div>
  </div>  
  <div class='row'>
    <div class="col-lg-2 mb-3">
      <label for="warna" class="col-form-label">Color</label>
    </div>
    <div class="col-lg-10 mb-3">
      <input type="text" id="warnapdr" name="warna" class="form-control" autocomplete="off" required readonly>
    </div>
  </div>  
  <div class="row">
    <div class="col-lg-12 text-center">
      <a href="./" type="button" class="btn btn-danger">Kembali</a>
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