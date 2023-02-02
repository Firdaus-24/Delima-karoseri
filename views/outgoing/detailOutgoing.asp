<!--#include file="../../init.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_MaterialOutH.MO_ID, dbo.DLK_T_MaterialOutH.MO_PDDID, dbo.DLK_T_MaterialOutH.MO_AgenID, dbo.DLK_T_MaterialOutH.MO_Date, dbo.DLK_T_MaterialOutH.MO_Keterangan, dbo.DLK_T_MaterialOutH.MO_UpdateID, dbo.DLK_T_MaterialOutH.MO_UpdateTime, dbo.DLK_T_MaterialOutH.MO_AktifYN, dbo.DLK_T_MaterialOutH.MO_JDID, dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID, DLK_M_Weblogin.username FROM dbo.DLK_T_MaterialOutH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_MaterialOutH.MO_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN dbo.DLK_T_ProduksiD ON dbo.DLK_T_MaterialOutH.MO_PDDID = dbo.DLK_T_ProduksiD.PDD_ID LEFT OUTER JOIN DLK_M_Weblogin ON DLK_T_MaterialOutH.MO_UpdateID = DLK_M_Weblogin.userid WHERE (dbo.DLK_T_MaterialOutH.MO_ID = '"&id&"')"

    set data = data_cmd.execute

    ' detail data
    data_cmd.commandText = "SELECT dbo.DLK_T_MaterialOutD.MO_ID, dbo.DLK_T_MaterialOutD.MO_Date, dbo.DLK_T_MaterialOutD.MO_Item, dbo.DLK_T_MaterialOutD.MO_Qtysatuan, dbo.DLK_T_MaterialOutD.MO_Harga, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_Rak.Rak_nama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama FROM dbo.DLK_T_MaterialOutD LEFT OUTER JOIN dbo.DLK_M_Rak ON dbo.DLK_T_MaterialOutD.MO_RakID = dbo.DLK_M_Rak.Rak_ID LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_MaterialOutD.MO_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_MaterialOutD.MO_Item = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID WHERE MO_ID = '"& data("MO_ID") &"' ORDER BY DLK_M_Barang.Brg_Nama ASC"

    set ddata = data_cmd.execute

    call header("Detail Outgoing")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 text-center">
            <h3>DETAIL BARANG OUTGOING</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 text-center labelId">
            <h3><%= left(id,2) %>-<%= mid(id,3,3) %>/<%= mid(id,6,4) %>/<%= right(id,4) %></h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3 text-center">
            <img src="https://chart.googleapis.com/chart?cht=qr&chl=<%= id %>&chs=160x160&chld=L|0" class="qr-code img-thumbnail img-responsive" width="100" height="100" />
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-sm-2">
            <label>No Produksi</label>
        </div>
        <div class="col-sm-4">
            <input type="text" class="form-control" value="<%= left(data("MO_PDDID"),2) %>-<%= mid(data("MO_PDDID"),3,3) %>/<%= mid(data("MO_PDDID"),6,4) %>/<%= mid(data("MO_PDDID"),10,4) %>/<%= right(data("MO_PDDID"),3) %>" readonly>
        </div>
        <div class="col-sm-2">
            <label>Cabang</label>
        </div>
        <div class="col-sm-4">
            <input type="text" class="form-control" value="<%= data("AgenName") %>" readonly>
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-sm-2">
            <label>Tanggal</label>
        </div>
        <div class="col-sm-4">
            <input type="text" class="form-control" value="<%= Cdate(data("MO_Date")) %>" readonly>
        </div>
        <div class="col-sm-2">
            <label>Update ID</label>
        </div>
        <div class="col-sm-4">
            <input type="text" class="form-control" value="<%= data("username") %>" readonly>
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-sm-2">
            <label>Update Time</label>
        </div>
        <div class="col-sm-4">
            <input type="text" class="form-control" value="<%= data("MO_UpdateTime") %>" readonly>
        </div>
        <div class="col-sm-2">
            <label>Keterangan</label>
        </div>
        <div class="col-sm-4">
            <input type="text" class="form-control" value="<%= data("MO_Keterangan") %>" readonly>
        </div>
    </div>
    <div class="row">
        <div class="d-flex">
            <div class="me-auto p-2">
                <button type="button" class="btn btn-secondary" onClick="window.open('export-XlsOutgoing.asp?id=<%=id%>','_self')">EXPORT</button>
            </div>
            <div class="p-2">
                <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
            </div>
        </div>
    </div>
   <div class="row">
        <div class="col-lg-12 text-center mb-3">
            <h5>DETAIL PENGELUARAN</h5>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <table class="table table-hover">
                <thead class="bg-secondary text-light">
                    <tr>
                        <th scope="col">Tanggal</th>
                        <th scope="col">Kode</th>
                        <th scope="col">Item</th>
                        <th scope="col">Quantity</th>
                        <th scope="col">Harga</th>
                        <th scope="col">Satuan</th>
                        <th scope="col">Rak</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    do while not ddata.eof 
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
                                <%= replace(formatCurrency(ddata("MO_Harga")),"$","") %>
                            </td>
                            <td>
                                <%= ddata("Sat_Nama") %>
                            </td>
                            <td>
                                <%= ddata("Rak_Nama") %>
                            </td>
                        </tr>
                    <% 
                    ddata.movenext
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