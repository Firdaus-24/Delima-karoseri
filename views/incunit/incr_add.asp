<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_incomingunitrepair.asp"-->
<% 
  if (session("MQ4A") = false  OR session("MQ4A") = "") AND (session("MQ4B") = false OR session("MQ4B") = "") then
    Response.Redirect("./")
  end if

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT AgenID, AgenName FROM MKT_T_OrJulRepairH LEFT OUTER JOIN GLB_M_Agen ON MKT_T_OrJulRepairH.ORH_AgenID = GLB_M_Agen.Agenid WHERE MKT_T_OrJulRepairH.ORH_aktifYN = 'Y' GROUP BY AgenID, AgenName ORDER BY AgenNAme"
  set dataagen = data_cmd.execute

  call header("Form Incomming Unit") 
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-sm-12 mt-3 mb-3 text-center">
      <h3>FORM INCOMMING UNIT INSPECTION</h3>
    </div>
  </div>
  <form action="incr_add.asp" method="post" onsubmit="validasiForm(this,event,'INCOMMING UNIT CUSTOMER','warning')">
    <div class="row align-items-center">
      <div class="col-lg-2 mb-2">
        <label for="tgl" class="col-form-label">Tanggal</label>
      </div>
      <div class="col-lg-4 mb-2">
        <input type="text" id="tgl" name="tgl" value="<%= date %>" class="form-control" onfocus="(this.type='date')" required>
      </div>
      <div class="col-lg-2 mb-2">
        <label for="salesorder" class="col-form-label">Cabang</label>
      </div>
      <div class="col-lg-4 mb-2">
        <select class="form-select" aria-label="Default select example" id="cabang-incr" name="cabang" onchange="getPenerimaanUnitByCabang(this.value)" required>
          <option value="">Pilih</option>
          <% do while not dataagen.eof %>
            <option value="<%= dataagen("AgenID") %>"><%= dataagen("AgenName") %></option>
          <% 
          dataagen.movenext
          loop
          %>
        </select>
      </div>
    </div>
    <div class="row contentTblIncr" style="display:none; border:1px solid black;margin-top:20px;margin-bottom:20px">
      <div class="col-lg-12 mb-3 mt-3 overflow-auto contentTblIncr1" style="height: 15rem; ">
      
      </div>
    </div>
    <div class="row align-items-center">
      <div class="col-lg-2 mb-2">
        <label for="tfkid" class="col-form-label">No.Penerimaan Unit</label>
      </div>
      <div class="col-lg-4 mb-2">
        <input type="text" id="tfkid-incr" name="tfkid" class="form-control" required readonly>
      </div>
      <div class="col-lg-2 mb-2">
        <label for="customer" class="col-form-label">Customer</label>
      </div>
      <div class="col-lg-4 mb-2">
        <input type="hidden" id="custid" name="custid" class="form-control" readonly>
        <input type="text" id="customer-incomingunit" name="customer" class="form-control" required readonly>
      </div>
    </div>
    <div class="row align-items-center">
      <div class="col-lg-2 mb-2">
        <label for="startdate" class="col-form-label">Start Date</label>
      </div>
      <div class="col-lg-4 mb-2">
        <input type="date" id="startdate" name="startdate" class="form-control" required>
      </div>
      <div class="col-lg-2 mb-2">
        <label for="enddate" class="col-form-label">End Date</label>
      </div>
      <div class="col-lg-4 mb-2">
        <input type="date" id="enddate" name="enddate" class="form-control" required>
      </div>
      
    </div>
    <div class="row">
      <div class="col-lg-2 mb-2">
        <label for="keterangan" class="col-form-label">Keterangan</label>
      </div>
      <div class="col-lg-10 mb-2">
        <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" autocomplete="off">
      </div>
    </div>
    <div class="row">
      <div class="col-lg-12 mb-2 mt-3 text-center">
        <a href="./" type="button" class="btn btn-danger">Kembali</a>
        <button type="submit" class="btn btn-primary">Save</button>
      </div>
    </div>
  </form>
</div>
<% 
  if Request.ServerVariables("REQUEST_METHOD") = "POST" then
    call Tambah()
  end if
call footer() %>