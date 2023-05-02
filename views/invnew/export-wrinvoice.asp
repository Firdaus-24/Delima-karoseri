<!--#include file="../../init.asp"-->
<% 
  if session("MK3D") = false then
    Response.Redirect("index.asp")
  end if
  Response.Buffer = TRUE
  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT dbo.MKT_T_InvJulNewH.*, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Customer.custNama FROM dbo.MKT_T_InvJulNewH LEFT OUTER JOIN dbo.DLK_M_Customer ON dbo.MKT_T_InvJulNewH.IPH_Custid = dbo.DLK_M_Customer.custId LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.MKT_T_InvJulNewH.IPH_AgenID = dbo.GLB_M_Agen.AgenID WHERE dbo.MKT_T_InvJulNewH.IPH_ID = '"& id &"' AND dbo.MKT_T_InvJulNewH.IPH_AktifYN = 'Y'"
  ' response.write data_cmd.commandText & "<br>"
  set data = data_cmd.execute

  ' detail item
  data_cmd.commandTExt = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.MKT_T_InvJulNewD.IPD_Harga, dbo.MKT_T_InvJulNewD.IPD_DIsc1, dbo.MKT_T_InvJulNewD.IPD_DIsc2, dbo.MKT_T_InvJulNewD.IPD_QtySatuan, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama, dbo.MKT_T_InvJulNewD.IPD_IPHID FROM dbo.DLK_M_Kategori INNER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_Kategori.KategoriId = dbo.DLK_M_Barang.KategoriID INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID RIGHT OUTER JOIN dbo.MKT_T_InvJulNewD LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.MKT_T_InvJulNewD.IPD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID ON dbo.DLK_M_Barang.Brg_Id = dbo.MKT_T_InvJulNewD.IPD_Item WHERE LEFT(dbo.MKT_T_InvJulNewD.IPD_IPHID,13) = '"& data("IPH_ID") &"' ORDER BY Brg_Nama ASC"

  set ddata = data_cmd.execute

  ' Response.ContentType = "application/vnd.ms-word"
  ' Response.AddHeader "content-disposition", "attachment; filename=InvoiceCustomer "& LEFT(data("IPH_ID"),2) &"-"& mid(data("IPH_ID"),3,3) &"/"& mid(data("IPH_ID"),6,4) &"/"& right(data("IPH_ID"),4)&" .doc"

