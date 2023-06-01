<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_suratjalan.asp"-->
<% 
  if session("ENG8A") = false then
    Response.Redirect("index.asp")
  end if

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' agen data
  data_cmd.commandText = "SELECT AgenID, AgenName FROM GLB_M_Agen WHERE AgenAktifYN = 'Y' ORDER BY agenname ASC"

  set dcabang = data_cmd.execute

  ' csutomer data
  data_cmd.commandText = "SELECT custID, CustNama FROM DLK_T_UnitCustomerH LEFT OUTER JOIN DLK_M_Customer ON DLK_T_UnitCustomerH.TFK_CustID = DLK_M_Customer.custid WHERE TFK_AktifYN = 'Y' GROUP BY custID, CustNama ORDER BY custnama ASC"

  set dcust = data_cmd.execute

  call header("From Surat jalan")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-sm-12 text-center mt-3 mb-3">
      <h3>TAMBAH SURAT JALAN</h3>
    </div>
  </div>
  <form action="sj_add.asp" method="post" onsubmit="validasiForm(this,event,'Surat Jalan','warning')">
    <div class="row p-2">
      <div class="col-sm-4 mb-3">
        <label>Cabang :</label>
        <select class="form-select" aria-label="Default select example" name="cabang" id="cabang" required>
          <option value="">Pilih</option>
          <% do while not dcabang.eof %>
          <option value="<%= dcabang("agenid") %>"><%= dcabang("agenName") %></option>
          <% 
          dcabang.movenext
          loop
          %>
        </select>
      </div>
      <div class="col-sm-4 mb-3">
        <label>Customer</label>
        <select class="form-select" aria-label="Default select example" name="cust" id="cust" required>
          <option value="">Pilih</option>
          <% do while not dcust.eof %>
          <option value="<%= dcust("custid") %>"><%= dcust("custnama") %></option>
          <% 
          dcust.movenext
          loop
          %>
        </select>
      </div>
      <div class="col-sm-4 mb-3">
        <label>Tanggal :</label>
        <input name="tgl" id="tgl" type="date" class="form-control" required>
      </div>
    </div>
    <div class="row p-2">
      <div class="col-sm-12 mb-3">
        <label>Keterangan :</label>
        <input name="keterangan" id="keterangan" type="text" class="form-control" maxlength="50" autocomplete="off" required>
      </div>
    </div>
    <div class="row">
        <div class="col-sm-12 text-center mt-3 mb-3">
          <button type="button" onclick="window.location.href='index.asp'" class="btn btn-danger">Kembali</button>
          <button type="submit" class="btn btn-primary">Save</button>
        </div>
    </div>
  </form>
   <hr style="border-top: 1px dotted red;">
   <footer style="font-size: 10px; text-align: center;">
      <p style="margin:0;padding:0;"> 		
         PT.DELIMA KAROSERI INDONESIA
      </p>
      <p style="text-transform: capitalize; color: #000;margin:0;padding:0;">User Login : <%= session("username") %>  | Cabang : <%= session("cabang") %> | <a href="logout.asp" target="_self">Logout</a></p>
      <p style="margin:0;padding:0;">Copyright MuhamadFirdausIT Division©2022-2023S.O.No.Bns.Wo.Instv</p>
      <p style="margin:0;padding:0;"> V.1 Mobile Responsive 2022 | V.2 On Progres 2023</p>
   </footer>
</div>
<% 
  If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
    call tambahsurat()
  end if
  call footer()
%>