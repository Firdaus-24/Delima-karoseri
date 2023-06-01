<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_faktur.asp"-->
<% 
    if session("PR4A") = false then
        Response.Redirect("index.asp")
    end if

    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT dbo.DLK_T_InvPemH.*, DLK_T_OrPemH.OPH_ID, dbo.DLK_M_Vendor.Ven_Nama, GLB_M_Agen.AgenName, DLK_M_Kebutuhan.K_Name FROM dbo.DLK_T_InvPemH LEFT OUTER JOIN dbo.DLK_M_Vendor ON dbo.DLK_T_InvPemH.IPH_venID = dbo.DLK_M_Vendor.Ven_ID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_InvPemH.IPH_AgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_T_OrPemH ON DLK_T_InvPemH.IPH_OPHID = DLK_T_OrPemH.OPH_ID LEFT OUTER JOIN DLK_M_Kebutuhan ON DLK_T_InvPemH.IPH_KID = DLK_M_Kebutuhan.K_ID WHERE dbo.DLK_T_InvPemH.IPH_ID = '"& id &"' AND dbo.DLK_T_InvPemH.IPH_AktifYN = 'Y'"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    ' getbarang by vendor
    data_cmd.commandText = "SELECT dbo.DLK_T_VendorD.Dven_Venid, dbo.DLK_T_VendorD.Dven_BrgID, dbo.DLK_T_VendorD.Dven_Spesification, dbo.DLK_T_VendorD.Dven_Harga, dbo.DLK_M_Barang.Brg_Nama, DLK_M_kategori.kategoriNama, DLK_M_JenisBarang.jenisNama FROM  dbo.DLK_T_VendorD LEFT OUTER JOIN dbo.DLK_M_Barang ON dbo.DLK_T_VendorD.Dven_BrgID = dbo.DLK_M_Barang.Brg_Id LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.kategoriID = DLK_M_Kategori.kategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID WHERE (LEFT(dbo.DLK_T_VendorD.Dven_Venid, 9) = '"& data("IPH_VenID") &"') AND EXISTS(SELECT OPD_OPHID, OPD_Item FROM DLK_T_OrPemD WHERE LEFT(OPD_OPHID,13) = '"& data("IPH_OPHID") &"' AND OPD_Item = dVen_BrgID) ORDER BY dbo.DLK_M_Barang.Brg_Nama asc"
    ' response.write data_cmd.commandText & "<br>"
    set barang = data_cmd.execute
    ' satuan
    data_cmd.commandText = "SELECT sat_Nama, sat_ID FROM DLK_M_satuanBarang WHERE sat_AktifYN = 'Y' ORDER BY sat_Nama ASC"
    set psatuan = data_cmd.execute
    
    call header("Faktur Detail Barang")
%>
<script>
    function getHarga(harga){
        $("#hargainv").val(formatRupiah(harga))
    }   
