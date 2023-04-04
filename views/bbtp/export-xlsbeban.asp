<!--#include file="../../init.asp"-->
<% 
  if session("PP4D") = false then
    Response.Redirect("index.asp")
  end if

  id = trim(Request.QueryString("id"))

  Response.ContentType = "application/vnd.ms-excel"
   Response.AddHeader "content-disposition", "filename=Beban Produksi "& left(id,2) &"-"& mid(id,3,3) &"/"& mid(id,6,4) &"/"& right(id,3)&" .xls"

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string
  

  ' header
  data_cmd.commandTExt = "SELECT dbo.GLB_M_Agen.AgenName,  dbo.DLK_T_BB_ProsesH.*, dbo.DLK_M_WebLogin.UserName FROM dbo.DLK_T_BB_ProsesH LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_BB_ProsesH.BP_UpdateID = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_BB_ProsesH.BP_AgenID = dbo.GLB_M_Agen.AgenID WHERE BP_ID = '"& id &"' AND BP_AktifYN = 'Y'"

  set data = data_cmd.execute

  ' detail data
  data_cmd.commandTExt = "SELECT dbo.DLK_T_BB_ProsesD.BP_ID, dbo.DLK_M_BebanBiaya.BN_Nama, dbo.DLK_T_BB_ProsesD.BP_Jumlah, dbo.DLK_T_BB_ProsesD.BP_Keterangan, dbo.DLK_M_WebLogin.UserName FROM dbo.DLK_T_BB_ProsesD LEFT OUTER JOIN dbo.DLK_M_BebanBiaya ON dbo.DLK_T_BB_ProsesD.BP_BNID = dbo.DLK_M_BebanBiaya.BN_ID LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_BB_ProsesD.BP_UpdateID = dbo.DLK_M_WebLogin.UserID WHERE LEFT(BP_ID,12) = '"& data("BP_ID") &"' ORDER BY BP_ID ASC"

  set detail = data_cmd.execute

%>
<style>
  td {
    border:1px solid black;
}
</style>

<table width="100%" style="font-family:calibri;">
  <tr>
    <th colspan="5" align="center">DETAIL BEBAN PROSES PRODUKSI</th>
  </tr>
  <tr>
    <th colspan="5"  align="center"><%= left(id,2) &"-"& mid(id,3,3) &"/"& mid(id,6,4) &"/"& right(id,3)%></th>
  </tr>
  <tr>
    <td colspan="5"  align="center">&nbsp</td>
  </tr>
  <tr>
    <td colspan="2" style="border: 1px solid black;">
      <label>Cabang / Agen</label>
    </td>
    <td class="col-lg-4 mb-3">
      : <%= data("AgenName") %>
    </td>
    <td>
      <label for="pdhid" class="col-form-label">No Produksi</label>
    </td>
    <td class="col-lg-4 mb-3">
      : <%= left(data("BP_PDHID"),2) %>-<%= mid(data("BP_PDHID"),3,3) %>/<%= mid(data("BP_PDHID"),6,4) %>/<%= right(data("BP_PDHID"),4)  %>
    </td>
  </tr>
   <tr>
    <td colspan="2">
      <label >Tanggal</label>
    </td>
    <td>
      : <%= Cdate(data("BP_Date")) %>
    </td>
    <td>
      <label >updateid</label>
    </td>
    <td>
      : <%= data("username") %>
    </td>
  </tr>
  <tr>
    <td colspan="2">
      <label>Keterangan</label>
    </td>
    <td colspan="3">
      : <%= data("BP_Keterangan") %>
    </td>
  </tr>

  <tr>
    <th style="background-color:#5a6eaf;color:#FFF;">No</th>
    <th style="background-color:#5a6eaf;color:#FFF;">Nama Beban</th>
    <th style="background-color:#5a6eaf;color:#FFF;">Jumlah</th>
    <th style="background-color:#5a6eaf;color:#FFF;">Update ID</th>
    <th style="background-color:#5a6eaf;color:#FFF;">Keterangan</th>
  </tr>
  <% 
    no = 0
    do while not detail.eof 
    no = no + 1
    %>
    <tr>
      <td><%= no %></td>
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
</table>
