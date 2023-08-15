<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_revisibomrepair.asp"-->
<% 
  if session("INV9B") = false then
    Response.Redirect("./")
  end if
    
  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string
  ' header
  data_cmd.commandText = "SELECT DLK_T_Memo_H.*, HRD_M_Departement.DepNama, GLB_M_Agen.AgenName, HRD_M_Divisi.DivNama, DLK_M_Kebutuhan.K_Name FROM DLK_T_Memo_H LEFT OUTER JOIN HRD_M_Departement ON DLK_T_Memo_H.memoDepID = HRD_M_Departement.DepID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN HRD_M_Divisi ON DLK_T_Memo_H.memoDivID = HRD_M_Divisi.divID LEFT OUTER JOIN DLK_M_Kebutuhan ON DLK_T_Memo_H.memoKebutuhan = DLK_M_Kebutuhan.K_ID WHERE memoID = '"& id &"' and memoAktifYN = 'Y' AND memobmrid <> '' AND memobmid = ''"
  ' response.write data_cmd.commandText
  set dataH = data_cmd.execute
  ' detail
  data_cmd.commandText = "SELECT DLK_T_Memo_D.*, DLK_M_Barang.Brg_Nama, DLK_M_Kategori.kategoriNama, DLK_M_JenisBarang.JenisNama, DLK_M_TypeBarang.T_Nama, DLK_M_SatuanBarang.sat_nama FROM DLK_T_Memo_D LEFT OUTER JOIN DLK_M_Barang ON DLK_T_Memo_D.MemoItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KAtegoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID LEFT OUTER JOIN DLK_M_TypeBarang ON DLK_M_Barang.BRg_Type = DLK_M_Typebarang.T_ID LEFT OUTER JOIN DLK_M_SatuanBarang ON DLK_T_Memo_D.memosatuan = DLK_M_Satuanbarang.sat_ID WHERE left(MemoID,17) = '"& dataH("MemoID") &"' ORDER BY DLK_M_TypeBarang.T_Nama, DLK_M_Barang.Brg_Nama ASC"
  ' response.write data_cmd.commandText
  set dataD = data_cmd.execute

  ' get satuan
  data_cmd.commandText = "SELECT sat_Nama, sat_ID FROM DLK_M_satuanBarang WHERE sat_AktifYN = 'Y' ORDER BY sat_Nama ASC"
  set psatuan = data_cmd.execute    
  ' get all barang
  data_cmd.commandText = "SELECT dbo.DLK_M_Barang.Brg_Id, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_M_Kategori.KategoriNama, DLK_M_JenisBarang.JenisNama, DLK_M_TypeBarang.T_Nama FROM dbo.DLK_M_Barang LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KategoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.JenisID LEFT OUTER JOIN DLK_M_TypeBarang ON DLK_M_Barang.BRg_Type = DLK_M_Typebarang.T_ID WHERE (dbo.DLK_M_Barang.Brg_AktifYN = 'Y') AND (left(dbo.DLK_M_Barang.Brg_Id,3) = '"& dataH("memoAgenID") &"') ORDER BY Brg_Nama ASC"
  set barang = data_cmd.execute

