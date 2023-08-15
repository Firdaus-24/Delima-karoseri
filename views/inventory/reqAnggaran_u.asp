<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_reqAnggaran.asp"-->
<% 
    if session("INV1B") = false then
        Response.Redirect("./")
    end if
    
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT DLK_T_Memo_H.*, HRD_M_Departement.DepNama, GLB_M_Agen.AgenName, HRD_M_Divisi.DivNama, DLK_M_Kebutuhan.K_Name FROM DLK_T_Memo_H LEFT OUTER JOIN HRD_M_Departement ON DLK_T_Memo_H.memoDepID = HRD_M_Departement.DepID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN HRD_M_Divisi ON DLK_T_Memo_H.memoDivID = HRD_M_Divisi.divID LEFT OUTER JOIN DLK_M_Kebutuhan ON DLK_T_Memo_H.memoKebutuhan = DLK_M_Kebutuhan.K_ID WHERE memoID = '"& id &"' and memoAktifYN = 'Y'"
    ' response.write data_cmd.commandText
    set dataH = data_cmd.execute

    data_cmd.commandText = "SELECT DLK_T_Memo_D.*, DLK_M_Barang.Brg_Nama, DLK_M_Kategori.kategoriNama, DLK_M_JenisBarang.JenisNama, DLK_M_Satuanbarang.sat_nama FROM DLK_T_Memo_D LEFT OUTER JOIN DLK_M_Barang ON DLK_T_Memo_D.MemoItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KAtegoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID LEFT OUTER JOIN DLK_M_Satuanbarang ON DLK_T_Memo_D.memosatuan =  DLK_M_Satuanbarang.sat_id WHERE left(MemoID,17) = '"& dataH("MemoID") &"' ORDER BY brg_nama ASC"
    ' response.write data_cmd.commandText
    set dataD = data_cmd.execute


    ' get satuan
    data_cmd.commandText = "SELECT sat_Nama, sat_ID FROM DLK_M_satuanBarang WHERE sat_AktifYN = 'Y' ORDER BY sat_Nama ASC"
    set psatuan = data_cmd.execute    
    ' get all barang
    data_cmd.commandText = "SELECT dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Kategori.KategoriNama, DLK_M_JenisBarang.JenisNama, DLK_M_TypeBarang.T_Nama FROM dbo.DLK_M_Barang LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.JenisID LEFT OUTER JOIN DLK_M_TypeBarang ON DLK_M_Barang.BRg_Type = DLK_M_Typebarang.T_ID WHERE (dbo.DLK_M_Barang.Brg_AktifYN = 'Y') AND (left(dbo.DLK_M_Barang.Brg_Id,3) = '"& dataH("memoAgenID") &"') ORDER BY Brg_Nama ASC"
    set barang = data_cmd.execute

    ' ' cek kebutuhan
    ' data_cmd.commandText = "SELECT K_ID,K_Name FROM DLK_M_Kebutuhan WHERE K_AktifYN = 'Y' and k_id = 1 ORDER BY K_ID ASC"

    ' set ckkebutuhan = data_cmd.execute

