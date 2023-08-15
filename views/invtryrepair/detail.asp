<!--#include file="../../init.asp"-->
<% 
  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT DLK_T_Memo_H.*, HRD_M_Departement.DepNama, GLB_M_Agen.AgenName, HRD_M_Divisi.DivNama, DLK_M_Kebutuhan.K_Name FROM DLK_T_Memo_H LEFT OUTER JOIN HRD_M_Departement ON DLK_T_Memo_H.memoDepID = HRD_M_Departement.DepID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN HRD_M_Divisi ON DLK_T_Memo_H.memoDivID = HRD_M_Divisi.divID LEFT OUTER JOIN DLK_M_Kebutuhan ON DLK_T_Memo_H.memoKebutuhan = DLK_M_Kebutuhan.K_ID WHERE memoID = '"& id &"' and memoAktifYN = 'Y' AND memobmrid <> '' AND memobmid = '' "
  ' response.write data_cmd.commandText
  set dataH = data_cmd.execute

  data_cmd.commandText = "SELECT DLK_T_Memo_D.*, DLK_M_Barang.Brg_Nama, DLK_M_Kategori.kategoriNama, DLK_M_JenisBarang.JenisNama,  DLK_M_TypeBarang.T_Nama, DLK_M_SatuanBarang.Sat_nama FROM DLK_T_Memo_D LEFT OUTER JOIN DLK_M_Barang ON DLK_T_Memo_D.MemoItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KAtegoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID LEFT OUTER JOIN DLK_M_TypeBarang ON DLK_M_Barang.BRg_Type = DLK_M_Typebarang.T_ID LEFT OUTER JOIN DLK_M_satuanbarang ON DLK_T_Memo_D.memosatuan = dlk_M_Satuanbarang.sat_ID WHERE left(MemoID,17) = '"& dataH("MemoID") &"' ORDER BY DLK_M_TypeBarang.T_Nama, DLK_M_Barang.Brg_Nama ASC"
  ' response.write data_cmd.commandText
  set dataD = data_cmd.execute


%>
<% call header("Detail Revisi") %>
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
      <input type="text" id="kebutuhan" class="form-control" name="kebutuhan" value="<%= dataH("K_name") %>" readonly>
    </div>
    <div class="col-sm-2">
      <label for="bmrid" class="col-form-label">No. B.O.M</label>
    </div>
    <div class="col-sm-4 mb-3">
      <input type="text" class="form-control" autocomplete="off" value="<%= left(datah("memoBMRID"),3)&"-"&MID(datah("memoBMRID"),4,3)&"/"&MID(datah("memoBMRID"),7,4)&"/"&right(datah("memoBMRID"),3) %>" readonly>
    </div>
  </div>
  <div class='row'>
    <div class="col-sm-2">
      <label for="keterangan" class="col-form-label">Keterangan</label>
    </div>
    <div class="col-sm-10 mb-3">
      <input type="text" id="keterangan" class="form-control" name="keterangan" maxlength="50" autocomplete="off" value="<%= dataH("memoKeterangan") %>" readonly>
    </div>
  </div>
  <div class="row">
    <div class="d-flex mb-3">
      <% if session("INV9D") = true then  %>
        <div class="me-auto p-2">
          <button type="button" class="btn btn-secondary" onClick="window.open('export-Xlsanggaran.asp?id=<%=id%>')" class="btn btn-secondary">Export</button>
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
          total = 0
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
                <%= dataD("jenisNama") %>
              </td>
              <td><%= dataD("Brg_Nama") %></td>
              <td><%= dataD("memoQtty") %></td>
              <td><%= realstok %></td>
              <td><%= dataD("sat_nama") %></td>
              <td><%= dataD("T_Nama") %></td>
              <td>
                <%= dataD("memoKeterangan") %>
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
<% 
    call footer()
%>