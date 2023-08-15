<!--#include file="../connections/cargo.asp"-->
<!--#include file="../url.asp"-->
<% 
  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT DLK_T_Memo_H.*, HRD_M_Departement.DepNama, GLB_M_Agen.AgenName, HRD_M_Divisi.DivNama, DLK_M_Kebutuhan.K_Name, DLK_M_Weblogin.RealName FROM DLK_T_Memo_H LEFT OUTER JOIN HRD_M_Departement ON DLK_T_Memo_H.memoDepID = HRD_M_Departement.DepID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN HRD_M_Divisi ON DLK_T_Memo_H.memoDivID = HRD_M_Divisi.divID LEFT OUTER JOIN DLK_M_Kebutuhan ON DLK_T_Memo_H.memoKebutuhan = DLK_M_Kebutuhan.K_ID LEFT OUTER JOIN DLK_M_WebLogin ON DLK_T_Memo_H.memoupdateid = DLK_M_Weblogin.userid WHERE memoID = '"& id &"' and memoAktifYN = 'Y'"
  ' response.write data_cmd.commandText
  set dataH = data_cmd.execute

  ' detail
  data_cmd.commandText = "SELECT DLK_T_Memo_D.*, DLK_M_Barang.Brg_Nama, DLK_M_Kategori.kategoriNama, DLK_M_JenisBarang.JenisNama, DLK_M_SatuanBarang.Sat_nama, DLK_M_TypeBarang.T_Nama FROM DLK_T_Memo_D LEFT OUTER JOIN DLK_M_Barang ON DLK_T_Memo_D.MemoItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KAtegoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID LEFT OUTER JOIN DLK_M_satuanbarang ON DLK_T_Memo_D.memosatuan = dlk_M_Satuanbarang.sat_ID LEFT OUTER JOIN DLK_M_TypeBarang ON DLK_M_Barang.BRg_Type = DLK_M_Typebarang.T_ID WHERE left(MemoID,17) = '"& dataH("MemoID") &"' ORDER BY DLK_M_TypeBarang.T_Nama, DLK_M_Barang.Brg_Nama ASC"

  set dataD = data_cmd.execute

%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Detail Permintaan Anggaran</title>
  <link href="../public/css/bootstrap.min.css" rel="stylesheet" />
  <script src="../public/js/bootstrap.bundle.min.js"></script>
  <!-- sweet alert -->
  <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
  <link href='../public/img/delimalogo.png' rel='website icon' type='png' />
</head>
<body>
  <div class="container">
    <div class="row">
      <div class="col-lg-12 mt-3 text-center">
        <h3>DETAIL PERMINTAAN ANGGARAN</h3>
      </div>  
    </div> 
    <div class="row">
      <div class="col-lg-12 mb-3 text-center">
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
        <label for="bmrid" class="col-form-label">No. B.O.M</label>
      </div>
      <div class="col-sm-4 mb-3">
        <input type="text" class="form-control" autocomplete="off" <%if datah("memobmid") <> "" then%> value="<%= left(datah("memobmid"),2) %>-<%=mid(datah("memobmid"),3,3) %>/<%= mid(datah("memobmid"),6,4) %>/<%= right(datah("memobmid"),3) %>" onClick="window.open('bomproject.asp?id=<%=datah("memobmid")%>', '_self')" <%elseIf datah("memobmrid") <> "" then%> value="<%= left(datah("memobmrid"),3) %>-<%=mid(datah("memobmrid"),4,3) %>/<%= mid(datah("memobmrid"),7,4) %>/<%= right(datah("memobmrid"),3) %>" onClick="window.open('bomrepair.asp?id=<%=datah("memobmrid")%>', '_self')"  <%end if%> style="cursor:pointer;" readonly>
      </div>
      <div class="col-sm-2">
        <label for="prodderector" class="col-form-label">No Produksi</label>
      </div>
      <div class="col-sm-4 mb-3">
        <input type="text" id="prodderector" class="form-control" name="prodderector" <%if datah("memopdhid") <> "" then %> value="<%= left(datah("memopdhid"),2) %>-<%= mid(datah("memopdhid"),3,3) %>/<%= mid(datah("memopdhid"),6,4) %>/<%= right(datah("memopdhid"),4)  %>" onclick="window.open('detailproduksi.asp?id=<%= datah("memopdhid")%>', '_self')" <%end if%> style="cursor:pointer;" readonly>
      </div>
    </div>
    <div class='row'>
      <div class="col-sm-2">
        <label for="kebutuhan" class="col-form-label">Kebutuhan</label>
      </div>
      <div class="col-sm-4 mb-3">
        <input type="text" id="kebutuhan" class="form-control" name="kebutuhan" value="<%= dataH("K_name") %>" readonly>
      </div>
      <div class="col-sm-2">
        <label for="directorcapasity" class="col-form-label">Capasity</label>
      </div>
      <div class="col-sm-4 mb-3">
        <input type="text" id="directorcapasity" class="form-control" name="directorcapasity" autocomplete="off" <%if datah("memobmid") <> "" OR datah("memobmrid") <> "" then%> value="<%= dataH("memocapacty") %> Unit" <%else%> value="0" <%end if%> readonly>
      </div>
    </div>
    <div class='row'>
      <div class="col-sm-2">
        <label for="directorPengaju" class="col-form-label">Pengaju</label>
      </div>
      <div class="col-sm-4 mb-3">
        <input type="text" id="directorPengaju" class="form-control" name="directorPengaju"  autocomplete="off" value="<%= dataH("realname") %>" readonly>
      </div>
      <div class="col-sm-2">
        <label for="keterangan" class="col-form-label">Keterangan</label>
      </div>
      <div class="col-sm-4 mb-3">
        <input type="text" id="keterangan" class="form-control" name="keterangan" maxlength="50" autocomplete="off" value="<%= dataH("memoKeterangan") %>" readonly>
      </div>
    </div>
    <div class="row">
      <div class="d-flex mb-3">
        <% if session("INV10D") = true then  %>
        <div class="me-auto p-2">
          <button type="button" class="btn btn-secondary" onClick="window.open('print-anggaran.asp?id=<%=id%>')" class="btn btn-secondary">Export</button>
        </div>
        <% end if %>
        <div class="p-2">
          <a href="./" class="btn btn-danger">Kembali</a>
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
                  <%=dataD("KategoriNama") %>
                </td>
                <td>
                  <%=  dataD("jenisNama") %>
                </td>
                <td><%= dataD("Brg_Nama") %></td>
                <td><%= dataD("memoQtty") %></td>
                <td><%= realstok %></td>
                <td><%= dataD("sat_nama") %></td>
                <td><%= dataD("T_nama") %></td>
                <td>
                    <%= dataD("memoKeterangan") %>
                </td>
              </tr>
              <% 
              response.flush
              dataD.movenext
              loop
              %>
          </tbody>
        </table>
      </div>
    </div> 
  </div>
  <!-- jquery -->
  <script src="../../public/js/jquery-min.js"></script>
  <!-- bootstrap -->
  <script src="../../public/js/bootstrap.min.js"></script>
</body>
</html>