</script>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 text-center">
            <h3>DETAIL FAKTUR TERHUTANG</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3 text-center labelId">
            <h3><%= LEFT(data("IPH_ID"),2) &"-"& mid(data("IPH_ID"),3,3) &"/"& mid(data("IPH_ID"),6,4) &"/"& right(data("IPH_ID"),4)%></h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-2 mb-3">
            <label for="agen" class="col-form-label">Cabang / Agen</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" class="form-control" name="lagen" id="lagen" value="<%= data("AgenName") %>" readonly>
        </div>
        <div class="col-lg-2 mb-3">
            <label for="ophid" class="col-form-label">No P.O</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="hidden" id="ophid" name="ophid" class="form-control" value="<%= data("OPH_ID") %>" readonly>
            <input type="text" id="lophid" name="lophid" class="form-control" value="<%= left(data("OPH_ID"),2) %>-<% call getAgen(mid(data("OPH_ID"),3,3),"") %>/<%= mid(data("OPH_ID"),6,4) %>/<%= right(data("OPH_ID"),4) %>" readonly>
        </div>
    </div>
    <div class="row align-items-center">
        <div class="col-lg-2 mb-3">
            <label for="tgl" class="col-form-label">Tanggal</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="tgl" name="tgl" class="form-control" value="<%= Cdate(data("IPH_DAte")) %>" readonly required>
        </div>
        <div class="col-lg-2 mb-3">
            <label for="tgljt" class="col-form-label">Tanggal Jatuh Tempo</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="tgljt" name="tgljt" class="form-control" <% if data("IPH_JTDAte") <> "1900-01-01"  then%> value="<%= Cdate(data("IPH_JTDate")) %>" <% end if %> readonly>
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
            <label for="ppn" class="col-form-label">PPN</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="number" id="ppn" name="ppn" value="<%= data("IPH_PPN") %>" class="form-control" readonly>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-2 mb-3">
            <label for="asuransi" class="col-form-label">Asuransi</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="asuransi" name="asuransi" class="form-control" value="<%= replace(formatcurrency(data("IPH_Asuransi")),"$","") %>" autocomplete="off" readonly>
        </div>
        <div class="col-lg-2 mb-3">
            <label for="lain" class="col-form-label">Lain-lain</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="lain" name="lain" class="form-control" autocomplete="off" value="<%= replace(formatcurrency(data("IPH_lain")),"$","") %>"  autocomplete="off" readonly>
        </div>
    </div>    
    <div class="row">
        <div class="col-lg-2 mb-3">
            <label for="diskon" class="col-form-label">Diskon</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="number" id="diskon" name="diskon" value="<%= data("IPH_diskonALL") %>"class="form-control" readonly>
        </div>
        <div class="col-lg-2 mb-3">
            <label for="tukar" class="col-form-label">Tukar Faktur</label>
        </div>
        <div class="col-lg-4 mb-3">
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="inlineRadioOptions" id="tukarY" name="tukar" <% if data("IPH_TukarYN") = "Y" then %>checked <% end if %> disabled>
                <label class="form-check-label" for="tukarY">Yes</label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="inlineRadioOptions" id="tukanN" name="tukar" <% if data("IPH_TukarYN") = "N" then %>checked <% end if %> disabled>
                <label class="form-check-label" >No</label>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-2 mb-3">
            <label for="Kebutuhan" class="col-form-label">Kebutuhan</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="Kebutuhan" name="Kebutuhan" class="form-control" maxlength="50" value="<%= data("K_NAme") %>" autocomplete="off" readonly>
        </div>
        <div class="col-lg-2 mb-3">
            <label for="keterangan" class="col-form-label">Keterangan</label>
        </div>
        <div class="col-lg-4 mb-3">
            <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" value="<%= data("IPH_Keterangan") %>" autocomplete="off" readonly>
        </div>
    </div>
    <div class="row">
        <div class="d-flex mb-3">
            <div class="me-auto p-2">
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalFakturadd">
                    Tambah Rincian
                </button>
            </div>
            <div class="p-2">
                <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
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
                        <th scope="col">Disc1</th>
                        <th scope="col">Disc2</th>
                        <th scope="col" class="text-center">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    grantotal = 0  

                    data_cmd.commandText = "SELECT DLK_T_InvPemD.*, DLK_M_Barang.Brg_Nama, DLK_M_Barang.Brg_ID,DLK_M_SatuanBarang.Sat_Nama,DLK_M_Kategori.kategoriNama, DLK_M_JenisBarang.JenisNama FROM DLK_T_InvPemD LEFT OUTER JOIN DLK_M_Barang ON DLK_T_InvPemD.IPD_Item = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_SatuanBarang ON DLK_T_InvPemD.IPD_JenisSat = DLK_M_SatuanBarang.Sat_ID LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KAtegoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID WHERE LEFT(IPD_IPHID,13) = '"& data("IPH_ID") &"'ORDER BY DLK_M_Barang.Brg_Nama ASC "

                    set ddata = data_cmd.execute
                    do while not ddata.eof 
                    %>
                        <tr>
                            <th>
                               <%= LEFT(ddata("IPD_IPHID"),2) &"-"& mid(ddata("IPD_IPHID"),3,3) &"/"& mid(ddata("IPD_IPHID"),6,4) &"/"& mid(ddata("IPD_IPHID"),10,4) &"/"& right(ddata("IPD_IPHID"),3)%>
                            </th>
                            <th>
                                <%= ddata("KategoriNama") &"-"& ddata("jenisNama") %>
                            </th>
                            <td>
                                <%= ddata("Brg_Nama") %>
                            </td>
                            <td>
                                <%= ddata("IPD_QtySatuan") %>
                            </td>
                            <td>
                                <%= ddata("Sat_nama") %>
                            </td>
                            <td>
                                <%= replace(formatCurrency(ddata("IPD_Harga")),"$","") %>
                            </td>
                            <td>
                                <%= ddata("IPD_Disc1") %>
                            </td>
                            <td>
                                <%= ddata("IPD_Disc2") %>
                            </td>
                            <td class="text-center">
                                <div class="btn-group" role="group" aria-label="Basic example">
                                <a href="aktifd.asp?id=<%= ddata("IPD_IPHID") %>&p=fakturd_add" class="btn badge text-bg-danger btn-fakturd">Delete</a>
                            </td>
                        </tr>
                    <% 
                     ddata.movenext
                     loop
                    ' ddata.movefirst
                    ' cek diskonall
                    ' if data("IPH_diskonall") <> 0 OR data("IPH_Diskonall") <> "" then
                    '     diskonall = (data("IPH_Diskonall")/100) * grantotal
                    ' else
                    '     diskonall = 0
                    ' end if

                    ' ' hitung ppn
                    ' if data("IPH_ppn") <> 0 OR data("IPH_ppn") <> "" then
                    '     ppn = (data("IPH_ppn")/100) * grantotal
                    ' else
                    '     ppn = 0
                    ' end if
                    ' realgrantotal = (grantotal - diskonall) + ppn
                    %>
                    <!-- 
                    <tr>
                        <th colspan="6">Total Pembayaran</th>
                        <th><%'= replace(formatCurrency(realgrantotal),"$","") %></th>
                    </tr>
                     -->
                </tbody>
            </table>
        </div>
    </div>
