<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_purce.asp"--> 
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' get data header
    data_cmd.commandText = "SELECT dbo.DLK_T_OrPemH.*, dbo.DLK_M_Vendor.Ven_Nama, DLK_T_Memo_H.memoID, GLB_M_Agen.AgenName FROM dbo.DLK_T_OrPemH LEFT OUTER JOIN dbo.DLK_M_Vendor ON dbo.DLK_T_OrPemH.OPH_venID = dbo.DLK_M_Vendor.Ven_ID LEFT OUTER JOIN DLK_T_Memo_H ON DLK_T_OrPemH.OPH_memoID = DLK_T_Memo_H.memoID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_OrPemH.OPH_AgenID = GLB_M_Agen.AgenID WHERE dbo.DLK_T_OrPemH.OPH_ID = '"& id &"' AND dbo.DLK_T_OrPemH.OPH_AktifYN = 'Y'"

    set data = data_cmd.execute

    ' get data detail
    data_cmd.commandText = "SELECT dbo.DLK_T_OrPemD.*, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_SatuanBarang.Sat_Nama, dbo.DLK_M_SatuanBarang.Sat_ID, DLK_M_Kategori.kategoriNama, DLK_M_JenisBarang.JenisNama FROM dbo.DLK_M_SatuanBarang RIGHT OUTER JOIN dbo.DLK_T_OrPemD ON dbo.DLK_M_SatuanBarang.Sat_ID = dbo.DLK_T_OrPemD.OPD_JenisSat LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_OrPemD.OPD_Item = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KAtegoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID WHERE LEFT(dbo.DLK_T_OrPemD.OPD_OPHID,13) = '"& data("OPH_ID") &"' ORDER BY Brg_Nama ASC"

    set ddata = data_cmd.execute

    ' get barang for vendor
    data_cmd.commandText = "SELECT dbo.DLK_T_VendorD.Dven_Venid, dbo.DLK_T_VendorD.Dven_BrgID, dbo.DLK_T_VendorD.Dven_Spesification, dbo.DLK_T_VendorD.Dven_Harga, dbo.DLK_M_Barang.Brg_Nama, DLK_M_kategori.kategoriNama, DLK_M_JenisBarang.jenisNama FROM dbo.DLK_T_VendorD LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_VendorD.Dven_BrgID = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.kategoriID = DLK_M_Kategori.kategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID WHERE (LEFT(dbo.DLK_T_VendorD.Dven_Venid, 9) = '"& data("OPH_VenID") &"') AND EXISTS(SELECT memoID,memoItem FROM DLK_T_Memo_D WHERE LEFT(memoID,17) = '"& data("OPH_MemoID") &"' AND memoItem = dVen_BrgID) ORDER BY dbo.DLK_M_Barang.Brg_Nama asc"
    ' response.write data_cmd.commandText & "<br>"
    set barang = data_cmd.execute

    ' get jenis satuan
    data_cmd.commandText = "SELECT Sat_ID,Sat_Nama FROM DLK_M_SatuanBarang WHERE Sat_AktifYN = 'Y' ORDER BY Sat_Nama ASC"

    set psatuan = data_cmd.execute

    call header("Detail Barang PO")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12  mt-3 text-center">
            <h3>DETAIL BARANG PURCHASE ORDER</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 text-center mb-3 labelId">
            <h3><%= id %></h3>
        </div>
    </div>
    <div class="row align-items-center">
        <div class="col-lg-2 mb-3">
            <label for="memoId" class="col-form-label">No Memo</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="lmemoId" name="lmemoId" class="form-control" value="<%= left(data("memoID"),4) %>/<%=mid(data("memoId"),5,3) %>-<% call getAgen(mid(data("memoID"),8,3),"") %>/<%= mid(data("memoID"),11,4) %>/<%= right(data("memoID"),3) %>" readonly>
        </div>
        <div class="col-lg-2 mb-3">
            <label for="agen" class="col-form-label">Cabang / Agen</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="agen" name="agen" class="form-control" value="<%= data("agenName") %>" readonly>
        </div>
    </div>
    <div class="row align-items-center">
        <div class="col-lg-2 mb-3">
            <label for="vendor" class="col-form-label">Vendor</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="agen" name="agen" class="form-control" value="<%= data("Ven_Nama") %>" readonly>
        </div>
        <div class="col-lg-2 mb-3">
            <label for="tgl" class="col-form-label">Tanggal</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="tgl" name="tgl" value="<%= Cdate(data("OPH_Date")) %>" class="form-control" readonly>
        </div>
    </div>
    <div class="row align-items-center">
        <div class="col-lg-2 mb-3">
            <label for="ppn" class="col-form-label">PPn</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="number" id="ppn" name="ppn" value="<%= data("OPH_PPN") %>" class="form-control" readonly>
        </div>
        <div class="col-lg-2 mb-3">
            <label for="tgljt" class="col-form-label">Tanggal Jatuh Tempo</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="tgljt" name="tgljt" <% if cdate(data("OPH_JTDate")) <> Cdate("01/01/1900") then %> value="<%= cdate(data("OPH_JTDate")) %>" <% end if %> class="form-control" readonly>
        </div>
    </div>
    <div class="row align-items-center">
        
        <div class="col-lg-2 mb-3">
            <label for="diskon" class="col-form-label">Diskon All</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="number" id="diskon" name="diskon" value="<%= data("OPH_DiskonAll") %>" class="form-control" readonly>
        </div>
        <div class="col-lg-2 mb-3">
            <label for="keterangan" class="col-form-label">Keterangan</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" value="<%= data("OPH_Keterangan") %>" autocomplete="off" readonly>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <div class="d-flex mb-3">
                <div class="me-auto p-2">
                    <button type="button" class="btn btn-primary btn-modaldpo" data-bs-toggle="modal" data-bs-target="#modaldpo">Tambah Rincian</button>
                </div>
                <div class="p-2">
                    <a href="purcesDetail.asp" class="btn btn-danger">Kembali</a>
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
                        <th scope="col">Harga</th>
                        <th scope="col">Diskon1</th>
                        <th scope="col">Diskon2</th>
                        <th scope="col">Jumlah</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    grantotal = 0
                    do while not ddata.eof 
                    ' cek total harga 
                    jml = ddata("OPD_QtySatuan") * ddata("OPD_Harga")
                    ' cek diskon peritem
                    if ddata("OPD_Disc1") <> 0 and ddata("OPD_Disc2") <> 0  then
                        dis1 = (ddata("OPD_Disc1")/100) * ddata("OPD_Harga")
                        dis2 = (ddata("OPD_Disc2")/100) * ddata("OPD_Harga")
                    elseif ddata("OPD_Disc1") <> 0 then
                        dis1 = (ddata("OPD_Disc1")/100) * ddata("OPD_Harga")
                    elseIf ddata("OPD_Disc2") <> 0 then
                        dis2 = (ddata("OPD_Disc2")/100) * ddata("OPD_Harga")
                    else    
                        dis1 = 0
                        dis2 = 0
                    end if
                    ' total dikon peritem
                    hargadiskon = ddata("OPD_Harga") - dis1 - dis2
                    realharga = hargadiskon * ddata("OPD_QtySatuan")  

                    grantotal = grantotal + realharga

                    strid = ddata("OPD_OPHID")&","& ddata("OPD_Item") &","& ddata("OPD_QtySatuan") &","&  ddata("OPD_JenisSat") &","& ddata("OPD_Harga") &","& ddata("OPD_Disc1") &","& ddata("OPD_Disc2")   
                    %>
                        <tr>
                            <th>
                                <%= ddata("OPD_OPHID") %>
                            </th>
                            <th>
                                <%= ddata("KategoriNama") &"-"& ddata("jenisNama") %>
                            </th>
                            <td>
                                <%= ddata("Brg_Nama") %>
                            </td>
                            <td>
                                <%= ddata("OPD_QtySatuan") %>
                            </td>
                            <td>
                                <% call getSatBerat(ddata("OPD_JenisSat")) %>
                            </td>
                            <td>
                                <%= replace(formatCurrency(ddata("OPD_Harga")),"$","") %>
                            </td>
                            <td>
                                <%= ddata("OPD_disc1") %>%
                            </td>
                            <td>
                                <%= ddata("OPD_disc2") %>%
                            </td>
                            <td align="right">
                                <%= replace(formatCurrency(realharga),"$","") %>
                            </td>
                        </tr>
                    <% 
                    ddata.movenext
                    loop
                    ' cek diskonall
                    if data("OPH_diskonall") <> 0 OR data("OPH_Diskonall") <> "" then
                        diskonall = (data("OPH_Diskonall")/100) * grantotal
                    else
                        diskonall = 0
                    end if

                    ' hitung ppn
                    if data("OPH_ppn") <> 0 OR data("OPH_ppn") <> "" then
                        ppn = (data("OPH_ppn")/100) * grantotal
                    else
                        ppn = 0
                    end if
                    realgrantotal = (grantotal - diskonall) + ppn
                    %>
                    <tr>
                        <th colspan="8">Total Pembayaran</th>
                        <td align="right"><%= replace(formatCurrency(Round(realgrantotal)),"$","") %></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>  
