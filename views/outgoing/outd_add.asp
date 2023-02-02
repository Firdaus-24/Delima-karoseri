<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_outgoing.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_MaterialOutH.MO_ID, dbo.DLK_T_MaterialOutH.MO_PDDID, dbo.DLK_T_MaterialOutH.MO_AgenID, dbo.DLK_T_MaterialOutH.MO_Date, dbo.DLK_T_MaterialOutH.MO_Keterangan, dbo.DLK_T_MaterialOutH.MO_UpdateID, dbo.DLK_T_MaterialOutH.MO_UpdateTime, dbo.DLK_T_MaterialOutH.MO_AktifYN, dbo.DLK_T_MaterialOutH.MO_JDID, dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID, DLK_M_Weblogin.username FROM dbo.DLK_T_MaterialOutH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_MaterialOutH.MO_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN dbo.DLK_T_ProduksiD ON dbo.DLK_T_MaterialOutH.MO_PDDID = dbo.DLK_T_ProduksiD.PDD_ID LEFT OUTER JOIN DLK_M_Weblogin ON DLK_T_MaterialOutH.MO_UpdateID = DLK_M_Weblogin.userid WHERE (dbo.DLK_T_MaterialOutH.MO_ID = '"&id&"')"

    set data = data_cmd.execute

    ' detail bom by nomor produksi
    data_cmd.commandText = "SELECT dbo.DLK_M_BOMD.BMDItem, dbo.DLK_M_BOMD.BMDQtty, dbo.DLK_M_BOMD.BMDJenisSat, dbo.DLK_T_ProduksiD.PDD_ID, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_JenisBarang.JenisNama FROM dbo.DLK_M_Barang INNER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId INNER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID RIGHT OUTER JOIN dbo.DLK_M_BOMD ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_M_BOMD.BMDItem LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_M_BOMD.BMDJenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_BOMH INNER JOIN dbo.DLK_T_ProduksiD ON dbo.DLK_M_BOMH.BMID = dbo.DLK_T_ProduksiD.PDD_BMID ON LEFT(dbo.DLK_M_BOMD.BMDBMID, 12) = dbo.DLK_M_BOMH.BMID WHERE (dbo.DLK_M_BOMH.BMApproveYN = 'Y') AND (dbo.DLK_M_BOMH.BMAktifYN = 'Y') AND (dbo.DLK_T_ProduksiD.PDD_ID = '"& data("MO_PDDID") &"') ORDER BY dbo.DLK_M_Barang.Brg_Nama"
    ' response.write data_cmd.commandText & "<br>"
    set barang = data_cmd.execute

    ' detail data
    data_cmd.commandText = "SELECT dbo.DLK_T_MaterialOutD.MO_ID, dbo.DLK_T_MaterialOutD.MO_Date, dbo.DLK_T_MaterialOutD.MO_Item, dbo.DLK_T_MaterialOutD.MO_Qtysatuan, dbo.DLK_T_MaterialOutD.MO_Harga, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_Rak.Rak_nama, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriNama FROM dbo.DLK_T_MaterialOutD LEFT OUTER JOIN dbo.DLK_M_Rak ON dbo.DLK_T_MaterialOutD.MO_RakID = dbo.DLK_M_Rak.Rak_ID LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_MaterialOutD.MO_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_MaterialOutD.MO_Item = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID WHERE MO_ID = '"& data("MO_ID") &"' ORDER BY DLK_M_Barang.Brg_Nama ASC"

    set ddata = data_cmd.execute

    ' get stok barang
    data_cmd.commandTExt = "SELECT dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_ID, dbo.DLK_M_Barang.Brg_Type, dbo.DLK_M_JenisBarang.JenisID, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriId,dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_Barang.Brg_AktifYN, dbo.DLK_M_TypeBarang.T_ID, dbo.DLK_M_TypeBarang.T_Nama, ISNULL(ISNULL((SELECT SUM(MR_Qtysatuan) as pembelian FROM DLK_T_MaterialReceiptD2 WHERE MR_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(MO_Qtysatuan) FROM DLK_T_MaterialOutD WHERE MO_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(DB_QtySatuan) FROM dbo.DLK_T_DelBarang WHERE DB_Item = DLK_M_Barang.Brg_ID AND DB_AktifYN = 'Y' AND DB_Acc1 = 'Y' AND DB_Acc2 = 'Y'),0),0) as stok, ISNULL(dbo.DLK_T_MaterialReceiptD2.MR_Harga, 0) as harga, ISNULL((SELECT TOP 1 dbo.DLK_M_SatuanBarang.Sat_Nama FROM dbo.DLK_T_MaterialReceiptD2 LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_MaterialReceiptD2.MR_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID WHERE DLK_T_MaterialReceiptD2.MR_Item = DLK_M_Barang.Brg_ID GROUP BY Sat_nama),'') as satuan FROM DLK_M_Barang LEFT OUTER JOIN dbo.DLK_M_Kategori ON dbo.DLK_M_Barang.KategoriID = dbo.DLK_M_Kategori.KategoriId LEFT OUTER JOIN dbo.DLK_M_JenisBarang ON dbo.DLK_M_Barang.JenisID = dbo.DLK_M_JenisBarang.JenisID  LEFT OUTER JOIN dbo.DLK_M_TypeBarang ON dbo.DLK_M_Barang.Brg_Type = dbo.DLK_M_TypeBarang.T_ID LEFT OUTER JOIN dbo.DLK_T_MaterialReceiptD2 ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_MaterialReceiptD2.MR_Item WHERE Brg_AktifYN = 'Y' AND LEFT(Brg_ID,3) = '"& data("AgenID") &"' AND ISNULL(ISNULL((SELECT SUM(MR_Qtysatuan) as pembelian FROM DLK_T_MaterialReceiptD2 WHERE MR_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(MO_Qtysatuan) FROM DLK_T_MaterialOutD WHERE MO_Item = DLK_M_Barang.Brg_ID),0) - ISNULL((SELECT SUM(DB_QtySatuan) FROM dbo.DLK_T_DelBarang WHERE DB_Item = DLK_M_Barang.Brg_ID AND DB_AktifYN = 'Y' AND DB_Acc1 = 'Y' AND DB_Acc2 = 'Y'),0),0) > 0 GROUP BY dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Barang.Brg_MinStok, dbo.DLK_M_Barang.Brg_Type, dbo.DLK_M_JenisBarang.JenisID, dbo.DLK_M_JenisBarang.JenisNama, dbo.DLK_M_Kategori.KategoriId,dbo.DLK_M_Kategori.KategoriNama, dbo.DLK_M_Barang.Brg_AktifYN, dbo.DLK_M_TypeBarang.T_ID, dbo.DLK_M_TypeBarang.T_Nama, DLK_M_Barang.Brg_ID, dbo.DLK_T_MaterialReceiptD2.MR_Harga ORDER BY Brg_Nama ASC"

    set getstok = data_cmd.execute

    ' set satuan barang
    data_cmd.commandTExt = "SELECT Sat_ID, Sat_Nama FROM DLK_M_SatuanBarang WHERE Sat_AktifYN = 'Y' ORDER BY Sat_Nama ASC"

    set datasatuan = data_cmd.execute

    call header("Tambah Detail Outgoing")

    
