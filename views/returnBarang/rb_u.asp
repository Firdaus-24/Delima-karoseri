<!--#include file="../../init.asp"-->
<% 
    if session("PR5B") = false then
        Response.Redirect("index.asp")
    end if

    id = trim(Request.querystring("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT DLK_T_ReturnBarangH.*, DLK_M_Vendor.Ven_Nama, GLB_M_Agen.AgenName FROM DLK_T_ReturnBarangH LEFT OUTER JOIN DLK_M_Vendor ON DLK_T_ReturnBarangH.RB_VenID = DLK_M_Vendor.Ven_ID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_ReturnBarangH.RB_AgenID = GLB_M_Agen.AgenID WHERE RB_ID = '"& id &"'"

    set data = data_cmd.execute 

    ' detail barang
    data_cmd.commandText = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_T_ReturnBarangD.* FROM dbo.DLK_T_ReturnBarangD LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_ReturnBarangD.RBD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_ReturnBarangD.RBD_Item = dbo.DLK_M_Barang.Brg_Id WHERE LEFT(RBD_RBID,12) = '"& data("RB_ID") &"' ORDER BY DLK_T_ReturnBarangD.RBD_RBID ASC"

    set detail = data_cmd.execute


    ' data_cmd.commandText = "SELECT dbo.DLK_T_InvPemH.IPH_Ppn, dbo.DLK_T_InvPemD.IPD_IphID, dbo.DLK_T_InvPemD.IPD_Item, dbo.DLK_T_InvPemD.IPD_QtySatuan, dbo.DLK_T_InvPemD.IPD_Harga, dbo.DLK_T_InvPemD.IPD_JenisSat, dbo.DLK_T_InvPemD.IPD_Disc1, dbo.DLK_T_InvPemD.IPD_Disc2, dbo.DLK_T_InvPemD.IPD_RakID FROM dbo.DLK_T_InvPemH RIGHT OUTER JOIN dbo.DLK_T_InvPemD ON dbo.DLK_T_InvPemH.IPH_ID = LEFT(dbo.DLK_T_InvPemD.IPD_IphID, 13) WHERE (dbo.DLK_T_InvPemH.IPH_VenId = '"& data("RB_VenID") &"') AND (dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y') AND (dbo.DLK_T_InvPemH.IPH_AgenId = '"& data("RB_AgenID") &"')ORDER BY dbo.DLK_T_InvPemH.IPH_Date"

    ' set brgVendor = data_cmd.execute

    call header("Update Return Barang")
%>
   <meta http-equiv="refresh" content="10" /> <!-- auto relog page -->
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 text-center">
            <h3>UPDATE RETURN BARANG</h3>
        </div>  
    </div>
    <div class="row">
        <div class="col-lg-12 text-center labelId">
            <h3><%= id %></h3>
        </div>  
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3 text-center">
            <img src="https://chart.googleapis.com/chart?cht=qr&chl=<%= id %>&chs=160x160&chld=L|0" class="qr-code img-thumbnail img-responsive" width="100" height="100"/>
        </div>  
    </div>
    <div class="row">
        <div class="col-sm-2">
            <label for="cabang" class="col-form-label">Cabang / Agen</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="text" class="form-control" value="<%= data("AgenName") %>" readonly>
        </div>
        <div class="col-sm-2">
            <label for="tgl" class="col-form-label">Tanggal</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="text" class="form-control" value="<%= Cdate(data("RB_Date")) %>" readonly>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-2">
            <label for="agen" class="col-form-label">Vendor</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="text" class="form-control" value="<%= data("ven_Nama") %>" readonly>
        </div>
        <div class="col-sm-2">
            <label for="keterangan" class="col-form-label">Keterangan</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="text" class="form-control" value="<%= data("RB_Keterangan") %>" maxlength="50" autocomplete="off" readonly>
        </div>
    </div>
    <div class="row">
        <div class="d-flex justify-content-between mb-3">
            <button type="button" class="btn btn-danger" onclick="window.location.href='index.asp'">Kembali</button>
        </div>
    </div>
    <!-- content detail -->
    <div class="row">
        <div class="col-sm-12">
            <table class="table" >
                <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
                    <tr>
                        <th scope="col">ID</th>
                        <th scope="col">No Transaksi</th>
                        <th scope="col">Barang</th>
                        <th scope="col">Quantity</th>
                        <th scope="col">Satuan</th>
                        <th scope="col">Harga</th>
                        <th scope="col">PPN</th>
                        <th scope="col">Disc1</th>
                        <th scope="col">Disc2</th>
                        <th scope="col" class="text-center">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <% do while not detail.eof %>
                    <tr>
                        <th scope="row"><%= detail("RBD_RBID") %></th>
                        <td>
                            <%= detail("RBD_IPDIPHID") %>
                        </td>
                        <td><%= detail("Brg_Nama") %></td>
                        <td><%= detail("RBD_Qtysatuan") %></td>
                        <td><%= detail("sat_nama") %></td>
                        <td>
                            <%= replace(formatCurrency(detail("RBD_Harga")),"$","") %>
                        </td>
                        <td><%= detail("RBD_PPN") %></td>
                        <td><%= detail("RBD_Disc1") %></td>
                        <td><%= detail("RBD_Disc2") %></td> 
                        <td class="text-center">
                           <a href="aktifd.asp?id=<%= detail("RBD_RBID") %>&p=rb_u" class="btn badge text-bg-danger" onclick="deleteItem(event, 'DETAIL RETURN BARANG')">delete</a>
                        </td>
                    </tr>
                    <% 
                    detail.movenext
                    loop
                    %>
                </tbody>
            </table>
        </div>
    </div>
</div>  
<% 
    call footer()
%>
