<!--#include file="../../init.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT DLK_T_Memo_H.*, DLK_M_Departement.DepNama FROM DLK_T_Memo_H LEFT OUTER JOIN DLK_M_Departement ON DLK_T_Memo_H.memoDepID = DLK_M_Departement.DepID WHERE memoID = '"& id &"' and memoAktifYN = 'Y'"
    ' response.write data_cmd.commandText
    set dataH = data_cmd.execute
    ' get satuan
    data_cmd.commandText = "SELECT sat_Nama, sat_ID FROM DLK_M_satuanBarang WHERE sat_AktifYN = 'Y' ORDER BY sat_Nama ASC"
    set psatuan = data_cmd.execute    
    ' get all barang
    data_cmd.commandText = "SELECT dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Kategori.KategoriNama, DLK_M_JenisBarang.JenisNama FROM dbo.DLK_M_Barang LEFT OUTER JOIN dbo.DLK_T_VendorD ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_VendorD.Dven_BrgID LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.JenisID WHERE (dbo.DLK_T_VendorD.Dven_BrgID <> '') AND (dbo.DLK_M_Barang.Brg_AktifYN = 'Y') AND (left(dbo.DLK_M_Barang.Brg_Id,3) = '"& dataH("memoAgenID") &"') GROUP BY dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Kategori.KategoriNama, DLK_M_JenisBarang.JenisNama ORDER BY Brg_Nama ASC"
    set barang = data_cmd.execute
%>
<% call header("Detail Permintaan Barang") %>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 mb-3 text-center">
            <h3>UPDATE DETAIL PERMINTAAN BARANG</h3>
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
                <div class="me-auto p-2">
                    <button type="button" class="btn btn-primary btn-modalPb" data-bs-toggle="modal" data-bs-target="#modalpb">Tambah Rincian</button>
                </div>
                <div class="p-2">
                    <a href="approvepb.asp" class="btn btn-danger">Kembali</a>
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
                            <td>
                                    <%= dataD("memoKeterangan") %>
                            </td>
                            <td class="text-center">
                                <a href="aktifapprovepb.asp?id=<%= dataD("memoID") %>" class="btn badge text-bg-danger btn-aktifdpbarang">delete</a>
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
<div class="modal fade" id="modalpb" tabindex="-1" aria-labelledby="modalpbLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalpbLabel">Rincian Barang</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
    <form action="dapprovepb.asp?id=<%= id %>" method="post">
        <input type="hidden" name="memoid" id="memoid" value="<%= id %>">
        <input type="hidden" name="pbcabang" id="pbcabang" value="<%= dataH("memoAgenID") %>">
      <div class="modal-body">
         <div class="row">
            <div class="col-sm-3">
                <label for="cpbarang" class="col-form-label">Cari Barang</label>
            </div>
            <div class="col-sm-9 mb-3">
                <input type="text" id="cpbarang" class="form-control" name="cpbarang">
            </div>
        </div>
        <!-- table barang -->
        <div class="row">
            <div class="col-sm mb-4 overflow-auto" style="height:15rem;">
                <table class="table">
                    <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
                        <tr>
                            <th scope="col">Kode</th>
                            <th scope="col">Nama</th>
                            <th scope="col">Pilih</th>
                        </tr>
                    </thead>
                    <tbody  class="contentdetailpbrg">
                        <% do while not barang.eof %>
                        <tr>
                            <th scope="row"><%= barang("kategoriNama")&"-"& barang("jenisNama") %></th>
                            <td><%= barang("brg_nama") %></td>
                            <td>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="brg" id="brg" value="<%= barang("Brg_ID") %>" required>
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
                <label for="spect" class="col-form-label">Sepesification</label>
            </div>
            <div class="col-sm-9 mb-3">
                <input type="text" id="spect" class="form-control" name="spect" autocomplete="off" maxlength="50" required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-3">
                <label for="qtty" class="col-form-label">Quantity</label>
            </div>
            <div class="col-sm-3 mb-3">
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
            <div class="col-sm-3">
                <label for="ket" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-sm-9 mb-3">
                <div class="form-floating">
                    <textarea class="form-control" placeholder="detail" id="ket" name="ket" autocomplete="off" maxlength="50"></textarea>
                    <label for="ket">Detail</label>
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
        memoid = trim(Request.Form("memoid"))
        brg = trim(Request.Form("brg"))
        spect = trim(Request.Form("spect"))
        qtty = trim(Request.Form("qtty"))
        satuan = trim(Request.Form("satuan"))
        ket = trim(Request.Form("ket"))

        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandTExt = "SELECT * FROM DLK_T_Memo_D WHERE left(memoID,17) = '"& memoid &"' AND memoItem = '"& brg &"'"
        ' response.write data_cmd.commandText & "<br>"
        set data = data_cmd.execute

            if data.eof then
            data_cmd.commandTExt = "SELECT TOP 1 (right(memoID,3)) + 1 AS urut FROM DLK_T_Memo_D WHERE left(memoID,17) = '"& memoid &"' order by memoID desc"
            ' response.write data_cmd.commandText & "<br>"
            set p = data_cmd.execute

            nol = "000"
                if p.eof then   
                    data_cmd.commandTExt = "SELECT (COUNT(memoID)) + 1 AS urut FROM DLK_T_Memo_D WHERE left(memoID,17) = '"& memoid &"'"
                    ' response.write data_cmd.commandText & "<br>"
                    set a = data_cmd.execute

                    iddetail = memoid & right(nol & a("urut"),3)

                    call query("INSERT INTO DLK_T_Memo_D (memoID, memoItem, memoSpect, memoQtty, memoSatuan, memoKeterangan, memoHarga) VALUES ( '"& iddetail &"','"& brg &"', '"& spect &"', "& qtty &",'"& satuan &"','"& ket &"', '0')")
                else
                    iddetail = memoid & right(nol & p("urut"),3)

                    call query("INSERT INTO DLK_T_Memo_D (memoID, memoItem, memoSpect, memoQtty, memoSatuan, memoKeterangan, memoHarga) VALUES ( '"& iddetail &"','"& brg &"', '"& spect &"', "& qtty &",'"& satuan &"','"& ket &"', '0')")
                end if
            value = 1
        else
            value = 2
        end if

        if value = 1 then
            call alert("RINCIAN PERMINTAAN BARANG", "berhasil di tambahkan", "success","dapprovepb.asp?id="&memoid) 
        elseif value = 2 then
            call alert("RINCIAN PERMINTAAN BARANG", "sudah terdaftar", "warning","dapprovepb.asp?id="&memoid)
        else
            value = 0
        end if
    end if
    call footer()
%>