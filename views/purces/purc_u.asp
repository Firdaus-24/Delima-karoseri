<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_purce.asp"-->
<% 
    if session("PR2B") = false then
        Response.Redirect("./")
    end if
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string
    
    data_cmd.commandTExt = "SELECT DLK_T_OrPemH.*, GLB_M_Agen.AgenName, DLK_M_vendor.Ven_Nama, DLK_M_Kebutuhan.K_Name FROM DLK_T_OrPemH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_OrPemH.OPH_AgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_vendor ON DLK_T_OrPemH.OPH_venID = DLK_M_Vendor.Ven_ID LEFT OUTER JOIN DLK_M_Kebutuhan ON DLK_T_OrPemH.OPH_KID = DLK_M_Kebutuhan.K_ID WHERE OPH_ID = '"& id &"' AND OPH_AktifYN = 'Y'"

    set data = data_cmd.execute

    ' barang
    data_cmd.commandText = "SELECT dbo.DLK_T_VendorD.Dven_Venid, dbo.DLK_T_VendorD.Dven_BrgID, dbo.DLK_T_VendorD.Dven_Spesification, dbo.DLK_T_VendorD.Dven_Harga, dbo.DLK_M_Barang.Brg_Nama, DLK_M_kategori.kategoriNama, DLK_M_JenisBarang.jenisNama FROM  dbo.DLK_T_VendorD LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_VendorD.Dven_BrgID = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.kategoriID = DLK_M_Kategori.kategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID WHERE (LEFT(dbo.DLK_T_VendorD.Dven_Venid, 9) = '"& data("OPH_VenID") &"') AND EXISTS(SELECT memoID,memoItem FROM DLK_T_Memo_D WHERE LEFT(memoID,17) = '"& data("OPH_MemoID") &"' AND memoItem = dVen_BrgID) ORDER BY dbo.DLK_M_Barang.Brg_Nama asc"
    set barang = data_cmd.execute

    ' satuan
    data_cmd.commandText = "SELECT sat_Nama, sat_ID FROM DLK_M_satuanBarang WHERE sat_AktifYN = 'Y' ORDER BY sat_Nama ASC"
    set psatuan = data_cmd.execute
    ' vendor
    data_cmd.commandText = "SELECT ven_Nama, Ven_ID FROM DLK_M_Vendor WHERE Ven_AktifYN = 'Y' ORDER BY ven_Nama ASC"
    set vendor = data_cmd.execute

    call header("Update Purches")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 text-center">
            <h3>FORM UPDATE PURCHES ORDER</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3 text-center labelId">
            <h3><%= LEFT(data("OPH_ID"),2) &"-"& mid(data("OPH_ID"),3,3) &"/"& mid(data("OPH_ID"),6,4) &"/"& right(data("OPH_ID"),4) %></h3>
        </div>
    </div>
    <div class="row align-items-center">
        <div class="col-lg-2 mb-3">
            <label for="memoId" class="col-form-label">No Memo</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="hidden" id="memoId" name="memoId" class="form-control" value="<%= data("OPH_memoID") %>" readonly>
            <input type="text" id="lmemoId" name="lmemoId" class="form-control" value="<%= left(data("OPH_memoID"),4) %>/<%=mid(data("OPH_memoId"),5,3) %>-<% call getAgen(mid(data("OPH_memoID"),8,3),"") %>/<%= mid(data("OPH_memoID"),11,4) %>/<%= right(data("OPH_memoID"),3) %>" readonly>
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
            <input type="text" id="vendor" name="vendor" class="form-control" value="<%= data("Ven_Nama") %>" readonly>
        </div>
        <div class="col-lg-2 mb-3">
            <label for="tgl" class="col-form-label">Tanggal</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="tgl" name="tgl" value="<%= date %>" class="form-control" readonly required>
        </div>
    </div>
    <div class="row align-items-center">
        <div class="col-lg-2 mb-3">
            <label for="acpdate" class="col-form-label">Tanggal Diterima</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="acpdate" name="acpdate" <% if cdate(data("OPH_Acpdate")) <> Cdate("01/01/1900") then %> value="<%= cdate(data("OPH_Acpdate")) %>" <% end if %> class="form-control" readonly>
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
            <label for="asuransi" class="col-form-label">Asuransi</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="asuransi" name="asuransi" value="<%= replace(formatCurrency(data("OPH_asuransi")),"$","") %>" class="form-control" readonly>
        </div>
        <div class="col-lg-2 mb-3">
            <label for="lain" class="col-form-label">Lain-lain</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="lain" name="lain"  value="<%= replace(formatCurrency(data("OPH_Lain")),"$","") %>"  class="form-control" readonly>
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
            <label for="diskon" class="col-form-label">Diskon All</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="number" id="diskon" name="diskon" value="<%= data("OPH_DiskonAll") %>" class="form-control" readonly>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-2 mb-3">
            <label for="kebutuhan" class="col-form-label">Kebutuhan</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="kebutuhan" name="kebutuhan" class="form-control" maxlength="50" value="<%= data("K_NAme") %>" autocomplete="off" readonly>
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
            <div class="d-flex">
                <div class="me-auto p-2">
                    <button type="button" class="btn btn-primary btn-modalOrPemD" data-bs-toggle="modal" data-bs-target="#modalOrPemD">Tambah Rincian</button>
                </div>
                <div class="p-2">
                    <a href="purcesDetail.asp" class="btn btn-danger">Kembali</a>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3">
            <table class="table tableupurchase">
                <thead class="bg-secondary text-light" style="white-space: nowrap;">
                    <tr>
                        <th>No</th>
                        <th>Kategori</th>
                        <th>Jenis</th>
                        <th>Item</th>
                        <th>Quantty</th>
                        <th>Satuan</th>
                        <th>Harga</th>
                        <th>Disc1</th>
                        <th>Disc2</th>
                        <th scope="col" class="text-center">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    data_cmd.commandText = "SELECT dbo.DLK_T_OrPemD.*, dbo.DLK_M_Barang.Brg_Nama,dbo.DLK_M_SatuanBarang.Sat_Nama, DLK_M_Kategori.kategoriNama, DLK_M_JenisBarang.JenisNama FROM dbo.DLK_T_OrPemD LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_OrPemD.OPD_Item = dbo.DLK_M_Barang.Brg_ID LEFT OUTER JOIN dbo.DLK_M_SatuanBarang ON dbo.DLK_T_OrPemD.OPD_JenisSat = dbo.DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KAtegoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID WHERE LEFT(DLK_T_OrPemD.OPD_OPHID,13) = '"& data("OPH_ID") &"' ORDER BY DLK_M_Barang.Brg_Nama ASC"

                    set ddata = data_cmd.execute
                    no = 0
                    do while not ddata.eof 
                    no = no + 1
                    
                    %>
                    <tr>
                        <th>
                            <%= no %>
                        </th>
                        <td>
                            <%=ddata("KategoriNama") %>
                        </td>
                        <td>
                            <%= ddata("jenisNama") %>
                        </td>
                        <td>
                            <%= ddata("Brg_Nama")%>
                        </td>
                        <td>
                            <%= ddata("OPD_QtySatuan") %>
                        </td>
                        <td>
                            <%= ddata("Sat_Nama") %>
                        </td>
                        <td>
                            <%= replace(formatCurrency(ddata("OPD_Harga")),"$","") %>
                        </td>
                        <td>
                            <%= ddata("OPD_Disc1") %>
                        </td>
                        <td>
                            <%= ddata("OPD_Disc2") %>
                        </td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Basic example">
                            <a href="aktifd.asp?id=<%= ddata("OPD_OPHID") %>" class="btn badge text-bg-danger btn-purce2">Delete</a>
                        </div>
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

