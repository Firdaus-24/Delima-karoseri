<!--#include file="../../init.asp"-->
<% 
  if session("MK3D") = false then
    Response.Redirect("index.asp")
  end if

  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT dbo.MKT_T_InvJulNewH.*, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Customer.custNama FROM dbo.MKT_T_InvJulNewH LEFT OUTER JOIN dbo.DLK_M_Customer ON dbo.MKT_T_InvJulNewH.IPH_Custid = dbo.DLK_M_Customer.custId LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.MKT_T_InvJulNewH.IPH_AgenID = dbo.GLB_M_Agen.AgenID WHERE dbo.MKT_T_InvJulNewH.IPH_ID = '"& id &"' AND dbo.MKT_T_InvJulNewH.IPH_AktifYN = 'Y'"
  ' response.write data_cmd.commandText & "<br>"
  set data = data_cmd.execute

  ' detail item
  data_cmd.commandTExt = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.MKT_T_InvJulNewD.IPD_Harga, dbo.MKT_T_InvJulNewD.IPD_DIsc1, dbo.MKT_T_InvJulNewD.IPD_DIsc2, dbo.MKT_T_InvJulNewD.IPD_QtySatuan, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.MKT_T_InvJulNewD.IPD_IPHID FROM dbo.DLK_M_Kategori INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID RIGHT OUTER JOIN dbo.MKT_T_InvJulNewD LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.MKT_T_InvJulNewD.IPD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID ON dbo.DLK_M_Barang.Brg_Id = dbo.MKT_T_InvJulNewD.IPD_Item WHERE LEFT(dbo.MKT_T_InvJulNewD.IPD_IPHID,13) = '"& data("IPH_ID") &"' ORDER BY Brg_Nama ASC"

  set ddata = data_cmd.execute

  Response.ContentType = "application/vnd.ms-excel"
  Response.AddHeader "content-disposition", "filename=InvoiceCustomer "& LEFT(data("IPH_ID"),2) &"-"& mid(data("IPH_ID"),3,3) &"/"& mid(data("IPH_ID"),6,4) &"/"& right(data("IPH_ID"),4)&" .xls"

%>
<table width="100%">
  <tr>
    <th colspan="8" style="text-align:center">INVOICE CUSTOMERS</th>
  </tr>
  <tr>
    <th colspan="8" style="text-align:center">
      <%= LEFT(data("IPH_ID"),2) &"-"& mid(data("IPH_ID"),3,3) &"/"& mid(data("IPH_ID"),6,4) &"/"& right(data("IPH_ID"),4)%>
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
      : <%= left(data("IPH_OJHID"),2) %>-<% call getAgen(mid(data("IPH_OJHID"),3,3),"") %>/<%= mid(data("IPH_OJHID"),6,4) %>/<%= right(data("IPH_OJHID"),4) %>
    </td>
  </tr>
  <tr>
    <td colspan="2" style="text-align:left">
      Tanggal
    </td>
    <td colspan="2" style="text-align:left">
      : <%= Cdate(data("IPH_DAte")) %>
    </td>
    <td colspan="2" style="text-align:left">
      Tanggal Jatuh Tempo
    </td>
    <td colspan="2" style="text-align:left">
      : <% if data("IPH_JTDAte") <> "1900-01-01"  then%> <%= Cdate(data("IPH_JTDate")) %> <% end if %>
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
      Tukar Faktur
    </td>
    <td colspan="2" style="text-align:left">
      : <% if data("IPH_TukarYN") = "Y" then %>Yese <% else %>No <% end if %>
    </td>
  </tr>
  <tr>
    <td colspan="2" style="text-align:left">
      Keterangan
    </td>
    <td colspan="6" style="text-align:left">
      : <%= data("IPH_Keterangan") %>
    </td>
  </tr>

  <tr>
    <td colspan="8" style="text-align:center">&nbsp</td>
  </tr>
  <tr>
    <th scope="col" style="border: 1px solid;">Kode</th>
    <th scope="col" style="border: 1px solid;">Item</th>
    <th scope="col" style="border: 1px solid;">Quantity</th>
    <th scope="col" style="border: 1px solid;">Satuan</th>
    <th scope="col" style="border: 1px solid;">Harga</th>
    <th scope="col" style="border: 1px solid;">Disc1</th>
    <th scope="col" style="border: 1px solid;">Disc2</th>
    <th scope="col" style="border: 1px solid;">Total</th>
  </tr>
  <% 
  grantotal = 0  
  realgrantotal = 0
  total = 0
  diskon1 = 0
  diskon2 = 0 
  do while not ddata.eof 

  diskon1 = (ddata("IPD_Disc1")/100) * ddata("IPD_Harga")
  diskon2 = (ddata("IPD_Disc2")/100) * ddata("IPD_Harga")

  hargadiskon = ddata("IPD_Harga") - diskon1 - diskon2
  total = hargadiskon * ddata("IPD_Qtysatuan")
  
  grantotal = grantotal + total
  %>
    <tr>
      <th style="text-align:left;border: 1px solid;">
        <%= ddata("KategoriNama") &"-"& ddata("jenisNama") %>
      </th>
      <td style="text-align:left;border: 1px solid;">
        <%= ddata("Brg_Nama") %>
      </td>
      <td style="text-align:left;border: 1px solid;">
        <%= ddata("IPD_QtySatuan") %>
      </td>
      <td style="text-align:left;border: 1px solid;">
        <%= ddata("Sat_nama") %>
      </td>
      <td style="text-align:right;border: 1px solid;">
        <%= replace(formatCurrency(ddata("IPD_Harga")),"$","") %>
      </td>
      <td style="text-align:left;border: 1px solid;">
        <%= ddata("IPD_Disc1") %> %
      </td>
      <td style="text-align:left;border: 1px solid;">
        <%= ddata("IPD_Disc2") %> %
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
    if data("IPH_diskonall") <> 0 OR data("IPH_Diskonall") <> "" then
      diskonall = (data("IPH_Diskonall")/100) * grantotal
    else
      diskonall = 0
    end if

    ' hitung ppn
    if data("IPH_ppn") <> 0 OR data("IPH_ppn") <> "" then
      ppn = (data("IPH_ppn")/100) * grantotal
    else
      ppn = 0
    end if

    realgrantotal = (grantotal - diskonall) + ppn
    %>
    <tr>
      <th colspan="6" style="text-align:left;border: 1px solid;">Diskon All</th>
      <td style="text-align:left;border: 1px solid;"><%=data("IPH_diskonall") %> %</td>
      <td style="text-align:right;border: 1px solid;"><%= replace(formatCurrency(diskonall),"$","") %></td>
    </tr>
    <tr>
      <th colspan="6" style="text-align:left;border: 1px solid;">PPN</th>
      <td style="text-align:left;border: 1px solid;"><%= data("IPH_ppn") %> %</td>
      <td style="text-align:right;border: 1px solid;"><%= replace(formatCurrency(ppn),"$","") %></td>
    </tr>
    <tr>
      <th colspan="7" style="text-align:left;border: 1px solid;">Total Pembayaran</th>
      <th style="text-align:right;border: 1px solid;"><%= replace(formatCurrency(realgrantotal),"$","") %></th>
    </tr>

</table>
