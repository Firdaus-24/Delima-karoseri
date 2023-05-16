<!--#include file="../../init.asp"-->
<% 
  if session("MK4D") = false then
    Response.Redirect("./")
  end if
  Response.Buffer = true

  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT dbo.MKT_T_InvRepairH.*, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_Customer.custNama FROM dbo.MKT_T_InvRepairH LEFT OUTER JOIN dbo.DLK_M_Customer ON dbo.MKT_T_InvRepairH.INV_CustID = dbo.DLK_M_Customer.custId LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.MKT_T_InvRepairH.INV_Agenid = dbo.GLB_M_Agen.AgenID WHERE INV_AktifYN = 'Y' AND INV_ID = '"& id &"'"
  ' response.write data_cmd.commandText & "<br>"
  set data = data_cmd.execute

  ' detail invoice
  data_cmd.commandText = "SELECT dbo.DLK_M_Class.ClassName, dbo.DLK_M_Brand.BrandName, dbo.MKT_T_InvRepairD.IRD_INVID, dbo.MKT_T_InvRepairD.IRD_Qtysatuan,dbo.MKT_T_InvRepairD.IRD_Harga, dbo.MKT_T_InvRepairD.IRD_Diskon, dbo.MKT_T_InvRepairD.IRD_Keterangan, dbo.MKT_T_InvRepairD.IRD_UpdateId, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_WebLogin.UserName FROM dbo.MKT_T_InvRepairD LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.MKT_T_InvRepairD.IRD_UpdateId = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.MKT_T_InvRepairD.IRD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Brand ON dbo.MKT_T_InvRepairD.IRD_BrandID = dbo.DLK_M_Brand.BrandID LEFT OUTER JOIN dbo.DLK_M_Class ON dbo.MKT_T_InvRepairD.IRD_ClassID = dbo.DLK_M_Class.ClassID WHERE LEFT(dbo.MKT_T_InvRepairD.IRD_INVID,13) = '"& data("INV_ID") &"' ORDER BY dbo.MKT_T_InvRepairD.IRD_INVID"

  set ddata = data_cmd.execute


%>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Media Print</title>
    <link href='../../public/img/delimalogo.png' rel='website icon' type='png' />
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
  </head>
  <body onload="window.print()">
  <div class="page">
     <div class="kopsurat">
      <img src="<%= url %>/public/img/delima2.png" width="width:100%">
    </div>
    <table style="font-size:12px;width:100%;">
      <tr>
        <th colspan="8" style="text-align:center;border:none">DETAIL INVOICE REPAIR</th>
      </tr>
      <tr>
        <th colspan="8" style="text-align:center;border:none">
          <%= LEFT(id,2) &"-"& mid(id,3,3) &"/"& mid(id,6,4) &"/"&  right(id,4) %>
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
          : <%= left(data("INV_ORHID"),2) %>-<%= mid(data("INV_ORHID"),3,3) %>/<%= mid(data("INV_ORHID"),6,4) %>/<%= right(data("INV_ORHID"),4) %>
        </td>
      </tr>
      <tr>
        <td colspan="2" style="text-align:left;border:none">
          Tanggal
        </td>
        <td colspan="2" style="text-align:left;border:none">
          : <%= Cdate(data("INV_DAte")) %>
        </td>
        <td colspan="2" style="text-align:left;border:none">
          Tanggal Jatuh Tempo
        </td>
        <td colspan="2" style="text-align:left;border:none">
          : <% if data("INV_JTDAte") <> "1900-01-01"  then%> <%= Cdate(data("INV_JTDate")) %> <% end if %>
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
          Uang Muka
        </td>
        <td colspan="2" style="text-align:left;border:none">
          : <%= replace(formatcurrency(data("INV_Uangmuka")),"$","Rp.") %>
        </td>
      </tr>
      <tr>
        <td colspan="2" style="text-align:left;border:none">
          Keterangan
        </td>
        <td colspan="2" style="text-align:left;border:none">
          : <%= data("INV_Keterangan") %>
        </td>
        <td colspan="2" style="text-align:left;border:none">
          Lama Pengerjaan
        </td>
        <td colspan="2" style="text-align:left;border:none">
          : <%= data("INV_timework") %> hari
        </td>
      </tr>
      <tr>
        <td colspan="8" style="text-align:center;border:none">&nbsp</td>
      </tr>
    </table>
    <table style="font-size:12px;" id="tblDetail">
      

      <tr style="page-break-inside:auto;page-break-after:auto;">
        <th scope="col">No</th>
        <th scope="col">Class</th>
        <th scope="col">Brand</th>
        <th scope="col">Quantity</th>
        <th scope="col">Satuan</th>
        <th scope="col">Harga</th>
        <th scope="col">Diskon</th>
        <th scope="col" style="">Total</th>
      </tr>
      <% 
      grantotal = 0  
      realgrantotal = 0
      total = 0
      diskon = 0
      no = 0 
      do while not ddata.eof 
      no = no + 1
      diskon = (ddata("IRD_Diskon")/100) * ddata("IRD_Harga")

      hargadiskon = ddata("IRD_Harga") - diskon 
      total = hargadiskon * ddata("IRD_Qtysatuan")
      
      grantotal = grantotal + total
      %>
        <tr style="page-break-inside:auto;page-break-after:auto;">
          <th style="text-align:left;">
            <%= no %>
          </th>
          <td style="text-align:left;">
            <%= ddata("className") %>
          </td>
          <td style="text-align:left;">
            <%= ddata("brandName") %>
          </td>
          <td style="text-align:left;">
            <%= ddata("IRD_Qtysatuan")%>
          </td>
          <td style="text-align:left;">
            <%= ddata("Sat_nama") %>
          </td>
          <td style="text-align:right;">
            <%= replace(formatCurrency(ddata("IRD_Harga")),"$","") %>
          </td>
          <td style="text-align:center;">
            <%= ddata("IRD_Diskon") %> %
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
        if data("INV_diskonall") <> 0 OR data("INV_Diskonall") <> "" then
          diskonall = (data("INV_Diskonall")/100) * grantotal
        else
          diskonall = 0
        end if

        ' hitung ppn
        if data("INV_PPN") <> 0 OR data("INV_PPN") <> "" then
          ppn = (data("INV_PPN")/100) * grantotal
        else
          ppn = 0
        end if

        realgrantotal = (grantotal - diskonall) + ppn
        %>
        <tr style="page-break-inside:auto;page-break-after:auto;">
          <th colspan="6" style="text-align:left;">Diskon All</th>
          <td style="text-align:center;"><%=data("INV_diskonall") %> %</td>
          <td style="text-align:right;"><%= replace(formatCurrency(diskonall),"$","") %></td>
        </tr>
        <tr style="page-break-inside:auto;page-break-after:auto;">
          <th colspan="6" style="text-align:left;">PPN</th>
          <td style="text-align:center;"><%= data("INV_PPN") %> %</td>
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