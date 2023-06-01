<!--#include file="../../init.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.GLB_M_Agen.AgenName, dbo.DLK_M_ProductH.PDID, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_WebLogin.UserName, dbo.DLK_T_MaterialOutH.MO_ID, dbo.DLK_T_MaterialOutH.MO_Date, dbo.DLK_T_MaterialOutH.MO_BMHID, dbo.DLK_T_MaterialOutH.MO_Keterangan, dbo.DLK_T_MaterialOutH.MO_AktifYN, dbo.DLK_T_MaterialOutH.MO_UpdateTime FROM dbo.DLK_M_Barang INNER JOIN dbo.DLK_M_ProductH INNER JOIN dbo.DLK_T_BOMH ON dbo.DLK_M_ProductH.PDID = dbo.DLK_T_BOMH.BMH_PDID ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_M_ProductH.PDBrgID RIGHT OUTER JOIN dbo.DLK_T_MaterialOutH LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_MaterialOutH.MO_UpdateID = dbo.DLK_M_WebLogin.UserID ON dbo.DLK_T_BOMH.BMH_ID = dbo.DLK_T_MaterialOutH.MO_BMHID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_MaterialOutH.MO_AgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_MaterialOutH.MO_AktifYN = 'Y') AND (dbo.DLK_T_MaterialOutH.MO_ID = '"&id&"')"

    set data = data_cmd.execute

    ' detail bom
    data_cmd.commandText = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_T_BOMD.BMD_ID, dbo.DLK_T_BOMD.BMD_Item, dbo.DLK_T_BOMD.BMD_Qtysatuan, dbo.DLK_T_BOMD.BMD_JenisSat, dbo.DLK_M_SatuanBarang.Sat_Nama, DLK_M_Kategori.KategoriNama, DLK_M_JenisBarang.JenisNama FROM dbo.DLK_T_BOMD LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_BOMD.BMD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_BOMD.BMD_Item = dbo.DLK_M_Barang.Brg_Id INNER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KategoriID INNER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID WHERE LEFT(dbo.DLK_T_BOMD.BMD_ID, 13) = '"& data("MO_BMHID") &"' ORDER BY dbo.DLK_M_Barang.Brg_Nama asc"
    ' response.write data_cmd.commandText & "<br>"
    set barang = data_cmd.execute

    ' detail data
    data_cmd.commandText = "SELECT dbo.DLK_T_MaterialOutD.MO_ID, dbo.DLK_T_MaterialOutD.MO_Item, dbo.DLK_T_MaterialOutD.MO_Qtysatuan, dbo.DLK_T_MaterialOutD.MO_Harga, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_Rak.Rak_nama FROM dbo.DLK_T_MaterialOutD LEFT OUTER JOIN dbo.DLK_M_Rak ON dbo.DLK_T_MaterialOutD.MO_RakID = dbo.DLK_M_Rak.Rak_ID LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_MaterialOutD.MO_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_MaterialOutD.MO_Item = dbo.DLK_M_Barang.Brg_Id WHERE MO_ID = '"& data("MO_ID") &"' ORDER BY DLK_M_Barang.Brg_Nama ASC"

    set ddata = data_cmd.execute

    call header("Detail Outgoing")
%>
<!--#include file="../../navbar.asp"-->
<meta http-equiv="refresh" content="10" />
<style>
    .loaderjual{
        position:relative;
        width:100%;
        display: flex;
        justify-content: center;
        top: 50%;
        /* display:none; */
    }
    .loaderjual img{
        position: absolute;
        top: 50%;
        display:none; 
    }
</style>
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 text-center">
            <h3>DETAIL BARANG OUTGOING</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3 text-center labelId">
            <h3><%= id %></h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3 text-center">
            <img src="https://chart.googleapis.com/chart?cht=qr&chl=<%= id %>&chs=160x160&chld=L|0" class="qr-code img-thumbnail img-responsive" width="100" height="100" />
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-sm-2">
            <label>No B.O.M</label>
        </div>
        <div class="col-sm-4">
            <input type="text" class="form-control" value="<%= data("MO_BMHID") %>" readonly>
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
            <label>No Produksi</label>
        </div>
        <div class="col-sm-4">
            <input type="text" class="form-control" value="<%= data("PDID") &" | " & data("Brg_Nama")%>" readonly>
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-sm-2">
            <label>Update ID</label>
        </div>
        <div class="col-sm-4">
            <input type="text" class="form-control" value="<%= data("username") %>" readonly>
        </div>
        <div class="col-sm-2">
            <label>Update Time</label>
        </div>
        <div class="col-sm-4">
            <input type="text" class="form-control" value="<%= data("MO_UpdateTime") %>" readonly>
        </div>
    </div>
    <div class="row mb-3">
        <div class="col-sm-2">
            <label>Keterangan</label>
        </div>
        <div class="col-sm-10">
            <input type="text" class="form-control" value="<%= data("MO_Keterangan") %>" readonly>
        </div>
    </div>
    <div class="row">
        <div class="d-flex mb-3">
            <div class="p-2">
                <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 text-center mb-3">
            <h5>DAFTAR B.O.M</h5>
        </div>
    </div>
    <div class="row">
      <div class="col-lg-12 mb-3">
         <table class="table table-hover">
            <thead class="bg-secondary text-light">
               <tr>
                  <th scope="col">ID</th>
                  <th scope="col">Kode</th>
                  <th scope="col">Item</th>
                  <th scope="col">Quantity</th>
                  <th scope="col">Satuan</th>
               </tr>
            </thead>
            <tbody>
               <% 
               do while not barang.eof 
               %>
                  <tr>
                     <th>
                        <%= barang("BMD_ID") %>
                     </th>
                     <th>
                        <%= barang("KategoriNama") &"-"& barang("jenisNama") %>
                     </th>
                     <td>
                        <%= barang("Brg_Nama") %>
                     </td>
                     <td>
                        <%= barang("BMD_QtySatuan") %>
                     </td>
                     <td>
                        <%= barang("Sat_nama") %>
                     </td>
                  </tr>
               <% 
               barang.movenext
               loop
               %>
            </tbody>
         </table>
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
                        <th scope="col">ID</th>
                        <th scope="col">Item</th>
                        <th scope="col">Quantity</th>
                        <th scope="col">Harga</th>
                        <th scope="col">Satuan</th>
                        <th scope="col">Rak</th>
                        <th scope="col" class="text-center">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    do while not ddata.eof 
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
                                <%= replace(formatCurrency(ddata("MO_Harga")),"$","") %>
                            </td>
                            <td>
                                <%= ddata("Sat_Nama") %>
                            </td>
                            <td>
                                <%= ddata("Rak_Nama") %>
                            </td>
                            <td class="text-center">
                                <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="aktifd.asp?id=<%= ddata("MO_ID") %>&brg=<%= ddata("MO_Item") %>&p=outd_add" class="btn badge text-bg-danger" onclick="deleteItem(event,'DETAIL BARANG OUTGOING')">Delete</a>
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