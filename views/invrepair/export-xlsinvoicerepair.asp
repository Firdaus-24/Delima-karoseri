<!--#include file="../../init.asp"-->
<% 
  if session("MK4D") = false then
    Response.Redirect("./")
  end if

  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT dbo.MKT_T_InvRepairH.*, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Customer.custNama FROM dbo.MKT_T_InvRepairH LEFT OUTER JOIN dbo.DLK_M_Customer ON dbo.MKT_T_InvRepairH.INV_CustID = dbo.DLK_M_Customer.custId LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.MKT_T_InvRepairH.INV_Agenid = dbo.GLB_M_Agen.AgenID WHERE INV_AktifYN = 'Y' AND INV_ID = '"& id &"'"
  ' response.write data_cmd.commandText & "<br>"
  set data = data_cmd.execute

  ' detail invoice
  data_cmd.commandText = "SELECT dbo.DLK_M_Class.ClassName, dbo.DLK_M_Brand.BrandName, dbo.MKT_T_InvRepairD.IRD_INVID, dbo.MKT_T_InvRepairD.IRD_Qtysatuan,dbo.MKT_T_InvRepairD.IRD_Harga, dbo.MKT_T_InvRepairD.IRD_Diskon, dbo.MKT_T_InvRepairD.IRD_Keterangan, dbo.MKT_T_InvRepairD.IRD_UpdateId, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_WebLogin.UserName FROM dbo.MKT_T_InvRepairD LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.MKT_T_InvRepairD.IRD_UpdateId = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.MKT_T_InvRepairD.IRD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Brand ON dbo.MKT_T_InvRepairD.IRD_BrandID = dbo.DLK_M_Brand.BrandID LEFT OUTER JOIN dbo.DLK_M_Class ON dbo.MKT_T_InvRepairD.IRD_ClassID = dbo.DLK_M_Class.ClassID WHERE LEFT(dbo.MKT_T_InvRepairD.IRD_INVID,13) = '"& data("INV_ID") &"' ORDER BY dbo.MKT_T_InvRepairD.IRD_INVID"

  set ddata = data_cmd.execute

  Response.ContentType = "application/vnd.ms-excel"
  Response.AddHeader "content-disposition", "filename=InvoiceRepair "& LEFT(id,2) &"-"& mid(id,3,3) &"/"& mid(id,6,4) &"/"&  right(id,4)&" .xls"