%>
<% call header("Detail Permintaan Anggaran") %>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 text-center">
            <h3>UPDATE DETAIL PERMINTAAN ANGGARAN</h3>
        </div>  
    </div> 
    <div class="row">
        <div class="col-lg-12 mb-3 text-center labelId">
            <h3>
            <%= left(dataH("memoID"),4) &"-"& mid(dataH("memoId"),5,3) &"-"& mid(dataH("memoID"),8,3) &"/"& mid(dataH("memoID"),11,4) &"/"& right(dataH("memoID"),3) %>
            </h3>
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
            <label for="kebutuhan" class="col-form-label">Kebutuhan</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="text" id="kebutuhan" class="form-control" name="kebutuhan" value="<%= dataH("K_Name") %>" readonly>
        </div>
        <div class="col-sm-2">
            <label for="ketreqanggaranu" class="col-form-label">Keterangan</label>
        </div>
        <div class="col-sm-3 mb-3">
            <input type="text" id="ketreqanggaranu" class="form-control" name="keterangan" maxlength="50" autocomplete="off" value="<%= dataH("memoKeterangan") %>">
        </div>
        <div class='col-sm-1'>
            <button type="button" class="btn btn-outline-primary" onclick="ketupdate('<%= id %>')">Update</button>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <div class="d-flex mb-3">
                <div class="me-auto p-2">
                    <button type="button" class="btn btn-primary btn-modalPb" data-bs-toggle="modal" data-bs-target="#modalpb" onclick="tambahForm()">Tambah Rincian</button>
                </div>
                <div class="p-2">
                    <a href="reqAnggaran.asp" class="btn btn-danger">Kembali</a>
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
                        <th scope="col">Kategori</th>
                        <th scope="col">Jenis</th>
                        <th scope="col">Item</th>
                        <th scope="col">Quantity</th>
                        <th scope="col">Satuan</th>
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
                                <%=dataD("KategoriNama")%>
                            </td>
                            <td>
                                <%= dataD("jenisNama") %>
                            </td>
                            <td><%= dataD("Brg_Nama") %></td>
                            <td><%= dataD("memoQtty") %></td>
                            <td><%= dataD("sat_nama")%></td>
                            <td>
                                <%= dataD("memoKeterangan") %>
                            </td>
                            <td class="text-center">
                                <% if session("INV1B") = true then %>
                                    <button class="btn badge text-bg-primary" data-bs-toggle="modal" data-bs-target="#modalpb" onclick="updateForm('<%=dataD("memoid")%>','<%=dataD("MemoItem")%>','<%= dataD("memoQtty") %>','<%= dataD("memoSatuan")%>','<%= dataD("memoketerangan")%>')" >Update</button>
                                <%end if%>
                                <%if session("INV1C") = true then%>
                                    <a href="reqaktifD.asp?id=<%= dataD("memoID") %>" class="btn badge text-bg-danger" onclick="deleteItem(event,'Detail Anggaran Barang')">delete</a>
                                <%else%>
                                    -
                                <%end if%>
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
    <form action="reqAnggaran_u.asp?id=<%= id %>" method="post">
        <input type="hidden" name="memoid" id="memoid" value="<%= id %>">
        <input type="hidden" name="iddreqanggaran" id="iddreqanggaran" >
        <input type="hidden" name="pbcabang" id="pbcabang" value="<%= dataH("memoAgenID") %>">
      <div class="modal-body">
        <div class="row rowCpBarang">
            <div class="col-sm-3">
                <label for="cpbarang" class="col-form-label">Cari Barang</label>
            </div>
            <div class="col-sm-9 mb-3">
                <input type="text" id="cpbarang" class="form-control" name="cpbarang" autocomplete="off" onkeyup="GetNamabgrAnggaran(this.value)">
            </div>
        </div>
        <!-- table barang -->
        <div class="row">
            <div class="col-sm mb-4 overflow-auto" style="height:15rem; font-size:12px;">
                <table class="table">
                    <thead class="bg-secondary text-light" style="position: sticky;top: 0;">
                        <tr>
                            <th scope="col">Kode</th>
                            <th scope="col">Nama</th>
                            <th scope="col">Type</th>
                            <th scope="col">Pilih</th>
                        </tr>
                    </thead>
                    <tbody  class="contentdetailpbrg">
                        <% do while not barang.eof %>
                        <tr>
                            <th scope="row"><%= barang("kategoriNama")&" - "& barang("jenisNama") %></th>
                            <td><%= barang("brg_nama") %></td>
                            <td><%= barang("T_Nama") %></td>
                            <td>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="brg" id="brganggaranupdate" value="<%= barang("Brg_ID") %>" required>
                                </div>
                            </td>
                        </tr>
                        <% 
                        Response.flush
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
<script>
    let ainun = null;
    const updateForm = (id,brgid, qty, satuan, keterangan) => {
        let varbrg = null
        $("#iddreqanggaran").val(id)
        $(".rowCpBarang").show()
        $('input:radio[name=brg]').filter(`[value=${brgid}]`).prop('checked', true);
        $("#qtty").val(qty)
        $("#satuan").val(satuan)
        $("#keterangan").val(keterangan)
        ainun = brgid
    }
    const tambahForm = () => {
        $("#iddreqanggaran").val("")
        $(".rowCpBarang").show()
        $('input:radio[name=brg]').prop('checked', false);
        $("#qtty").val(0)
        $("#satuan").val("")
        $("#keterangan").val("keterangan")
        ainun = null
    }
    const ketupdate = (id) => {
        let keterangan = $("#ketreqanggaranu").val()
        $.ajax({
        method: "POST",
        url: "keterangananggaran_u.asp",
        data: { id, keterangan },
        }).done(function (msg) {
            swal({
                title: "YAKIN UNTUK DI UPDATE?",
                text: "",
                icon: "warning",
                buttons: true,
                dangerMode: true,
                })
                .then((willDelete) => {
                if (willDelete) {
                   location.reload();
                } else {
                    swal("gagal diupdate");
                }
            });
        });
    }
    // get nama barang by vendor
    const GetNamabgrAnggaran = (e) => {
        let nama = e;
        let cabang = $("#pbcabang").val();
        $.ajax({
            method: "POST",
            url: "../../ajax/getbrgvendor.asp",
            data: { nama, cabang },
        }).done(function (msg) {
            $(".contentdetailpbrg").html(msg);
            $("input:radio[name=brg]").filter(`[value=${ainun}]`).prop("checked", true);
        });
    };
</script>
<% 
    if Request.ServerVariables("REQUEST_METHOD") = "POST" then
        if Request.Form("iddreqanggaran") = "" then 
            call updateAnggaran()
        else
            call updateDetail()
        end if
    end if
    call footer()
%>