<!--#include file="../../init.asp"-->
<% 
  if session("PP6D") = false then
    Response.Redirect("./")
  end if
  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' data header
  data_cmd.commandText = "SELECT dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Customer.custNama, dbo.DLK_M_Brand.BrandName, dbo.DLK_T_UnitCustomerD1.TFK_Nopol, dbo.DLK_T_UnitCustomerD1.TFK_Type, dbo.DLK_T_BOMRepairH.* FROM  dbo.DLK_M_Customer INNER JOIN dbo.DLK_T_IncRepairH ON dbo.DLK_M_Customer.custId = LEFT(dbo.DLK_T_IncRepairH.IRH_TFKID, 11) INNER JOIN dbo.DLK_T_UnitCustomerD1 ON dbo.DLK_T_IncRepairH.IRH_TFKID = dbo.DLK_T_UnitCustomerD1.TFK_ID INNER JOIN dbo.DLK_M_Brand ON dbo.DLK_T_UnitCustomerD1.TFK_BrandID = dbo.DLK_M_Brand.BrandID RIGHT OUTER JOIN dbo.DLK_T_BOMRepairH ON dbo.DLK_T_IncRepairH.IRH_ID = dbo.DLK_T_BOMRepairH.BmrIRHID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_BOMRepairH.BmrAgenId = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_BOMRepairH.BmrID = '"& id &"') AND (dbo.DLK_T_BOMRepairH.BmrAktifYN = 'Y')"
  set data = data_cmd.execute    

  ' data detail
  data_cmd.commandTExt = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_T_BOMRepairD.*, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama FROM  dbo.DLK_M_JenisBarang RIGHT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_JenisBarang.JenisID = dbo.DLK_M_Barang.JenisID LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId RIGHT OUTER JOIN dbo.DLK_T_BOMRepairD LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_BOMRepairD.BmrdSatID = dbo.DLK_M_SatuanBarang.Sat_ID ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_BOMRepairD.BmrdBrgID WHERE LEFT(DLK_T_BOMRepairD.BmrdID,13) = '"& data("BmrID") &"' ORDER BY Brg_Nama ASC"
  ' Response.Write data_cmd.commandTExt & "<br>"
  set ddata = data_cmd.execute

  ' barang
  data_cmd.commandTExt = "SELECT dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_TypeBarang.T_Nama FROM dbo.DLK_M_Barang LEFT OUTER JOIN dbo.DLK_M_TypeBarang ON dbo.DLK_M_Barang.Brg_Type = dbo.DLK_M_TypeBarang.T_ID LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId WHERE (dbo.DLK_M_Barang.Brg_AktifYN = 'Y') GROUP BY dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_TypeBarang.T_Nama, dbo.DLK_M_TypeBarang.T_ID HAVING (LEFT(dbo.DLK_M_Barang.Brg_Id, 3) = '"& data("BmrAgenID") &"') AND (dbo.DLK_M_TypeBarang.T_ID <> 'T01') AND (dbo.DLK_M_TypeBarang.T_ID <> 'T02') AND ( dbo.DLK_M_TypeBarang.T_ID <> 'T05') AND ( dbo.DLK_M_TypeBarang.T_ID <> 'T06')  ORDER BY dbo.DLK_M_TypeBarang.T_Nama, dbo.DLK_M_Barang.Brg_Nama"

  set barang = data_cmd.execute

  ' get satuan barang
  data_cmd.commandTExt = "SELECT Sat_Nama, Sat_ID FROM DLK_M_SatuanBarang WHERE Sat_AktifYN = 'Y' ORDER BY Sat_Nama ASC"
  set psatuan = data_cmd.execute

  Response.ContentType = "application/vnd.ms-excel"
  Response.AddHeader "content-disposition", "filename=B.O.M Repair "& left(data("BMRID"),3)&"-"&MID(data("BMRID"),4,3)&"/"&MID(data("BMRID"),7,4)&"/"&right(data("BMRID"),3)&" .xls"

%>

