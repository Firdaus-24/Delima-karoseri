<!--#include file="../../init.asp"-->
<% 
  if session("MK1D") = false then
      Response.Redirect("index.asp")
   end if

  id = trim(Request.QueryString("id"))
  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandTExt = "SELECT dbo.DLK_T_OrJulH.*, dbo.DLK_M_Customer.custNama,  dbo.GLB_M_Agen.AgenName FROM dbo.DLK_T_OrJulH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_OrJulH.OJH_AgenID = dbo.GLB_M_Agen.AgenID  LEFT OUTER JOIN dbo.DLK_M_Customer ON dbo.DLK_T_OrJulH.OJH_CustID = dbo.DLK_M_Customer.custId WHERE (DLK_T_OrJulH.OJH_AktifYN = 'Y') AND (DLK_T_OrJulH.OJH_ID = '"& id &"')"

  set data = data_cmd.execute

  data_cmd.commandText = "SELECT dbo.DLK_T_OrJulD.OJD_OJHID, dbo.DLK_T_OrJulD.OJD_Item, dbo.DLK_T_OrJulD.OJD_Qtysatuan, dbo.DLK_T_OrJulD.OJD_JenisSat, dbo.DLK_T_OrJulD.OJD_Harga, dbo.DLK_T_OrJulD.OJD_Diskon, dbo.DLK_T_OrJulD.OJD_Keterangan, dbo.DLK_T_OrJulD.OJD_Updatetime, dbo.DLK_T_OrJulD.OJD_UpdateID, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama, DLK_M_WebLogin.username FROM dbo.DLK_M_JenisBarang INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_JenisBarang.JenisID = dbo.DLK_M_Barang.JenisID INNER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId RIGHT OUTER JOIN dbo.DLK_T_OrJulD ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_OrJulD.OJD_Item LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_OrJulD.OJD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN DLK_M_WebLogin ON DLK_T_OrjulD.OJD_Updateid = DLK_M_webLogin.userid WHERE LEFT(dbo.DLK_T_OrJulD.OJD_OJHID,13) = '"& data("OJH_ID") &"' ORDER BY dbo.DLK_T_OrjulD.OJD_OJHID" ' response.write data_cmd.commandText & "<br>"
  set ddata = data_cmd.execute

  Response.ContentType = "application/vnd.ms-excel"
  Response.AddHeader "content-disposition", "filename=SalesOrder "& left(id,2) &"-"& mid(id,3,3) &"/"& mid(id,6,4) &"/"& right(id,4)&" .xls"
%>
<table style="width:100%">
  <tr>
    <td align="center" colspan="9"><b>SALES ORDER</b></td>
  </tr>
  <tr>
    <td align="center" colspan="9"><b>
      <%= left(id,2) %>-<%= mid(id,3,3) %>/<%= mid(id,6,4) %>/<%= right(id,4)  %>
    </b></td>
  </tr>
  <tr>
    <td colspan="2">
      Cabang
    </td>
    <td colspan="2">
      : <%=data("AgenName") %>
    </td>
    <td>
    </td>
    <td colspan="2">
      Tanggal
    </td>
    <td colspan="2">
        : <%= cdate(data("OJH_date")) %>
    </td>
  </tr>
  <tr>
    <td colspan="2">
      Customer
    </td>
    <td colspan="2">
        : <%= data("custNama") %> 
    </td>
    <td>
    </td>
    <td colspan="2">
      Tanggal Jatuh Tempo
    </td>
    <td colspan="2">
        :<% if Cdate(data("OJH_JTDate")) <> Cdate("1/1/1900") then  %><%= Cdate(data("OJH_JTDate")) %><% end if %>
    </td>
  </tr>
  <tr>
    <td colspan="2">
      Lama Pengerjaan
    </td>
    <td colspan="2">
      : <%= data("OJH_TimeWork") %> 
    </td>
    <td>
    </td>
    <td colspan="2">
      Keterangan
    </td>
    <td colspan="2">
      : <%= data("OJH_Keterangan") %>
    </td>
  </tr> 
  <tr> 
    <td colspan="9">&nbsp</td> 
  </tr> 
