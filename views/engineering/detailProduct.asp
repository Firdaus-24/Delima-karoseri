<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_Produksi.asp"--> 
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' get data header
    data_cmd.commandText = "SELECT dbo.DLK_T_ProductH.*, dbo.DLK_M_Barang.Brg_Nama, GL_M_CategoryItem.cat_name, GLB_M_Agen.AgenName FROM dbo.DLK_T_ProductH LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_ProductH.PDBrgid = dbo.DLK_M_Barang.brg_ID LEFT OUTER JOIN GL_M_CategoryItem ON DLK_T_ProductH.PDKodeAKun = GL_M_CategoryItem.cat_id LEFT OUTER JOIN GLB_M_Agen ON DLK_T_ProductH.pdAgenID = GLB_M_Agen.AgenID WHERE dbo.DLK_T_ProductH.pdID = '"& id &"' AND dbo.DLK_T_ProductH.pdAktifYN = 'Y'"

    set data = data_cmd.execute

    ' get data detail
    data_cmd.commandText = "SELECT dbo.DLK_T_ProductD.*, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_SatuanBarang.Sat_ID FROM dbo.DLK_M_SatuanBarang RIGHT OUTER JOIN dbo.DLK_T_ProductD ON dbo.DLK_M_SatuanBarang.Sat_ID = dbo.DLK_T_ProductD.PDDJenisSat LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_ProductD.PDDItem = dbo.DLK_M_Barang.Brg_Id WHERE LEFT(dbo.DLK_T_ProductD.PDDPDID,12) = '"& data("PDID") &"' ORDER BY PDDPDID ASC"

    set ddata = data_cmd.execute

    ' getbarang 
    data_cmd.commandText = "SELECT DLK_M_Barang.Brg_Nama, DLK_M_Barang.Brg_ID, DLK_M_kategori.kategoriNama, DLK_M_JenisBarang.jenisNama FROM DLK_M_Barang LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.kategoriID = DLK_M_Kategori.kategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID WHERE Brg_AktifYN = 'Y' AND Brg_ID <> '"& data("PDBrgID") &"' ORDER BY Brg_Nama ASC"

    set barang = data_cmd.execute

    ' get jenis satuan
    data_cmd.commandText = "SELECT Sat_ID,Sat_Nama FROM DLK_M_SatuanBarang WHERE Sat_AktifYN = 'Y' ORDER BY Sat_Nama ASC"

    set psatuan = data_cmd.execute

    call header("Detail Product")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12  mt-3 text-center">
            <h3>DETAIL BARANG PRODUKSI</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 text-center mb-3 labelId">
            <h3><%= id %></h3>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-2">
            <label for="tgl" class="col-form-label">Tanggal</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="text" id="tgl" class="form-control" name="tgl" value="<%= Cdate(data("PDDate")) %>" readonly>
        </div>
        <div class="col-sm-2">
            <label for="cabang" class="col-form-label">Cabang</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="text" id="cabang" class="form-control" name="cabang" value="<%= data("agenName") %>" readonly>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-2">
            <label for="barang" class="col-form-label">Barang</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="text" id="barang" class="form-control" name="barang" value="<%= data("Brg_Nama") %>" readonly>
        </div>
        <div class="col-sm-2">
            <label for="kdakun" class="col-form-label">Kode Akun</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="text" id="kdakun" class="form-control" name="kdakun" value="<%= data("cat_name") %>" readonly>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-2">
            <label for="keterangan" class="col-form-label">Keterangan</label>
        </div>
        <div class="col-sm-10 mb-3 keterangan">
            <input type="text" class="form-control" name="keterangan" id="keterangan" maxlength="50" autocomplete="off" value="<%= data("PDKeterangan") %>" readonly>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <div class="d-flex mb-3">
                <div class="me-auto p-2">
                    <button type="button" class="btn btn-secondary" onClick="window.open('export-detailProduct.asp?id=<%=id%>')" >Export</button>
                </div>
                <div class="p-2">
                    <a href="produksi.asp" class="btn btn-danger">Kembali</a>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <table class="table table-hover">
                <thead class="bg-secondary text-light">
                    <tr>
                        <th scope="col">ID</th>
                        <th scope="col">Item</th>
                        <th scope="col">Sepesification</th>
                        <th scope="col">Quantity</th>
                        <th scope="col">Satuan</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    do while not ddata.eof 
                    %>
                        <tr>
                            <th>
                                <%= ddata("PDDPDID") %>
                            </th>
                            <td>
                                <%= ddata("Brg_Nama") %>
                            </td>
                            <td>
                                <%= ddata("PDDSpect") %>
                            </td>
                            <td>
                                <%= ddata("PDDQtty") %>
                            </td>
                            <td>
                                <%= ddata("sat_nama") %>
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