<!-- Modal -->
<div class="modal fade" id="modalOrPemD" tabindex="-1" aria-labelledby="modalOrPemDLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalOrPemDLabel">Rincian Barang</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
    <form action="purc_u.asp?id=<%= id %>" method="post" id="formupdatepo">
    <input type="hidden" id="poid" name="poid" value="<%= data("OPH_ID") %>" readonly>
      <div class="modal-body">
        <!-- table barang -->
        <div class="row">
            <div class="col-sm mb-4 overflow-auto" style="height:15rem;">
                <table class="table" style="font-size:12px;">
                    <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
                        <tr>
                            <th scope="col">Kategori</th>
                            <th scope="col">Jenis</th>
                            <th scope="col">Nama</th>
                            <th scope="col">Harga</th>
                            <th scope="col">Sisa</th>
                            <th scope="col">Pilih</th>
                        </tr>
                    </thead>
                    <tbody  class="contentdpo">
                        <% do while not barang.eof 

                        data_cmd.commandText = "SELECT Brg_Id,  Brg_Nama, (SELECT SUM(ISNULL(dbo.DLK_T_OrPemD.OPD_QtySatuan,0)) AS qtypo FROM   dbo.DLK_T_OrPemH RIGHT OUTER JOIN dbo.DLK_T_OrPemD ON dbo.DLK_T_OrPemH.OPH_ID = LEFT(dbo.DLK_T_OrPemD.OPD_OPHID, 13)GROUP BY dbo.DLK_T_OrPemD.OPD_Item, dbo.DLK_T_OrPemH.OPH_AktifYN, dbo.DLK_T_OrPemH.OPH_MemoID HAVING (dbo.DLK_T_OrPemD.OPD_Item = '"& barang("Dven_BrgID") &"') AND (dbo.DLK_T_OrPemH.OPH_AktifYN = 'Y') AND (dbo.DLK_T_OrPemH.OPH_MemoID = '"& data("OPH_memoID") &"')) as qtypo, (SELECT SUM(ISNULL(dbo.DLK_T_Memo_D.memoQtty, 0)) AS qtymemo FROM dbo.DLK_T_Memo_H RIGHT OUTER JOIN dbo.DLK_T_Memo_D ON dbo.DLK_T_Memo_H.memoID = LEFT(dbo.DLK_T_Memo_D.memoID, 17) GROUP BY dbo.DLK_T_Memo_D.memoItem, dbo.DLK_T_Memo_H.memoID, dbo.DLK_T_Memo_H.memoAktifYN HAVING (dbo.DLK_T_Memo_H.memoAktifYN = 'Y') AND (dbo.DLK_T_Memo_H.memoID = '"& data("OPH_memoID") &"') AND (dbo.DLK_T_Memo_D.memoItem = '"& barang("Dven_BrgID") &"')) as qtymemo FROM DLK_M_Barang where Brg_AktifYN = 'Y' AND Brg_Id = '"& barang("Dven_BrgID") &"'"
                        ' Response.Write data_cmd.commandText & "<br>"
                        set ckqtypo = data_cmd.execute

                        if ckqtypo.eof then
                            sisa = 0
                        else
                            if IsNull(ckqtypo("qtypo")) then
                                qtypo = 0
                            else
                                qtypo = ckqtypo("qtypo")
                            end if
                            if IsNull(ckqtypo("qtymemo")) then
                                qtymemo = 0
                            else
                                qtymemo = ckqtypo("qtymemo")
                            end if
                            sisa = qtymemo - qtypo
                            
                        end if
                        %>
                        <tr>
                            <td><%= barang("kategoriNama") %></td>
                            <td><%= barang("jenisNama") %></td>
                            <td><%= barang("brg_nama") %></td>
                            <td><%= replace(formatCurrency(barang("Dven_Harga")),"$","Rp.") %></td>
                            <td><%=sisa %></td>
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
                <label for="hargaupo" class="col-form-label">Harga</label>
            </div>
            <div class="col-sm-9 mb-3">
                <input type="text" id="hargaupo" class="form-control" name="hargapo" autocomplete="off" readonly required>
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
        call updatePurce()
    end if
    call footer()
%>