<!-- Modal -->
<div class="modal fade" id="modaldpo" tabindex="-1" aria-labelledby="modaldpoLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modaldpoLabel">Rincian Barang</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
    <form action="purcesd_add.asp?id=<%= id %>" method="post" id="formaddpo">
    <input type="hidden" name="poid" id="poid" value="<%= id %>">
      <div class="modal-body">
        <!-- table barang -->
        <div class="row">
            <div class="col-sm mb-4 overflow-auto" style="height:15rem;">
                <table class="table" style="font-size:12px;">
                    <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
                        <tr>
                            <th scope="col">Kode</th>
                            <th scope="col">Nama</th>
                            <th scope="col">Sepesification</th>
                            <th scope="col">Harga</th>
                            <th scope="col">Pilih</th>
                        </tr>
                    </thead>
                    <tbody  class="contentdpo">
                        <% do while not barang.eof %>
                        <tr>
                            <th scope="row"><%= barang("kategoriNama")&"-"& barang("jenisNama") %></th>
                            <td><%= barang("brg_nama") %></td>
                            <td><%= barang("Dven_Spesification") %></td>
                            <td><%= replace(formatCurrency(barang("Dven_Harga")),"$","Rp.") %></td>
                            <td>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="ckbrgpo" id="ckbrgpo" value="<%= barang("Dven_BrgID") &","& barang("Dven_Harga") %>" required>
                                </div>
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
        <!-- end table -->
        <div class="row">
            <div class="col-sm-3">
                <label for="hargapo" class="col-form-label">Harga</label>
            </div>
            <div class="col-sm-9 mb-3">
                <input type="text" id="hargapo" class="form-control" name="hargapo" autocomplete="off" readonly required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-3">
                <label for="qtty" class="col-form-label">Quantity</label>
            </div>
            <div class="col-sm-4 mb-3">
                <input type="number" id="qtty" class="form-control" name="qtty" autocomplete="off" required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-3">
                <label for="satuan" class="col-form-label">Satuan Barang</label>
            </div>
            <div class="col-sm-4 mb-3">
                <select class="form-select" aria-label="Default select example" name="satuan" id="satuan" required> 
                    <option value="">Pilih</option>
                    <% do while not psatuan.eof %>
                    <option value="<%= psatuan("sat_ID") %>"><%= psatuan("sat_nama") %></option>
                    <%  
                    psatuan.movenext
                    loop
                    %>
                </select>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-3 mb-3">
                <label for="disc1" class="col-form-label">Disc1</label>
            </div>
            <div class="col-sm-4">
                <input type="number" id="disc1" name="disc1" autocomplete="off" class="form-control" required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-3 mb-3">
                <label for="disc2" class="col-form-label">Disc2</label>
            </div>
            <div class="col-sm-4">
                <input type="number" id="disc2" name="disc2" autocomplete="off" class="form-control" required>
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


<% 
    if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
        call tambahdetailpo()
    end if
    call footer()
%>