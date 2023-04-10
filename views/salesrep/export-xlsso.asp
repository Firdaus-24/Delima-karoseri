<!--#include file="../../init.asp"-->
<% 
  if session("MK2D") = false then
  Response.Redirect("index.asp") 
  end if

  id = trim(Request.QueryString("id"))
  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandTExt = "SELECT dbo.MKT_T_OrJulRepairH.*, dbo.DLK_M_Customer.custNama,  dbo.GLB_M_Agen.AgenName, DLK_M_Weblogin.username FROM dbo.MKT_T_OrJulRepairH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.MKT_T_OrJulRepairH.ORH_AgenID = dbo.GLB_M_Agen.AgenID  LEFT OUTER JOIN dbo.DLK_M_Customer ON dbo.MKT_T_OrJulRepairH.ORH_CustID = dbo.DLK_M_Customer.custId LEFT OUTER JOIN DLK_M_WebLogin ON MKT_T_OrjulRepairH.ORH_Updateid = DLK_M_Weblogin.userid WHERE (MKT_T_OrJulRepairH.ORH_AktifYN = 'Y') AND (MKT_T_OrJulRepairH.ORH_ID = '"& id &"')"

  set data = data_cmd.execute

  data_cmd.commandText = "SELECT dbo.DLK_M_Class.ClassName, dbo.DLK_M_Brand.BrandName, dbo.MKT_T_OrjulRepairD.ORD_ID, dbo.MKT_T_OrjulRepairD.ORD_Qtysatuan, dbo.MKT_T_OrjulRepairD.ORD_Harga, dbo.MKT_T_OrjulRepairD.ORD_Diskon, dbo.MKT_T_OrjulRepairD.ORD_Keterangan, dbo.MKT_T_OrjulRepairD.ORD_UpdateId, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_WebLogin.UserName FROM dbo.MKT_T_OrjulRepairD LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.MKT_T_OrjulRepairD.ORD_UpdateId = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.MKT_T_OrjulRepairD.ORD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Brand ON dbo.MKT_T_OrjulRepairD.ORD_BrandID = dbo.DLK_M_Brand.BrandID LEFT OUTER JOIN dbo.DLK_M_Class ON dbo.MKT_T_OrjulRepairD.ORD_ClassID = dbo.DLK_M_Class.ClassID WHERE LEFT(dbo.MKT_T_OrJulRepairD.ORD_ID,13) = '"& data("ORH_ID") &"' ORDER BY dbo.MKT_T_OrjulRepairD.ORD_ID" ' response.write data_cmd.commandText & "<br>"
  set ddata = data_cmd.execute

  Response.ContentType = "application/vnd.ms-excel"
  Response.AddHeader "content-disposition", "filename=SalesOrderRepair "& left(id,2) &"-"& mid(id,3,3) &"/"& mid(id,6,4) &"/"& right(id,4)&" .xls"