%>
<% call header("Detail Permintaan Anggaran") %>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-lg-12 mt-3 text-center">
      <h3>DETAIL PERMINTAAN ANGGARAN B.O.M REPAIR</h3>
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
      <label for="keterangan" class="col-form-label">No. B.O.M</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" id="keterangan" class="form-control" name="keterangan" maxlength="50" autocomplete="off" value="<%= left(datah("memoBMRID"),3)&"-"&MID(datah("memoBMRID"),4,3)&"/"&MID(datah("memoBMRID"),7,4)&"/"&right(datah("memoBMRID"),3) %>" readonly>
    </div>
  </div>
  <div class='row'>
    <div class="col-sm-2">
      <label for="ketheader" class="col-form-label">Keterangan</label>
    </div>
    <div class="col-sm-10 mb-3">
      <input type="text" id="ketheader" class="form-control" name="keterangan" maxlength="50" autocomplete="off" value="<%= dataH("memoKeterangan") %>" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <div class="d-flex mb-3">
        <div class="me-auto p-2">
          <button type="button" class="btn btn-primary btn-modalPbrepair" data-bs-toggle="modal" data-bs-target="#modalpbrepair" onclick="tambahForm()">Tambah Rincian</button>
        </div>
        <div class="p-2">
          <a href="./" class="btn btn-danger">Kembali</a>
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
            <th scope="col">Qty</th>
            <th scope="col">Stok</th>
            <th scope="col">Satuan</th>
            <th scope="col">Type</th>
            <th scope="col">Keterangan</th>
            <th scope="col" class="text-center">Aksi</th>
          </tr>
        </thead>
        <tbody>
          <% 
          no = 0
          do while not dataD.eof
          no = no + 1
          
          ' incoming outgoing
          data_cmd.commandText = "select Brg_Nama, Brg_MinStok, ISNULL((SELECT SUM(dbo.DLK_T_MaterialReceiptD2.MR_Qtysatuan) AS qtymr FROM dbo.DLK_M_Barang RIGHT OUTER JOIN dbo.DLK_T_MaterialReceiptD2 ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_MaterialReceiptD2.MR_Item GROUP BY dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_T_MaterialReceiptD2.MR_Item HAVING (dbo.DLK_T_MaterialReceiptD2.MR_Item = '"& dataD("MemoItem") &"')) - ((SELECT SUM(dbo.DLK_T_MaterialOutD.MO_Qtysatuan) AS qty FROM dbo.DLK_M_Barang RIGHT OUTER JOIN dbo.DLK_T_MaterialOutD ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_MaterialOutD.MO_Item GROUP BY dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_T_MaterialOutD.MO_Item HAVING (dbo.DLK_T_MaterialOutD.MO_Item = '"& dataD("MemoItem") &"')) ),0) as stok FROM DLK_M_Barang WHERE Brg_ID = '"& dataD("MemoItem") &"' GROUP BY Brg_Nama, Brg_MinStok"
          ' Response.Write data_cmd.commandText & "<br>"
          set ckstok = data_cmd.execute

          ' delete barang
          data_cmd.commandText = "SELECT ISNULL(SUM(dbo.DLK_T_DelBarang.DB_QtySatuan),0) AS qtydel FROM dbo.DLK_M_Barang LEFT OUTER JOIN dbo.DLK_T_DelBarang ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_T_DelBarang.DB_Item GROUP BY dbo.DLK_T_DelBarang.DB_Item, dbo.DLK_T_DelBarang.DB_AktifYN HAVING (dbo.DLK_T_DelBarang.DB_AktifYN = 'Y') AND (dbo.DLK_T_DelBarang.DB_Item = '"& dataD("MemoItem") &"')"

          set ckdelbarang = data_cmd.execute

          if not ckstok.eof then
            stok = ckstok("stok")
          else
            stok = 0
          end if

          if not ckdelbarang.eof then
            delbrg = ckdelbarang("qtydel")
          else
            delbrg = 0
          end if

          realstok = Cint(stok) - Cint(delbrg)

          If realstok = 0 then
            bgrow = "bg-danger"
            ckstyle = "style='--bs-bg-opacity: .5;'"
          elseif Cint(ckstok("Brg_minstok")) >= realstok then
            bgrow = "bg-warning"
            ckstyle = "style='--bs-bg-opacity: .5;'"
          elseif Cint(ckstok("Brg_minstok")) <= realstok then
            ckstyle = ""
            bgrow = ""
          end if
          %>
            <tr class="<%=bgrow%>" <%=ckstyle%>>
              <th scope="row"><%= no %></th>
              <td>
                <%= dataD("KategoriNama") %>
              </td>
              <td>
                <%= dataD("jenisNama") %>
              </td>
              <td><%= dataD("Brg_Nama") %></td>
              <td><%= dataD("memoQtty") %></td>
              <td><%= realstok %></td>
              <td><%= dataD("Sat_Nama") %></td>
              <td><%= dataD("T_nama") %></td>
              <td>
                  <%= dataD("memoKeterangan") %>
              </td>
              <td class="text-center">
                <% if session("INV1B") = true then %>
                  <button class="btn badge text-bg-primary" data-bs-toggle="modal" data-bs-target="#modalpbrepair" onclick="updateForm('<%=dataD("memoid")%>','<%=dataD("MemoItem")%>','<%= dataD("memoQtty") %>','<%= dataD("memoSatuan")%>','<%= dataD("memoketerangan")%>')" style='--bs-bg-opacity: 1;' >Update</button>
                <%end if%>
                <% if session("INV9C") = true then%>
                  <a href="aktifd.asp?id=<%= dataD("memoID") %>" class="btn badge text-bg-danger" onclick="deleteItem(event,'Detail Anggaran Barang')" style='--bs-bg-opacity: 1;'>delete</a>
                <% end if %>
              </td>
            </tr>
          <% 
          Response.flush
          dataD.movenext
          loop
          %>
        </tbody>
      </table>
    </div>
  </div> 