%>
<!--#include file="../../navbar.asp"-->
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
        <div class="col-lg-12">
         <div class="d-flex mb-3">
            <div class="me-auto p-2">
               <button type="button" class="btn btn-primary btn-modalOutgoing" data-bs-toggle="modal" data-bs-target="#modalOutgoing">Tambah Doc</button>
            </div>
            <div class="p-2">
               <a href="index.asp" class="btn btn-danger">Kembali</a>
            </div>
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
                        <%= barang("KategoriNama") &"-"& barang("jenisNama") %>
                    </th>
                    <td>
                        <%= barang("Brg_Nama") %>
                    </td>
                    <td>
                        <%= barang("BMDqtty") %>
                    </td>
                    <td>
                        <%= barang("Sat_nama") %>
                    </td>
                </tr>
               <% 
               response.flush
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
                    <th scope="col">Tanggal</th>
                    <th scope="col">Kode</th>
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
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                            <a href="aktifd.asp?id=<%= ddata("MO_ID") %>&brg=<%= ddata("MO_Item") %>&p=outd_add&tgl=<%= ddata("MO_Date") %>" class="btn badge text-bg-danger" onclick="deleteItem(event,'DETAIL BARANG OUTGOING')">Delete</a>
                        </td>
                    </tr>
                <% 
                response.flush
                ddata.movenext
                loop
                %>
            </tbody>
         </table>
      </div>
   </div>
