<!--#include file="../../init.asp"-->
<% 
    if session("PR3A") = false then
        Response.Redirect("./")
    end if
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT DLK_T_Memo_H.*, HRD_M_Departement.DepNama, GLB_M_Agen.AgenName, HRD_M_Divisi.DivNama, DLK_M_Kebutuhan.K_Name FROM DLK_T_Memo_H LEFT OUTER JOIN HRD_M_Departement ON DLK_T_Memo_H.memoDepID = HRD_M_Departement.DepID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN HRD_M_Divisi ON DLK_T_Memo_H.memoDivID = HRD_M_Divisi.divID LEFT OUTER JOIN DLK_M_Kebutuhan ON DLK_T_Memo_H.memoKebutuhan = DLK_M_Kebutuhan.K_ID  WHERE memoID = '"& id &"' and memoAktifYN = 'Y'"
    ' response.write data_cmd.commandText
    set dataH = data_cmd.execute

    data_cmd.commandText = "SELECT DLK_T_Memo_D.*, DLK_M_Barang.Brg_Nama, DLK_M_Barang.Brg_Id, DLK_M_kategori.kategoriNama, DLK_M_JenisBarang.jenisNama,DLK_M_TypeBarang.T_Nama, DLK_M_SatuanBarang.sat_nama FROM DLK_T_Memo_D LEFT OUTER JOIN DLK_M_Barang ON DLK_T_Memo_D.MemoItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.kategoriID = DLK_M_Kategori.kategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID LEFT OUTER JOIN DLK_M_TypeBarang ON DLK_M_Barang.Brg_type = DLK_M_TypeBarang.T_ID LEFT OUTER JOIN DLK_M_Satuanbarang ON DLK_T_Memo_D.memosatuan = DLK_M_Satuanbarang.sat_id WHERE left(MemoID,17) = '"& dataH("MemoID") &"' ORDER BY DLK_M_Barang.Brg_Nama ASC"
    ' response.write data_cmd.commandText
    set dataD = data_cmd.execute

   
%>
<% call header("UPDATE HARGA BARANG") %>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 text-center">
            <h3>UPDATE HARGA PERMINTAAN BARANG</h3>
        </div>  
    </div> 
    <div class="row">
        <div class="col-lg-12 mb-3 text-center labelId">
            <h3><%= left(dataH("memoID"),4) %>/<%= mid(dataH("memoId"),5,3) %>-<% call getAgen(mid(dataH("memoID"),8,3),"") %>/<%= mid(dataH("memoID"),11,4) %>/<%= right(dataH("memoID"),3) %></h3>
        </div>  
    </div> 
    <div class="row">
        <div class="col-sm-2">
            <label for="tgl" class="col-form-label">Tanggal</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="text" id="tgl" class="form-control" name="tgl" value="<%= Cdate(dataH("memoTgl")) %>" readonly>
        </div>
        <div class="col-sm-2">
            <label for="agen" class="col-form-label">Cabang / Agen</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="text" id="agen" class="form-control" name="agen" value="<%= dataH("agenNAme") %>" readonly>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-2">
            <label for="divisi" class="col-form-label">Divisi</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="text" id="divisi" class="form-control" name="divisi" value="<%= dataH("divNama") %>" readonly>
        </div>
        <div class="col-sm-2">
            <label for="departement" class="col-form-label">Departement</label>
        </div>
        <div class="col-sm-4">
            <input type="text" id="departement" class="form-control" name="departement" value="<%= dataH("depnama") %>" readonly>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-2">
            <label for="No.B.O.M Repair" class="col-form-label">No.B.O.M Repair</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="text" id="No.B.O.M Repair" class="form-control" name="No.B.O.M Repair" <%if datah("memobmrid") <> "" then %> value="<%=left(dataH("memoBMRID"),3)&"-"&MID(dataH("memoBMRID"),4,3)&"/"&MID(dataH("memoBMRID"),7,4)&"/"&right(dataH("memoBMRID"),3)%>" <%end if%> readonly>
        </div>
        <div class="col-sm-2">
            <label for="bomproject" class="col-form-label">No. B.O.M Project</label>
        </div>
        <div class="col-sm-4">
            <input type="text" id="bomproject" class="form-control" name="bomproject" <%if datah("memobmid") <> "" then %>  value="<%= left(datah("memobmid"),2) %>-<%=mid(datah("memobmid"),3,3) %>/<%= mid(datah("memobmid"),6,4) %>/<%= right(datah("memobmid"),3) %>" <%end if%> readonly>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-2">
            <label for="kebutuhan" class="col-form-label">Kebutuhan</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="text" id="kebutuhan" class="form-control" name="kebutuhan" value="<%= dataH("K_Name") %>" readonly>
        </div>
        <div class="col-sm-2">
            <label for="keterangan" class="col-form-label">Keterangan</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="text" id="keterangan" class="form-control" name="keterangan" maxlength="50" autocomplete="off" value="<%= dataH("memoKeterangan") %>" readonly>
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
                        <th scope="col">Kode</th>
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
                    no = 0
                    do while not dataD.eof
                    no = no + 1

                    %>
                        <tr>
                            <th scope="row"><%= no %></th>
                            <td>
                                <%= dataD("kategoriNama") &" - "& dataD("JenisNama") %>
                            </td>
                            <td><%= dataD("Brg_Nama") %></td>
                            <td><%= dataD("memoSpect") %></td>
                            <td><%= dataD("memoQtty") %></td>
                            <td><%= dataD("sat_nama") %></td>
                            <td><%= replace(replace(formatCurrency(dataD("memoHarga")),"$",""),".00","") %></td>
                            <td>
                                    <%= dataD("memoKeterangan") %>
                            </td>
                            <td class="text-center">
                                <a href="#" class="btn badge text-bg-primary" onclick="getUpricePurchase('<%= dataD("memoID") %>','<%= dataD("Brg_Nama") %>','<%= dataD("memoSpect") %>','<%= dataD("memoQtty") %>','<%= dataD("sat_nama") %>', '<%= dataD("memoKeterangan") %>', '<%= replace(replace(formatCurrency(dataD("memoHarga")),"$",""),".00","") %>')" data-bs-toggle="modal" data-bs-target="#modalUpdateHarga">Update</a>
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
    <form action="uprice_add.asp?id=<%= id %>" method="post" id="Uprice" onsubmit="validasiForm(this,event,'Update Harga Permintaan Anggaran Inventori','warning')">
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
                <input type="text" id="hargaumemo" class="form-control" name="hargaumemo" autocomplete="off" onchange="settingFormatRupiah(this.value, 'hargaumemo')" inputmode="Numeric" required>
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
        hargaumemo = replace(replace(replace(trim(Request.Form("hargaumemo")),",",""),".",""),"-","")

        set data_cmd =  Server.CreateObject ("ADODB.Command")
        data_cmd.ActiveConnection = mm_delima_string

        data_cmd.commandTExt = "SELECT * FROM DLK_T_Memo_D WHERE memoID = '"& memoiddetail &"'"
        ' response.write data_cmd.commandText & "<br>"
        set data = data_cmd.execute

        if not data.eof then
            call query("UPDATE DLK_T_Memo_D SET memoHarga = '"& hargaumemo &"' WHERE memoID = '"& memoiddetail &"'")
            call alert("HARGA BARANG", "berhasil di Update", "success",Request.ServerVariables("HTTP_REFERER")) 
        else
            call alert("HARGA BARANG", "tidak terdaftar", "warning",Request.ServerVariables("HTTP_REFERER"))
        end if

    end if
    call footer()
%>