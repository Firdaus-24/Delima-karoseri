<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_Produksi.asp"--> 
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' get data header
    data_cmd.commandText = "SELECT dbo.DLK_M_BOMH.*, dbo.DLK_M_Barang.Brg_Nama, GLB_M_Agen.AgenName FROM dbo.DLK_M_BOMH LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_BOMH.BMBrgid = dbo.DLK_M_Barang.brg_ID LEFT OUTER JOIN GLB_M_Agen ON DLK_M_BOMH.BMAgenID = GLB_M_Agen.AgenID WHERE dbo.DLK_M_BOMH.BMID = '"& id &"' AND dbo.DLK_M_BOMH.BMAktifYN = 'Y'"

    set data = data_cmd.execute

    ' get data detail
    data_cmd.commandText = "SELECT dbo.DLK_M_BOMD.*, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_SatuanBarang.Sat_ID, DLK_M_Kategori.kategoriNama, DLK_M_JenisBarang.JenisNama FROM dbo.DLK_M_SatuanBarang RIGHT OUTER JOIN dbo.DLK_M_BOMD ON dbo.DLK_M_SatuanBarang.Sat_ID = dbo.DLK_M_BOMD.BMDJenisSat LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_M_BOMD.BMDItem = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.kategoriID = DLK_M_Kategori.kategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.jenisID = DLK_M_JenisBarang.jenisID WHERE LEFT(dbo.DLK_M_BOMD.BMDBMID,12) = '"& data("BMID") &"' ORDER BY BMDBMID ASC"

    set ddata = data_cmd.execute

    call header("Detail B.O.M")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12  mt-3 text-center">
            <h3>DETAIL BARANG B.O.M</h3>
        </div>
    </div>
    <div class="row">
      <div class="col-lg-12 mb-3 text-center">
         <img src="https://chart.googleapis.com/chart?cht=qr&chl=<%= id %>&chs=160x160&chld=L|0" class="qr-code img-thumbnail img-responsive" width="100" height="100" />
      </div>
   </div>
   <div class="row">
      <div class="col-lg-12 text-center mb-3 labelId">
         <h3><%= left(id,2) %>-<%=mid(id,3,3) %>/<%= mid(id,6,4) %>/<%= right(id,3) %></h3>
      </div>
   </div>
    <div class="row">
        <div class="col-sm-2">
            <label for="tgl" class="col-form-label">Tanggal</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="text" id="tgl" class="form-control" name="tgl" value="<%= Cdate(data("BMDate")) %>" readonly>
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
            <label for="approve" class="col-form-label">Approve Y/N</label>
        </div>
        <div class="col-sm-4 mb-3">
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="approve" id="approveY" value="Y" <% if data("BMApproveYN") = "Y" then%>checked <% end if %>disabled>
                <label class="form-check-label" for="approveY">Yes</label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="approve" id="approveN" value="N" <% if data("BMApproveYN") = "N" then%>checked <% end if %>disabled>
                <label class="form-check-label" for="approveN" >No</label>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-2">
            <label for="keterangan" class="col-form-label">Keterangan</label>
        </div>
        <div class="col-sm-10 mb-3 keterangan">
            <input type="text" class="form-control" name="keterangan" id="keterangan" maxlength="50" autocomplete="off" value="<%= data("BMKeterangan") %>" readonly>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <div class="d-flex mb-3">
                <div class="me-auto p-2">
                    <button type="button" class="btn btn-secondary" onClick="window.open('export-detailbom.asp?id=<%=id%>')" >Export</button>
                </div>
                <div class="p-2">
                    <a href="index.asp" class="btn btn-danger">Kembali</a>
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
                        <th scope="col">Kode</th>
                        <th scope="col">Item</th>
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
                              <%= left(ddata("bmDbmID"),2) %>-<%=mid(ddata("bmDbmID"),3,3) %>/<%= mid(ddata("bmDbmID"),6,4) %>/<%= mid(ddata("BMDBMID"),10,3) %>/<%= right(ddata("BMDBMID"),3) %>
                           </th>
                            <td>
                                <%= ddata("kategoriNama") &"-"& ddata("JenisNama") %>
                            </td>
                            <td>
                                <%= ddata("Brg_Nama") %>
                            </td>
                            <td>
                                <%= ddata("BMDQtty") %>
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