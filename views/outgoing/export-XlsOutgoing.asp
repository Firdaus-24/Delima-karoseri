<!--#include file="../../init.asp"-->
<% 
    if session("INV4D") = false then
        Response.Redirect("index.asp")
    end if

    id = trim(Request.QueryString("id"))
    Response.ContentType = "application/vnd.ms-excel"
    Response.AddHeader "content-disposition", "filename=Outgoing No:"&left(id,2)&"-"& mid(id,3,3) &"/"& mid(id,6,4) &"/"&  right(id,4) &".xls"


    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_MaterialOutH.MO_ID, dbo.DLK_T_MaterialOutH.MO_PDDID, dbo.DLK_T_MaterialOutH.MO_AgenID, dbo.DLK_T_MaterialOutH.MO_Date, dbo.DLK_T_MaterialOutH.MO_Keterangan, dbo.DLK_T_MaterialOutH.MO_UpdateID, dbo.DLK_T_MaterialOutH.MO_UpdateTime, dbo.DLK_T_MaterialOutH.MO_AktifYN, dbo.DLK_T_MaterialOutH.MO_JDID, dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID, DLK_M_Weblogin.username FROM dbo.DLK_T_MaterialOutH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_MaterialOutH.MO_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN dbo.DLK_T_ProduksiD ON dbo.DLK_T_MaterialOutH.MO_PDDID = dbo.DLK_T_ProduksiD.PDD_ID LEFT OUTER JOIN DLK_M_Weblogin ON DLK_T_MaterialOutH.MO_UpdateID = DLK_M_Weblogin.userid WHERE (dbo.DLK_T_MaterialOutH.MO_ID = '"&id&"')"

    set data = data_cmd.execute

    ' detail data
    data_cmd.commandText = "SELECT dbo.DLK_T_MaterialOutD.MO_ID, dbo.DLK_T_MaterialOutD.MO_Date, dbo.DLK_T_MaterialOutD.MO_Item, dbo.DLK_T_MaterialOutD.MO_Qtysatuan, dbo.DLK_T_MaterialOutD.MO_Harga, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_Rak.Rak_nama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama FROM dbo.DLK_T_MaterialOutD LEFT OUTER JOIN dbo.DLK_M_Rak ON dbo.DLK_T_MaterialOutD.MO_RakID = dbo.DLK_M_Rak.Rak_ID LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_MaterialOutD.MO_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_MaterialOutD.MO_Item = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID WHERE MO_ID = '"& data("MO_ID") &"' ORDER BY DLK_M_Barang.Brg_Nama ASC"

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
        <td colspan="8" align="center">
            <b>DETAIL BARANG OUTGOING</b>
        </td>
    </tr>
    <tr>
        <td colspan="8" align="center">
            <b><%= left(id,2) %>-<%= mid(id,3,3) %>/<%= mid(id,6,4) %>/<%= right(id,4) %></b>
        </td>
    </tr>
    <tr>
        <td colspan="8">
            &nbsp
        </td>
    </tr>
</table>
<table width="100%">
    <tr>
        <td>
            No Produksi
        </td>
        <td>
            : <%= left(data("MO_PDDID"),2) %>-<%= mid(data("MO_PDDID"),3,3) %>/<%= mid(data("MO_PDDID"),6,4) %>/<%= mid(data("MO_PDDID"),10,4) %>/<%= right(data("MO_PDDID"),3) %>
        </td>
        <td>
            Cabang
        </td>
        <td class="col-sm-4" colspan="5">
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
        <td >
            Update ID
        </td>
        <td colspan="5">
            : <%= data("username") %>
        </td>
    </tr>
    <tr>
        <td>
            Update Time
        </td>
        <td >
            : <%= data("MO_UpdateTime") %>
        </td>
         <td>
            Keterangan
        </td>
        <td colspan="5">
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
        <td colspan="8" align="center">
            <b>DETAIL PENGELUARAN</b>
        </td>
    </tr>
    <tr id="cdetail">
        <th>Tanggal</th>
        <th>Kode</th>
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
                <%= ddata("MO_Date") %>
            </th>
            <th>
                <%= ddata("KategoriNama") &"-"& ddata("jenisNama") %>
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
    <% 
    ddata.movenext
    loop
    %>
    <tr>
        <td colspan="7">
            Grand Total
        </td>
        <td > 
            <%= replace(formatCurrency(tharga),"$","") %>
        </td>
    </tr>
</table>
<% 
    call footer()
%>