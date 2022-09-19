<!--#include file="../../init.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT DLK_T_Memo_H.*, DLK_M_Departement.DepNama FROM DLK_T_Memo_H LEFT OUTER JOIN DLK_M_Departement ON DLK_T_Memo_H.memoDepID = DLK_M_Departement.DepID WHERE memoID = '"& id &"' and memoAktifYN = 'Y'"
    ' response.write data_cmd.commandText
    set dataH = data_cmd.execute
    ' get satuan
    ' data_cmd.commandText = "SELECT sat_Nama, sat_ID FROM DLK_M_satuanBarang WHERE sat_AktifYN = 'Y' ORDER BY sat_Nama ASC"
    ' set psatuan = data_cmd.execute    
    ' get all barang
    ' data_cmd.commandText = "SELECT dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Kategori.KategoriNama, DLK_M_JenisBarang.JenisNama FROM dbo.DLK_M_Barang LEFT OUTER JOIN dbo.DLK_T_VendorD ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_VendorD.Dven_BrgID LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.JenisID WHERE (dbo.DLK_T_VendorD.Dven_BrgID <> '') AND (dbo.DLK_M_Barang.Brg_AktifYN = 'Y') AND (left(dbo.DLK_M_Barang.Brg_Id,3) = '"& dataH("memoAgenID") &"') GROUP BY dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Kategori.KategoriNama, DLK_M_JenisBarang.JenisNama ORDER BY Brg_Nama ASC"
    ' set barang = data_cmd.execute
%>
<% call header("UPDATE HARGA BARANG") %>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 mb-3 text-center">
            <h3>UPDATE HARGA PERMINTAAN BARANG</h3>
        </div>  
    </div> 
    <div class="row mb-3">
        <div class="col-sm-6">
            <div class="row g-3 align-items-center">
                <div class="col-auto">
                    <label class="col-form-label">Nomor :</label>
                </div>
                <div class="col-auto">
                    <label>
                        <b>
                            <%= left(dataH("memoID"),4) %>/<%= mid(dataH("memoId"),5,3) %>-<% call getAgen(mid(dataH("memoID"),8,3),"") %>/<%= mid(dataH("memoID"),11,4) %>/<%= right(dataH("memoID"),3) %>
                        </b>
                    </label>
                </div>
            </div>
        </div>
        <div class="col-sm-6">
            <div class="row g-3 align-items-center">
                <div class="col-auto">
                    <label class="col-form-label">Cabang :</label>
                </div>
                <div class="col-auto">
                    <% call getAgen(dataH("memoAgenID"),"p") %>
                </div>
            </div>
        </div>
        <div class="col-sm-6">
            <div class="row g-3 align-items-center">
                <div class="col-auto">
                    <label class="col-form-label">Hari :</label>
                </div>
                <div class="col-auto">
                    <label><%= weekdayname(weekday(dataH("memoTgl"))) %></label>
                </div>
            </div>
        </div>
        <div class="col-sm-6">
            <div class="row g-3 align-items-center">
                <div class="col-auto">
                    <label class="col-form-label">Departement :</label>
                </div>
                <div class="col-auto">
                    <label><%= dataH("DepNama")%></label>
                </div>
            </div>
        </div>
        <div class="col-sm-6">
            <div class="row g-3 align-items-center">
                <div class="col-auto">
                    <label class="col-form-label">Tanggal :</label>
                </div>
                <div class="col-auto">
                    <label><%= Cdate(dataH("memoTgl")) %></label>
                </div>
            </div>
        </div>
        <div class="col-sm-6">
            <div class="row g-3 align-items-center">
                <div class="col-auto">
                    <label class="col-form-label">Divisi :</label>
                </div>
                <div class="col-auto">
                    <label><% call getDivisi(dataH("memoDivID")) %></label>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <div class="d-flex mb-3">
                <div class="p-2">
                    <a href="uprice.asp" class="btn btn-danger">Kembali</a>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3">
            <table class="table">
                <thead class="bg-secondary text-light">
                    <tr>
                        <th scope="col">No</th>
                        <th scope="col">Item</th>
                        <th scope="col">Spesification</th>
                        <th scope="col">Quantity</th>
                        <th scope="col">Satuan</th>
                        <th scope="col">Harga</th>
                        <th scope="col">Keterangan</th>
                        <th scope="col" class="text-center">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    data_cmd.commandText = "SELECT DLK_T_Memo_D.*, DLK_M_Barang.Brg_Nama, DLK_M_Barang.Brg_Id FROM DLK_T_Memo_D LEFT OUTER JOIN DLK_M_Barang ON DLK_T_Memo_D.MemoItem = DLK_M_Barang.Brg_ID WHERE left(MemoID,17) = '"& dataH("MemoID") &"' ORDER BY DLK_M_Barang.Brg_Nama ASC"
                    ' response.write data_cmd.commandText
                    set dataD = data_cmd.execute

                    no = 0
                    do while not dataD.eof
                    no = no + 1

                    %>
                        <tr>
                            <th scope="row"><%= no %></th>
                            <td><%= dataD("Brg_Nama") %></td>
                            <td><%= dataD("memoSpect") %></td>
                            <td><%= dataD("memoQtty") %></td>
                            <td><% call getSatBerat(dataD("memoSatuan")) %></td>
                            <td><%= replace(formatCurrency(dataD("memoHarga")),"$","") %></td>
                            <td>
                                    <%= dataD("memoKeterangan") %>
                            </td>
                            <td class="text-center">
                                <a href="#" class="btn badge text-bg-primary modalUpdateHarga" data-iddetail="<%= dataD("memoID") %>" data-bs-toggle="modal" data-bs-target="#modalUpdateHarga">Update</a>
                            </td>
                        </tr>
                    <% 
                    dataD.movenext
                    loop
                    %>
                </tbody>
            </table>
        </div>
    </div> 