</table>
<table style="width:100%">
  <tr>
    <th style="background-color: #0000a0;color:#fff;">ID</th>
    <th style="background-color: #0000a0;color:#fff;">Kode</th>
    <th style="background-color: #0000a0;color:#fff;">Item</th>
    <th style="background-color: #0000a0;color:#fff;">Quantity</th>
    <th style="background-color: #0000a0;color:#fff;">Satuan</th>
    <th style="background-color: #0000a0;color:#fff;">Diskon</th>
    <th style="background-color: #0000a0;color:#fff;">UpdateTime</th>
    <th style="background-color: #0000a0;color:#fff;">UpdateID</th>
    <th style="background-color: #0000a0;color:#fff;">Harga</th>
    <th style="background-color: #0000a0;color:#fff;">Total</th>
  </tr>
  <%
  grantotal = 0
  do while not ddata.eof
  ' cek diskon peritem
  if ddata("OJD_Diskon") <> 0  then
    dis = Round((ddata("OJD_Diskon")/100) * ddata("OJD_Harga"))
  else
    dis = 0
  end if

  ' total diskon peritem
  hargadiskon = ddata("OJD_Harga") - dis
  realharga = hargadiskon * ddata("OJD_QtySatuan")

  ' cek grand total harga
  grantotal = grantotal + realharga
  %>
    <tr>
      <th>
        <%= left(ddata("OJD_OJHID"),2) %>-<%= mid(ddata("OJD_OJHID"),3,3) %>/<%= mid(ddata("OJD_OJHID"),6,4) %>/<%= mid(ddata("OJD_OJHID"),10,4) %>/<%= right(ddata("OJD_OJHID"),3)  %>
      </th>
      <th align="left">
        <%= ddata("KategoriNama") &"-"& ddata("jenisNama") %>
      </th>
      <td align="left">
        <%= ddata("Brg_Nama") %>
      </td>
      <td>
        <%= ddata("OJD_Qtysatuan")%>
      </td>
      <td>
        <%= ddata("Sat_nama") %>
      </td>
      <td>
        <%= ddata("OJD_Diskon")%> %
      </td>
      <td>
        <%= ddata("OJD_updatetime")%>
      </td>
      <td>
        <%= ddata("username")%>
      </td>
      <td align="right">
        <%= replace(formatCurrency(ddata("OJD_Harga")),"$","")%>
      </td>
      <td align="right">
        <%= replace(formatCurrency(realharga),"$","")%>
      </td>
    </tr>
  <% 
  ddata.movenext
  loop

  if data("OJH_diskonall") <> 0 OR data("OJH_Diskonall") <> "" then
    diskonall = Round((data("OJH_Diskonall")/100) * grantotal)
  else
    diskonall = 0
  end if

  ' hitung ppn
  if data("OJH_ppn") <> 0 OR data("OJH_ppn") <> "" then
    ppn = Round((data("OJH_ppn")/100) * grantotal)
  else
    ppn = 0
  end if
  realgrantotal = (grantotal - diskonall) + ppn 
  %>
  <tr>
    <td colspan="8">
      Diskon 
    </td>
    <td align="right">
      <%= data("OJH_Diskonall") %>%
    </td>
    <td align="right">
      <%= replace(formatCurrency(diskonall),"$","") %> 
    </td>
  </tr>
  <tr>
    <td colspan="8">
      PPN
    </td>
    <td align="right">
      <%= data("OJH_PPN") %>%
    </td>
    <td align="right">
      <%= replace(formatCurrency(ppn),"$","") %>
    </td>
  </tr>
  <tr>
    <th colspan="9" align="left">Total Pembayaran</th>
    <th align="right"><%= replace(formatCurrency(realgrantotal),"$","") %></th>
  </tr>
</table>