</div>  
<!-- Modal -->
<div class="modal fade" id="modalFakturadd" tabindex="-1" aria-labelledby="modalFakturaddLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalFakturaddLabel">Rincian Barang</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
    <form action="fakturd_add.asp?id=<%= id %>" method="post" onsubmit="validasiForm(this,event,'Proses Faktur Pembelian','warning')">
    <input type="hidden" name="iphid" id="iphid" value="<%= id %>">
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
                            <th scope="col">Pilih</th>
                        </tr>
                    </thead>
                    <tbody  class="contentdpo">
                        <% do while not barang.eof %>
                        <tr>
                            <th scope="row"><%= barang("kategoriNama")&"-"& barang("jenisNama") %></th>
                            <td><%= barang("brg_nama") %></td>
                            <td><%= barang("Dven_Spesification") %></td>
                            <td>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="ckinv" id="ckinv"  onclick="getHarga('<%= barang("Dven_Harga")%>')" value="<%= barang("Dven_BrgID") %>" required>
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
                <label for="harga" class="col-form-label">Harga</label>
            </div>
            <div class="col-sm-6 mb-3">
                <input type="text" id="hargainv" class="form-control" name="hargainv" autocomplete="off" readonly required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-3">
                <label for="qtty" class="col-form-label">Quantity</label>
            </div>
            <div class="col-sm-6 mb-3">
                <input type="number" id="qtty" class="form-control" name="qtty" autocomplete="off" required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-3">
                <label for="satuan" class="col-form-label">Satuan Barang</label>
            </div>
            <div class="col-sm-6 mb-3">
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
            <div class="col-sm-3">
                <label for="disc1" class="col-form-label">Dics 1</label>
            </div>
            <div class="col-sm-6 mb-3">
                <input type="number" id="disc1" name="disc1" autocomplete="off" class="form-control" required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-3">
                <label for="disc2" class="col-form-label">Dics 2</label>
            </div>
            <div class="col-sm-6 mb-3">
                <input type="number" id="disc2" name="disc2" autocomplete="off" class="form-control" required>
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
        call tambahDetailFaktur()
    end if
    call footer()
%>