</div>

<!-- Modal -->
<div class="modal fade" id="modalpbrepair" tabindex="-1" aria-labelledby="modalpbrepairLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalpbrepairLabel">Rincian Barang</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
    <form action="update.asp?id=<%= id %>" method="post" onsubmit="validasiForm(this, event, 'Detail permintaan B.O.M repair','warning')">
        <input type="hidden" name="memoid" id="memoid" value="<%= id %>">
        <input type="hidden" name="memoidrepair" id="memoidrepair">
        <input type="hidden" name="pbcabang" id="pbcabang" value="<%= dataH("memoAgenID") %>">
      <div class="modal-body">
        <div class="row rowCpBarangrepair">
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
                  <th scope="row"><%= barang("kategoriNama")&"-"& barang("jenisNama") %></th>
                  <td><%= barang("brg_nama") %></td>
                  <td><%= barang("T_Nama") %></td>
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
                <label for="ketdetailreqrepair" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-sm-9 mb-3">
                <div class="form-floating">
                    <textarea class="form-control" placeholder="detail" id="ketdetailreqrepair" name="ket" autocomplete="off" maxlength="50"></textarea>
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
  let brgAnggranrepair = null;
  const updateForm = (id,brgid, qty, satuan, keterangan) => {
    $("#memoidrepair").val(id)
    $('input:radio[name=brg]').filter(`[value=${brgid}]`).prop('checked', true);
    $("#qtty").val(qty)
    $("#satuan").val(satuan)
    $("#ketdetailreqrepair").val(keterangan)
    brgAnggranrepair = brgid
  }
  const tambahForm = () => {
    $("#memoidrepair").val("")
    $('input:radio[name=brg]').prop('checked', false);
    $("#qtty").val(0)
    $("#satuan").val("")
    $("#ketdetailreqrepair").val("")
    brgAnggranrepair = null
  }
  // get nama barang by vendor
  const GetNamabgrAnggaran = (e) => {
    let nama = e
    let cabang = $("#pbcabang").val();
    $.ajax({
    method: "POST",
    url: "../../ajax/getbrgvendor.asp",
    data: { nama, cabang },
    }).done(function (msg) {
      $(".contentdetailpbrg").html(msg);
      $('input:radio[name=brg]').filter(`[value=${brgAnggranrepair}]`).prop('checked', true);
    });
  }
</script>
<% 
  if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    if Request.Form("memoidrepair") = "" then
      call updateAnggaran()
    elseif Request.Form("memoidrepair") <> "" then
      call updateDetail()
    end if
  end if
  call footer()
%>