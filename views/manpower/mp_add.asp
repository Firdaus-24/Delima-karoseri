<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_manpower.asp"-->
<% 
  ' if session("ENG5A") = false then
  '   Response.Redirect("index.asp")
  ' end if

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string
  ' agen data
  data_cmd.commandText = "SELECT dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID FROM            dbo.DLK_T_ProduksiH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_ProduksiH.PDH_AgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_ProduksiH.PDH_AktifYN = 'Y') AND (dbo.DLK_T_ProduksiH.PDH_Approve2 = 'Y') AND (dbo.DLK_T_ProduksiH.PDH_Approve1 = 'Y') GROUP BY dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID ORDER BY dbo.GLB_M_Agen.AgenName"

  set dagen = data_cmd.execute
  
  call header("From ManPower")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-sm-12 text-center mt-3 mb-3">
      <h3>TAMBAH DATA MANPOWER</h3>
    </div>
  </div>
  <form action="mp_add.asp" method="post" onsubmit="validasiForm(this,event,'Data Transaksi Manpower','warning')">
    <div class="row p-2">
      <div class="col-sm-4 mb-3">
        <label>Cabang / Agen :</label>
        <select class="form-select" aria-label="Default select example" name="agen" id="dagen" onchange="getNoProd(this.value)" required>
          <option value="">Pilih</option>
          <% do while not dagen.eof %>
          <option value="<%= dagen("agenID") %>"><%= dagen("agenName") %></option>
          <% 
          dagen.movenext
          loop
          %>
        </select>
      </div>
      <div class="col-sm-4 mb-3">
        <label>Produksi :</label>
        <select class="form-select" aria-label="Default select example" name="produksi" id="produksimp" required>
          <option value="" disabled>Pilih cabang dulu</option>
        </select>
      </div>
      <div class="col-sm-4 mb-3">
        <label>Tanggal :</label>
        <input name="tgl" id="tgl" type="text" class="form-control" value="<%= date() %>" onfocus="(this.type='date')" required>
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
<script>
function getNoProd(cabang){
  $.post( "getNoProduksi.asp", { cabang }).done(function( data ) {
    $("#produksimp").html(data)
  });
  
}
</script>
<% 
  If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
    call ManpowerH()
  end if
  call footer()
%>