%>
<table width="100%">
  <tr>
    <th colspan="8" style="text-align:center">DETAIL INVOICE REPAIR</th>
  </tr>
  <tr>
    <th colspan="8" style="text-align:center">
      <%= LEFT(id,2) &"-"& mid(id,3,3) &"/"& mid(id,6,4) &"/"&  right(id,4) %>
    </th>
  </tr>
  <tr>
    <td colspan="2" style="text-align:left">
      Cabang / Agen
    </td>
    <td colspan="2" style="text-align:left">
      : <%= data("AgenName") %>
    </td>
    <td colspan="2" style="text-align:left" >
      No P.O
    </td>
    <td colspan="2" style="text-align:left">
      : <%= left(data("INV_ORHID"),2) %>-<%= mid(data("INV_ORHID"),3,3) %>/<%= mid(data("INV_ORHID"),6,4) %>/<%= right(data("INV_ORHID"),4) %>
    </td>
  </tr>
  <tr>
    <td colspan="2" style="text-align:left">
      Tanggal
    </td>
    <td colspan="2" style="text-align:left">
      : <%= Cdate(data("INV_Date")) %>
    </td>
    <td colspan="2" style="text-align:left">
      Tanggal Jatuh Tempo
    </td>
    <td colspan="2" style="text-align:left">
      : <% if data("INV_JTDate") <> "1900-01-01"  then%> <%= Cdate(data("INV_JTDate")) %> <% end if %>
    </td>
  </tr>
  <tr>
    <td colspan="2" style="text-align:left">
      Customer
    </td>
    <td colspan="2" style="text-align:left">
      : <%= data("custnama") %>
    </td>
    <td colspan="2" style="text-align:left">
      Uang Muka
    </td>
    <td colspan="2" style="text-align:left">
      : <%= replace(formatcurrency(data("INV_Uangmuka")),"$","Rp. ") %>
    </td>
  </tr>
  <tr>
    <td colspan="2" style="text-align:left">
      Keterangan
    </td>
    <td colspan="2" style="text-align:left">
      : <%= data("INV_Keterangan") %>
    </td>
    <td colspan="2" style="text-align:left">
      Lama Pengerjaan
    </td>
    <td colspan="2" style="text-align:left">
      : <%= data("INV_Timework") %>
    </td>
  </tr>

  <tr>
    <td colspan="8" style="text-align:center">&nbsp</td>
  </tr>
  <tr>
    <th scope="col" style="border: 1px solid;">Class</th>
    <th scope="col" style="border: 1px solid;">Brand</th>
    <th scope="col" style="border: 1px solid;">Keterangan</th>
    <th scope="col" style="border: 1px solid;">Quantity</th>
    <th scope="col" style="border: 1px solid;">Satuan</th>
    <th scope="col" style="border: 1px solid;">Harga</th>
    <th scope="col" style="border: 1px solid;">Diskon</th>
    <th scope="col" style="border: 1px solid;">Total</th>
  </tr>
  <% 
  grantotal = 0  
  realgrantotal = 0
  total = 0
  diskon = 0
  do while not ddata.eof 

  diskon = (ddata("IRD_Diskon")/100) * ddata("IRD_Harga")

  hargadiskon = ddata("IRD_Harga") - diskon 
  total = hargadiskon * ddata("IRD_Qtysatuan")
  
  grantotal = grantotal + total
  %>
    <tr>
      <th style="text-align:left;border: 1px solid;">
        <%= ddata("className") %>
      </th>
      <td style="text-align:left;border: 1px solid;">
        <%= ddata("brandName") %>
      </td>
      <td style="text-align:left;border: 1px solid;">
        <%= ddata("IRD_KEterangan") %>
      </td>
      <td style="text-align:left;border: 1px solid;">
        <%= ddata("IRD_Qtysatuan") %>
      </td>
      <td style="text-align:left;border: 1px solid;">
        <%= ddata("Sat_nama") %>
      </td>
      <td style="text-align:right;border: 1px solid;">
        <%= replace(formatCurrency(ddata("IRD_Harga")),"$","") %>
      </td>
      <td style="text-align:left;border: 1px solid;">
        <%= ddata("IRD_Diskon") %> %
      </td>
      <td style="text-align:right;border: 1px solid;">
        <%= replace(formatCurrency(total),"$","") %>
      </td>
    </tr>
    <% 
    response.flush  
    ddata.movenext
    loop

    ' cek diskonall
    if data("INV_diskonall") <> 0 OR data("INV_Diskonall") <> "" then
      diskonall = (data("INV_Diskonall")/100) * grantotal
    else
      diskonall = 0
    end if

    ' hitung ppn
    if data("INV_ppn") <> 0 OR data("INV_ppn") <> "" then
      ppn = (data("INV_ppn")/100) * grantotal
    else
      ppn = 0
    end if

    realgrantotal = (grantotal - diskonall) + ppn
    %>
    <tr>
      <th colspan="6" style="text-align:left;border: 1px solid;">Diskon All</th>
      <td style="text-align:left;border: 1px solid;"><%=data("INV_diskonall") %> %</td>
      <td style="text-align:right;border: 1px solid;"><%= replace(formatCurrency(diskonall),"$","") %></td>
    </tr>
    <tr>
      <th colspan="6" style="text-align:left;border: 1px solid;">PPN</th>
      <td style="text-align:left;border: 1px solid;"><%= data("INV_ppn") %> %</td>
      <td style="text-align:right;border: 1px solid;"><%= replace(formatCurrency(ppn),"$","") %></td>
    </tr>
    <tr>
      <th colspan="7" style="text-align:left;border: 1px solid;">Total Pembayaran</th>
      <th style="text-align:right;border: 1px solid;"><%= replace(formatCurrency(realgrantotal),"$","") %></th>
    </tr>

</table>

