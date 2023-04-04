<!--#include file="../../init.asp"-->
<% 
  ' if session("PR4A") = false then
  '   Response.Redirect("index.asp")
  ' end if

  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string
  

  ' header
  data_cmd.commandTExt = "SELECT dbo.GLB_M_Agen.AgenName,  dbo.DLK_T_BB_ProsesH.*, dbo.DLK_M_WebLogin.UserName FROM dbo.DLK_T_BB_ProsesH LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_BB_ProsesH.BP_UpdateID = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_BB_ProsesH.BP_AgenID = dbo.GLB_M_Agen.AgenID WHERE BP_ID = '"& id &"' AND BP_AktifYN = 'Y'"

  set data = data_cmd.execute

  ' detail data
  data_cmd.commandTExt = "SELECT dbo.DLK_T_BB_ProsesD.BP_ID, dbo.DLK_M_BebanBiaya.BN_Nama, dbo.DLK_T_BB_ProsesD.BP_Jumlah, dbo.DLK_T_BB_ProsesD.BP_Keterangan, dbo.DLK_M_WebLogin.UserName FROM dbo.DLK_T_BB_ProsesD LEFT OUTER JOIN dbo.DLK_M_BebanBiaya ON dbo.DLK_T_BB_ProsesD.BP_BNID = dbo.DLK_M_BebanBiaya.BN_ID LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_BB_ProsesD.BP_UpdateID = dbo.DLK_M_WebLogin.UserID WHERE LEFT(BP_ID,12) = '"& data("BP_ID") &"' ORDER BY BP_ID ASC"

  set detail = data_cmd.execute

  call header("Detail Beban Proses")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
  <div class="row">
    <div class="col-lg-12 mt-3 text-center">
      <h3>DETAIL BEBAN PROSES PRODUKSI</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 text-center labelId">
      <h3><%= left(id,2) &"-"& mid(id,3,3) &"/"& mid(id,6,4) &"/"& right(id,3)%></h3>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="fakturagen" class="col-form-label">Cabang / Agen</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="cabang" name="cabang" class="form-control" value="<%= data("AgenName") %>" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="pdhid" class="col-form-label">No Produksi</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="pdhid" name="pdhid" class="form-control" value="<%= left(data("BP_PDHID"),2) %>-<%= mid(data("BP_PDHID"),3,3) %>/<%= mid(data("BP_PDHID"),6,4) %>/<%= right(data("BP_PDHID"),4)  %>" readonly>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-3">
      <label for="tgl" class="col-form-label">Tanggal</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="tgl" name="tgl" class="form-control" value="<%= Cdate(data("BP_Date")) %>" readonly>
    </div>
    <div class="col-lg-2 mb-3">
      <label for="updateid" class="col-form-label">updateid</label>
    </div>
    <div class="col-lg-4 mb-3">
      <input type="text" id="updateid" name="updateid" class="form-control" value="<%= data("username") %>" autocomplete="off" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-2 mb-3">
      <label for="keterangan" class="col-form-label">Keterangan</label>
    </div>
    <div class="col-lg-10 mb-3">
      <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" value="<%= data("BP_Keterangan") %>" autocomplete="off" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 d-flex justify-content-between mb-3">
      <% if session("PP4D") = true then %>
      <button type="button" class="btn btn-secondary" onclick="window.location.href = 'export-xlsbeban.asp?id=<%=id%>'">Export</button>
      <% end if %>
      <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
    </div>
  </div>

  <div class="row">
    <div class="col-sm-12">
      <table class="table table-hover">
        <thead class="bg-secondary text-light">
          <tr>
            <th scope="col">No</th>
            <th scope="col">Nama Beban</th>
            <th scope="col">Jumlah</th>
            <th scope="col">Update ID</th>
            <th scope="col">Keterangan</th>
          </tr>
        </thead>
        <tbody>
          <% 
          no = 0
          do while not detail.eof 
          no = no + 1
          %>
          <tr>
            <th><%= no %></th>
            <td><%= detail("BN_Nama") %></td>
            <td><%= replace(formatCurrency(detail("BP_Jumlah")),"$","") %></td>
            <td><%= detail("username") %></td>
            <td><%= detail("BP_Keterangan") %></td>
          </tr>
          <% 
          Response.flush
          detail.movenext
          loop
          %>
        </tbody>
      </table>
    </div>

  </div>  

</div>  

<% 
  call footer()
%>