%>
<table width="100%">
  <tr>
    <th colspan="8" style="text-align:center">DETAIL SALES ORDER REPAIR</th>
  </tr>
  <tr>
    <th colspan="8" style="text-align:center">
      <%= left(id,2) %>-<%= mid(id,3,3) %>/<%= mid(id,6,4) %>/<%= right(id,4)  %>
    </th>
  </tr>
  <tr>
    <td colspan="8">&nbsp</td>
  </tr>

  <tr>
    <td colspan="2">Cabang / Agen</td>
    <td colspan="2">: <%= data("agenName") %></td>
    <td colspan="2">Tanggal</td>
    <td colspan="2">: <%= cdate(data("ORH_Date")) %></td>
  </tr>
  <tr>
    <td colspan="2">Customer</td>
    <td colspan="2">: <%= data("custnama") %></td>
    <td colspan="2">Tanggal Jatuh Tempo</td>
    <td colspan="2">: 
      <% if Cdate(data("ORH_JTDate")) <> Cdate("1/1/1800") then%> <%= cdate(data("ORH_JTDate")) %> <% end if %>
    </td>
  </tr>
  <tr>
    <td colspan="2">Lama Pengerjaan</td>
    <td colspan="2">: <%= data("ORH_timeWork") %></td>
    <td colspan="2">Update Id</td>
    <td colspan="2">: <%= data("username") %></td>
  </tr>
  <tr>
    <td colspan="2">Keterangan</td>
    <td colspan="6">: <%= data("ORH_keterangan") %></td>
  </tr>
  <tr>
    <td colspan="8">&nbsp</td>
  </tr>
  <tr>
    <th  style="background-color: #0000ff;color:#fff;">ID</th>
    <th  style="background-color: #0000ff;color:#fff;">Class</th>
    <th  style="background-color: #0000ff;color:#fff;">Brand</th>
    <th  style="background-color: #0000ff;color:#fff;">Quantity</th>
    <th  style="background-color: #0000ff;color:#fff;">Satuan</th>
    <th  style="background-color: #0000ff;color:#fff;">Harga</th>
    <th  style="background-color: #0000ff;color:#fff;">Diskon</th>
    <th  style="background-color: #0000ff;color:#fff;">Total</th>
  </tr>
  <% 
  total = 0 
  diskonitem = 0
  hargadiskon = 0
  grantotal = 0
  do while not ddata.eof

  diskonitem = Round( (ddata("ORD_Diskon") / 100) *  ddata("ORD_Harga"))
  hargadiskon = ddata("ORD_Harga") - diskonitem
  total =  hargadiskon * cint(ddata("ORD_Qtysatuan"))

  grantotal = grantotal + total
  %>
    <tr>
      <th>
        <%= left(ddata("ORD_ID"),2) %>-<%= mid(ddata("ORD_ID"),3,3) %>/<%= mid(ddata("ORD_ID"),6,4) %>/<%= mid(ddata("ORD_ID"),10,4) %>/<%= right(ddata("ORD_ID"),3)  %>
      </th>
      <td>
        <%= ddata("className") %>
      </td>
      <td>
        <%= ddata("brandName") %>
      </td>
      <td>
        <%= ddata("ORD_Qtysatuan")%>
      </td>
      <td>
        <%= ddata("sat_Nama")%>
      </td>
      <td align="right">
        <%= replace(formatCurrency(ddata("ORD_Harga")),"$","")%>
      </td>
      <td align="right">
        <%= ddata("ORD_Diskon")%>%
      </td>
      <td align="right">
        <%= replace(formatCurrency(total),"$","")  %>
      </td>
    </tr>
  <% 
  ddata.movenext
  loop
  if data("ORH_DiskonAll") <> 0 OR data("ORH_DiskonAll") <> "" then
    diskonall = Round((data("ORH_DiskonAll")/100) * grantotal)
  else
    diskonall = 0
  end if

  ' hitung ppn
  if data("ORH_ppn") <> 0 OR data("ORH_ppn") <> "" then
    ppn = Round((data("ORH_ppn")/100) * grantotal)
  else
    ppn = 0
  end if
  realgrantotal = (grantotal - diskonall) + ppn 
  %>
  <tr>
    <td colspan="6">
      Diskon 
    </td>
    <td align="right">
      <%= data("ORH_Diskonall") %>%
    </td>
    <td align="right">
      <%= replace(formatCurrency(diskonall),"$","") %> 
    </td>
  </tr>
  <tr>
    <td colspan="6">
      PPN
    </td>
    <td align="right">
      <%= data("ORH_PPN") %>%
    </td>
    <td align="right">
      <%= replace(formatCurrency(ppn),"$","") %>
    </td>
  </tr>
  <tr>
    <th colspan="7" align="left">Total Pembayaran</th>
    <th align="right"><%= replace(formatCurrency(realgrantotal),"$","") %></th>
  </tr>

</table>