<table width="100%" style="font-size:16px;font-family:sans-serif">
  <tr>
    <th colspan="7" align="center">DETAIL B.O.M REPAIR</th>
  </tr>
  <tr>
    <th colspan="7" align="center"><%=left(data("BMRID"),3)&"-"&MID(data("BMRID"),4,3)&"/"&MID(data("BMRID"),7,4)&"/"&right(data("BMRID"),3)%></th>
  </tr>
  
  
  <tr>
    <td colspan="2">
      Tanggal
    </td>
    <td>
      <%= Cdate(data("BmrDate")) %>
    </td>
    <td colspan="2">
      Cabang
    </td>
    <td colspan="2">
      <%=data("AgenName") %>
    </td>
  </tr>
  <tr>
    <td colspan="2">
      No. Produksi
    </td>
    <td>
      <%=LEFT(data("BMRPDRID"),3) &"-"& MID(data("BMRPDRID"),4,2) &"/"& RIGHT(data("BMRPDRID"),3) %>
    </td>
    <td colspan="2">
      No.Incomming Unit
    </td>
    <td colspan="2">
      <%=LEFT(data("BmrIRHID"),4) &"-"& mid(data("BmrIRHID"),5,3) &"/"& mid(data("BmrIRHID"),8,4) &"/"& right(data("BmrIRHID"),2)%>
    </td>
  </tr>
  <tr>
    <td colspan="2">
      Customer
    </td>
    <td>
      <%=data("custnama")%>
    </td>
    <td colspan="2">
      Brand
    </td>
    <td colspan="2">
      <%=data("BrandName")%>
    </td>
  </tr>
  <tr>
    <td colspan="2">
      Type
    </td>
    <td>
      <%=data("TFK_Type")%>
    </td>
    <td colspan="2">
      No.Polisi
    </td>
    <td colspan="2">
      <%=data("TFK_Nopol")%>
    </td>
  </tr>
  <tr>
    <td colspan="2">
      Anggaran Manpower
    </td>
    <td>
      <%=Replace(formatCurrency(data("BmrTotalSalary")),"$","")%>
    </td>
    <td colspan="2">
      Keterangan
    </td>
    <td colspan="2">
      <%=data("BmrKeterangan")%>
    </td>
  </tr>

  <tr>
    <th style="border-collapse: collapse;border:1px solid black;">No</th>
    <th style="border-collapse: collapse;border:1px solid black;">Kode</th>
    <th style="border-collapse: collapse;border:1px solid black;">Barang</th>
    <th style="border-collapse: collapse;border:1px solid black;">Quantity</th>
    <th style="border-collapse: collapse;border:1px solid black;">Satuan</th>
    <th style="border-collapse: collapse;border:1px solid black;">Harga</th>
    <th style="border-collapse: collapse;border:1px solid black;">Keterangan</th>
    <th style="border-collapse: collapse;border:1px solid black;">Total</th>
  </tr>
  <% 
    gtotal = 0
    total = 0
    no = 0
    do while not ddata.eof 
    no = no + 1

    ' get data harga purchase
    data_cmd.commandTExt = "SELECT ISNULL(MAX(Dven_Harga),0) as harga FROM DLK_T_VendorD where Dven_BrgID = '"& ddata("BmrdBrgID") &"'"
    set ckharga = data_cmd.execute
    total = ckharga("harga") * ddata("BmrdQtysatuan")
    gtotal = gtotal + total
    %>
    <tr>
      <th style="border-collapse: collapse;border:1px solid black;">
        <%= no %>
      </th>
      <th style="border-collapse: collapse;border:1px solid black;">
        <%= ddata("KategoriNama") &" - "& ddata("jenisNama") %>
      </th>
      <td style="border-collapse: collapse;border:1px solid black;">
        <%=ddata("Brg_Nama")%>
      </td>
      <td style="border-collapse: collapse;border:1px solid black;">
        <%= ddata("BmrdQtysatuan")%>
      </td>
      <td style="border-collapse: collapse;border:1px solid black;">
        <%= ddata("Sat_nama")%>
      </td>
      <td style="border-collapse: collapse;border:1px solid black;">
        <%= replace(formatCurrency(ckharga("harga")),"$","")%>
      </td>
      <td style="border-collapse: collapse;border:1px solid black;">
        <%= ddata("BmrdKeterangan")%>
      </td>
      <td align="right" style="border-collapse: collapse;border:1px solid black;">
        <%= replace(formatCurrency(total),"$","")%>
      </td>
    </tr>
  <% 
  ddata.movenext
  loop
  %>
    <tr>
      <th colspan="7" align="left" style="border-collapse: collapse;border:1px solid black;">
        GRAND TOTAL
      </th>
      <th align="right" style="border-collapse: collapse;border:1px solid black;">
        <%= replace(formatCurrency(gtotal),"$","")%>
      </th>
    </tr>

</table>