</div>  
<!-- Modal -->
<div class="modal fade" id="modalOutgoing" tabindex="-1" aria-labelledby="modalOutgoingLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="modalOutgoingLabel">Form Pengeluaran Barang</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="outd_add.asp?id=<%= id %>" method="post" onsubmit="validasiOutgoing(event,this)">
                <input type="hidden" name="id" value="<%= id %>">
                <div class="modal-body">
                    <div class="row">
                        <div class="col-sm-3 mb-3">
                            <label for="cOutItem" class="col-form-label">Cari Item</label>
                        </div>
                        <div class="col-sm mb-3">
                            <input type="hidden" id="cOutcabang" class="form-control" value="<%= data("agenID") %>">
                            <input type="text" id="cOutItem" class="form-control">
                        </div>
                    </div>
                    <div class="tablestokpo" style="height: 20em;overflow-y:auto;margin-bottom:20px;font-size:14px;">
                        <table class="table">
                            <thead class="bg-secondary text-light"  style="position: sticky;top: 0;">
                            <tr style="position: sticky;">
                                <th scope="col">Kode</th>
                                <th scope="col">Barang</th>
                                <th scope="col">Satuan</th>
                                <th scope="col">Stok</th>
                                <th scope="col">Pilih</th>
                            </tr>
                            </thead>
                            <tbody class="contentItemsOutgoing">
                            <%do while not getstok.eof %>
                            <tr>
                                <td><%= getstok("kategoriNama") &"-"& getstok("jenisNama") %></td>
                                <td><%= getstok("Brg_Nama") %></td>
                                <td><%= getstok("satuan") %></td>
                                <td><%= getstok("stok") %></td>
                                <td class="text-center">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="ckbrgid" id="ckbrgid" value="<%=  getstok("Brg_ID") %>" onclick="getDataOutgoing('<%=getstok("harga")%>', '<%= getstok("stok") %>', '<%=  getstok("Brg_ID") %>')" required>
                                    </div>
                                </td>
                            </tr>
                            <% 
                            response.flush
                            getstok.movenext
                            loop
                            %>
                            <tbody>
                        </table>
                    </div>
                    <div class="row">
                        <div class="col-sm-3">
                            <label for="tgl" class="col-form-label">Tanggal</label>
                        </div>
                        <div class="col-sm-5 mb-3">
                            <input type="text" id="tgl" name="tgl" class="form-control" value="<%= date() %>" onfocus="(this.type='date')" required>
                        </div>
                    </div>
                    <div class="row">
                        <!-- get harga dan stok -->
                        <input type="hidden" id="harga" name="harga" class="form-control">
                        <input type="hidden" id="stok" name="stok" class="form-control">
                        
                        <div class="col-sm-3">
                            <label for="qty" class="col-form-label">Quantity</label>
                        </div>
                        <div class="col-sm-5 mb-3">
                            <input type="number" id="qty" name="qty" class="form-control" required>
                        </div>
                    </div>
                <div class="row">
                        <div class="col-sm-3">
                            <label for="rak" class="col-form-label">Rak</label>
                        </div>
                        <div class="col-sm-5 mb-3">
                            <div class="rakOutLama">
                                <select class="form-select" aria-label="Default select example">
                                    <option disabled>Pilih Item Dahulu</option>
                                </select>
                            </div>
                            <div class="rakOutBaru">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-3">
                            <label for="dsatuan" class="col-form-label">satuan</label>
                        </div>
                        <div class="col-sm-5">
                            <select class="form-select" aria-label="Default select example" id="dsatuan" name="dsatuan" required>
                                <option value="">Pilih</option>
                                <% do while not datasatuan.eof %>
                                    <option value="<%= datasatuan("Sat_ID") %>"><%= datasatuan("Sat_Nama") %></option>
                                <% datasatuan.movenext
                                loop %>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="submit" class="btn btn-primary">Save</button>
                </div>
            </form>
        </div>
    </div>
</div>
<script>
    const getDataOutgoing = (harga,stok, brgid) => {
        $("#harga").val(harga)
        $("#stok").val(stok)
        $("#qty").val('')
        
        $.post("../../ajax/getRakOutgoing.asp", {brgid}, function(data){
            $(".rakOutLama").hide()
            $(".rakOutBaru").html(data)
        })
        
    }

    const validasiOutgoing = (e, data) => {
        let form = data;
        e.preventDefault(); // <--- prevent form from submitting
        
        let stok = Number($("#stok").val())
        let qty = Number($("#qty").val())

        if (qty > stok ){
            swal("Permintaan Melebih stok yang ada !!!");
            return false
        }
        swal({
            title: "APAKAH ANDA SUDAH YAKIN??",
            text: "Proses Outgoing",
            icon: 'warning',
            buttons: [
            'No',
            'Yes'
            ],
            dangerMode: true,
        }).then(function(isConfirm) {
            if (isConfirm) {
                form.submit(); // <--- submit form programmatically
            } else {
            swal("Form gagal di kirim");
            }
        })  
    }
</script>
<% 
    if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
        call DetailOutgoing()
    end if
    call footer()
%>