%>
<html>
 <style>
    body {
      width: 100%;
      height: 100%;
      margin: 0;
      padding: 0;
      background-color: #FAFAFA;
      font: 12px "arial";
    }

    * {
      box-sizing: border-box;
      -moz-box-sizing: border-box;
    }

    .page {
      width: 210mm;
      min-height: 297mm;
      padding: 6mm;
      margin: 1mm auto;
      background: white;
      box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
      position: relative;
    }

    .kopsurat{
      width:740px;
      margin:0 auto;
      margin-top:10px;
      height:60px;
      top:0;
      bottom:0;
    }

    .kopsurat img{
      width:40%;
    }

    #tbldetail, td, th {
      border: 1px solid;
    }

    #tbldetail {
      width: 100%;
      border-collapse: collapse;
    }

    @page {
      size: A4;
      margin: 0;
    }

    @media print {

      html,
      body {
        width: 210mm;
        height: 297mm;
      }

      .page {
        margin: 0;
        min-height: initial;
        box-shadow: initial;
        background: initial;
        page-break-after: always;
      }
      .subpage{
        page-break-after: always;

      }
      .kopsurat img{
        width:97%;
        height:55px;
        align-items:center;
      }

      
    }
  </style>
  <body onload="window.print()">
  <div class="page">
     <div class="kopsurat">
      <img src="<%= url %>/public/img/delima2.png" width="width:100%">
    </div>
    <table style="font-size:12px;width:100%;">
      <tr>
        <th colspan="8" style="text-align:center;border:none">INVOICE CUSTOMERS</th>
      </tr>
      <tr>
        <th colspan="8" style="text-align:center;border:none">
          <%= LEFT(data("IPH_ID"),2) &"-"& mid(data("IPH_ID"),3,3) &"/"& mid(data("IPH_ID"),6,4) &"/"& right(data("IPH_ID"),4)%>
        </th>
      </tr>
      <tr>
        <td colspan="2" style="text-align:left;border:none">
          Cabang / Agen
        </td>
        <td colspan="2" style="text-align:left;border:none">
          : <%= data("AgenName") %>
        </td>
        <td colspan="2" style="text-align:left;border:none" >
          No P.O
        </td>
        <td colspan="2" style="text-align:left;border:none">
          : <%= left(data("IPH_OJHID"),2) %>-<% call getAgen(mid(data("IPH_OJHID"),3,3),"") %>/<%= mid(data("IPH_OJHID"),6,4) %>/<%= right(data("IPH_OJHID"),4) %>
        </td>
      </tr>
      <tr>
        <td colspan="2" style="text-align:left;border:none">
          Tanggal
        </td>
        <td colspan="2" style="text-align:left;border:none">
          : <%= Cdate(data("IPH_DAte")) %>
        </td>
        <td colspan="2" style="text-align:left;border:none">
          Tanggal Jatuh Tempo
        </td>
        <td colspan="2" style="text-align:left;border:none">
          : <% if data("IPH_JTDAte") <> "1900-01-01"  then%> <%= Cdate(data("IPH_JTDate")) %> <% end if %>
        </td>
      </tr>
      <tr>
        <td colspan="2" style="text-align:left;border:none">
          Customer
        </td>
        <td colspan="2" style="text-align:left;border:none">
          : <%= data("custnama") %>
        </td>
        <td colspan="2" style="text-align:left;border:none">
          Tukar Faktur
        </td>
        <td colspan="2" style="text-align:left;border:none">
          : <% if data("IPH_TukarYN") = "Y" then %>Yese <% else %>No <% end if %>
        </td>
      </tr>
      <tr>
        <td colspan="2" style="text-align:left;border:none">
          Keterangan
        </td>
        <td colspan="6" style="text-align:left;border:none">
          : <%= data("IPH_Keterangan") %>
        </td>
      </tr>
      <tr>
        <td colspan="8" style="text-align:center;border:none">&nbsp</td>
      </tr>
    </table>
    <table style="font-size:12px;" id="tblDetail">
      

      <tr style="page-break-inside:auto;page-break-after:auto;">
        <th scope="col" style="">Kode</th>
        <th scope="col" style="">Item</th>
        <th scope="col" style="">Quantity</th>
        <th scope="col" style="">Satuan</th>
        <th scope="col" style="">Harga</th>
        <th scope="col" style="">Disc1</th>
        <th scope="col" style="">Disc2</th>
        <th scope="col" style="">Total</th>
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
        <tr style="page-break-inside:auto;page-break-after:auto;">
          <th style="text-align:left;">
            <%= ddata("KategoriNama") &"-"& ddata("jenisNama") %>
          </th>
          <td style="text-align:left;">
            <%= ddata("Brg_Nama") %>
          </td>
          <td style="text-align:left;">
            <%= ddata("IPD_QtySatuan") %>
          </td>
          <td style="text-align:left;">
            <%= ddata("Sat_nama") %>
          </td>
          <td style="text-align:right;">
            <%= replace(formatCurrency(ddata("IPD_Harga")),"$","") %>
          </td>
          <td style="text-align:left;">
            <%= ddata("IPD_Disc1") %> %
          </td>
          <td style="text-align:left;">
            <%= ddata("IPD_Disc2") %> %
          </td>
          <td style="text-align:right;">
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
        <tr style="page-break-inside:auto;page-break-after:auto;">
          <th colspan="6" style="text-align:left;">Diskon All</th>
          <td style="text-align:left;"><%=data("IPH_diskonall") %> %</td>
          <td style="text-align:right;"><%= replace(formatCurrency(diskonall),"$","") %></td>
        </tr>
        <tr style="page-break-inside:auto;page-break-after:auto;">
          <th colspan="6" style="text-align:left;">PPN</th>
          <td style="text-align:left;"><%= data("IPH_ppn") %> %</td>
          <td style="text-align:right;"><%= replace(formatCurrency(ppn),"$","") %></td>
        </tr>
        <tr style="page-break-inside:auto;page-break-after:auto;">
          <th colspan="7" style="text-align:left;">Total Pembayaran</th>
          <th style="text-align:right;"><%= replace(formatCurrency(realgrantotal),"$","") %></th>
        </tr>
    </table>
  </div>
  </body>
<html>