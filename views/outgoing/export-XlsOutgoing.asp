<!--#include file="../../init.asp"-->
<% 
    id = trim(Request.QueryString("id"))
    Response.ContentType = "application/vnd.ms-excel"
    Response.AddHeader "content-disposition", "filename=Outgoing No:"&id&".xls"


    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.GLB_M_Agen.AgenName, dbo.DLK_T_ProductH.PDID, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_WebLogin.UserName, dbo.DLK_T_MaterialOutH.MO_ID, dbo.DLK_T_MaterialOutH.MO_Date, dbo.DLK_T_MaterialOutH.MO_BMHID, dbo.DLK_T_MaterialOutH.MO_Keterangan, dbo.DLK_T_MaterialOutH.MO_AktifYN, dbo.DLK_T_MaterialOutH.MO_UpdateTime FROM dbo.DLK_M_Barang INNER JOIN dbo.DLK_T_ProductH INNER JOIN dbo.DLK_T_BOMH ON dbo.DLK_T_ProductH.PDID = dbo.DLK_T_BOMH.BMH_PDID ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_ProductH.PDBrgID RIGHT OUTER JOIN dbo.DLK_T_MaterialOutH LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_MaterialOutH.MO_UpdateID = dbo.DLK_M_WebLogin.UserID ON dbo.DLK_T_BOMH.BMH_ID = dbo.DLK_T_MaterialOutH.MO_BMHID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_MaterialOutH.MO_AgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_MaterialOutH.MO_AktifYN = 'Y') AND (dbo.DLK_T_MaterialOutH.MO_ID = '"&id&"')"

    set data = data_cmd.execute

    ' detail data
    data_cmd.commandText = "SELECT dbo.DLK_T_MaterialOutD.MO_ID, dbo.DLK_T_MaterialOutD.MO_Item, dbo.DLK_T_MaterialOutD.MO_Qtysatuan, dbo.DLK_T_MaterialOutD.MO_Harga, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_Rak.Rak_nama FROM dbo.DLK_T_MaterialOutD LEFT OUTER JOIN dbo.DLK_M_Rak ON dbo.DLK_T_MaterialOutD.MO_RakID = dbo.DLK_M_Rak.Rak_ID LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_MaterialOutD.MO_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_MaterialOutD.MO_Item = dbo.DLK_M_Barang.Brg_Id WHERE MO_ID = '"& data("MO_ID") &"' ORDER BY DLK_M_Barang.Brg_Nama ASC"

    set ddata = data_cmd.execute

    call header("Detail Outgoing")
%>
<style type="text/css">
   body{
      -webkit-print-color-adjust:exact !important;
      print-color-adjust:exact !important;
    }
   #cdetail  {
      background-color:blue;
      color:#fff;
   }
</style>
<table width="100%">
    <tr>
        <td colspan="7" align="center">
            <b>DETAIL BARANG OUTGOING</b>
        </td>
    </tr>
    <tr>
        <td colspan="7" align="center">
            <b><%= id %></b>
        </td>
    </tr>
    <tr>
        <td colspan="7">
            &nbsp
        </td>
    </tr>
</table>
<table width="100%">
    <tr>
        <td>
            No B.O.M
        </td>
        <td>
            : <%= data("MO_BMHID") %>
        </td>
        <td>
            Cabang
        </td>
        <td class="col-sm-4">
            : <%= data("AgenName") %>
        </td>
    </tr>
    <tr>
        <td>
            Tanggal
        </div>
        <td>
            : <%= Cdate(data("MO_Date")) %>
        </td>
        <td>
            No Produksi
        </td>
        <td>
            : <%= data("PDID") &" | " & data("Brg_Nama")%>
        </td>
    </tr>
    <tr>
        <td>
            Update ID
        </td>
        <td>
            : <%= data("username") %>
        </td>
        <td>
            Update Time
        </td>
        <td>
            : <%= data("MO_UpdateTime") %>
        </td>
    </tr>
    <tr>
        <td>
            Keterangan
        </td>
        <td colspan="3">
            : <%= data("MO_Keterangan") %>
        </td>
    </tr>
    <tr>
        <td colspan="3">
            &nbsp
        </td>
    </tr>
</table>
<table width="100%">
    <tr>
        <td colspan="7" align="center">
            <b>DETAIL PENGELUARAN</b>
        </td>
    </tr>
    <tr id="cdetail">
        <th>ID</th>
        <th>Item</th>
        <th>Quantity</th>
        <th>Satuan</th>
        <th>Rak</th>
        <th>Harga</th>
        <th>Total</th>
    </tr>
    <% 
    tharga = 0
    total = 0
    do while not ddata.eof
    total =  ddata("MO_Harga") * ddata("MO_QtySatuan")
    tharga = tharga + total
    %>
        <tr>
            <th>
                <%= ddata("MO_ID") %>
            </th>
            <td>
                <%= ddata("Brg_Nama") %>
            </td>
            <td>
                <%= ddata("MO_QtySatuan") %>
            </td>
            <td>
                <%= ddata("Sat_Nama") %>
            </td>
            <td>
                <%= ddata("Rak_Nama") %>
            </td>
            <td>
                <%= replace(formatCurrency(ddata("MO_Harga")),"$","") %>
            </td>
            <td>
                <%= replace(formatCurrency(total),"$","") %>
            </td>
        </tr>
        <tr>
            <td>
                Grand Total
            </td>
            <td colspan="6"> 
                <%= replace(formatCurrency(tharga),"$","") %>
            </td>
        </tr>
    <% 
    ddata.movenext
    loop
    %>
</table>
<% 
    call footer()
%>