</div>

<!-- Modal -->
<div class="modal fade" id="modalUpdateHarga" tabindex="-1" aria-labelledby="modalUpdateHargaLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalUpdateHargaLabel">Rincian Barang</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
    <form action="uprice_add.asp?id=<%= id %>" method="post">
        <input type="hidden" name="memoiddetail" id="memoiddetail">
      <div class="modal-body">
         <div class="row">
            <div class="col-sm-3">
                <label for="brgUMemo" class="col-form-label">Barang</label>
            </div>
            <div class="col-sm-9 mb-3">
                <input type="text" id="brgUMemo" class="form-control" name="brgUMemo" readonly>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-3">
                <label for="spectUMemo" class="col-form-label">Sepesification</label>
            </div>
            <div class="col-sm-9 mb-3">
                <input type="text" id="spectUMemo" class="form-control" name="spectUMemo" autocomplete="off" maxlength="50" readonly required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-3">
                <label for="qttyUMemo" class="col-form-label">Quantity</label>
            </div>
            <div class="col-sm-3 mb-3">
                <input type="number" id="qttyUMemo" class="form-control" name="qttyUMemo" autocomplete="off" readonly required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-3">
                <label for="satuanUMemo" class="col-form-label">Satuan Barang</label>
            </div>
            <div class="col-sm-4 mb-3">
                <input type="text" id="satuanUMemo" class="form-control" name="satuanUMemo" autocomplete="off" readonly required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-3">
                <label for="hargaumemo" class="col-form-label">Harga</label>
            </div>
            <div class="col-sm-4 mb-3">
                <input type="number" id="hargaumemo" class="form-control" name="hargaumemo" autocomplete="off" required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-3">
                <label for="ketUMemo" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-sm-9 mb-3">
                <div class="form-floating">
                    <textarea class="form-control" placeholder="detail" id="ketUMemo" name="ketUMemo" autocomplete="off" maxlength="50" readonly></textarea>
                    <label for="ketUMemo">Detail</label>
                </div>
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
        memoiddetail = trim(Request.Form("memoiddetail"))
        hargaumemo = trim(Request.Form("hargaumemo"))
        memoid = left(memoiddetail,17)

        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandTExt = "SELECT * FROM DLK_T_Memo_D WHERE memoID = '"& memoiddetail &"'"
        ' response.write data_cmd.commandText & "<br>"
        set data = data_cmd.execute

        if not data.eof then
            call query("UPDATE DLK_T_Memo_D SET memoHarga = '"& hargaumemo &"' WHERE memoID = '"& memoiddetail &"'")
            value = 1
        else
            value = 2
        end if

        if value = 1 then
            call alert("HARGA BARANG", "berhasil di Update", "success","uprice_add.asp?id="&memoid) 
        elseif value = 2 then
            call alert("HARGA BARANG", "tidak terdaftar", "warning","uprice_add.asp?id="&memoid)
        else
            value = 0
        end if
    end if
    call footer()
%>