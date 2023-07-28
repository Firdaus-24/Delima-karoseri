<!--#include file="../../init.asp"-->
<% 
  if session("PP8D") = false then
    Response.Redirect("./")
  end if
  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' header
  data_cmd.commandText = "SELECT DLK_T_Memo_H.*, HRD_M_Departement.DepNama, GLB_M_Agen.AgenName, HRD_M_Divisi.DivNama, DLK_M_Kebutuhan.K_Name FROM DLK_T_Memo_H LEFT OUTER JOIN HRD_M_Departement ON DLK_T_Memo_H.memoDepID = HRD_M_Departement.DepID LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN HRD_M_Divisi ON DLK_T_Memo_H.memoDivID = HRD_M_Divisi.divID LEFT OUTER JOIN DLK_M_Kebutuhan ON DLK_T_Memo_H.memoKebutuhan = DLK_M_Kebutuhan.K_ID WHERE memoID = '"& id &"' and memoAktifYN = 'Y'"
  set dataH = data_cmd.execute
  ' detail
  data_cmd.commandText = "SELECT DLK_T_Memo_D.*, DLK_M_Barang.Brg_Nama, DLK_M_Kategori.kategoriNama, DLK_M_JenisBarang.JenisNama, DLK_M_SatuanBarang.Sat_nama FROM DLK_T_Memo_D LEFT OUTER JOIN DLK_M_Barang ON DLK_T_Memo_D.MemoItem = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_Kategori ON DLK_M_Barang.KategoriID = DLK_M_Kategori.KAtegoriID LEFT OUTER JOIN DLK_M_JenisBarang ON DLK_M_Barang.JenisID = DLK_M_JenisBarang.jenisID LEFT OUTER JOIN DLK_M_satuanbarang ON DLK_T_Memo_D.memosatuan = dlk_M_Satuanbarang.sat_ID WHERE left(MemoID,17) = '"& dataH("MemoID") &"' ORDER BY memoItem ASC"

  set dataD = data_cmd.execute
  call header("Anggaran B.O.M Project")
%>
<link href="../../public/css/reqanggaranbomproject.css" rel="stylesheet" />
<body onload="window.print()"> 
  <div class="gambar">
    <div class="col ">
    <img src="<%= url %>/public/img/delimalogo.png" alt="delimalogo">
    </div>  
  </div>
  <div class='headerReqAngBomProject'>
    <span><h3>DETAIL PERMINTAAN ANGGARAN PROJECT</h3></span>
    <span><h3><%= left(dataH("memoID"),4) &"-"& mid(dataH("memoId"),5,3) &"-"& mid(dataH("memoID"),8,3) &"/"& mid(dataH("memoID"),11,4) &"/"& right(dataH("memoID"),3) %></h3></span>
  </div>
  <div class='rowReqBomProject'>
    <span>Tanggal</span>
    <span>: <%= Cdate(dataH("memoTgl")) %></span>
    <span>Cabang</span>
    <span>: <%= dataH("agenname") %></span>
  </div>
  <div class="rowReqBomProject">
    <span>
      Divisi
    </span>
    <span>
      : <%= dataH("divNama") %>
    </span>
    <span>
      Departement
    </span>
    <span>
      : <%= dataH("depNama") %>
    </span>
  </div>
  <div class="rowReqBomProject">
    <span>
      Kebutuhan
    </span>
    <span>
      : <%= dataH("K_name") %>
    </span>
    <span>
      No. B.O.M
    </span>
    <span>
    : <%= left(datah("memobmid"),2) %>-<%=mid(datah("memobmid"),3,3) %>/<%= mid(datah("memobmid"),6,4) %>/<%= right(datah("memobmid"),3) %>
    </span>
  </div>
  <div class="rowReqBomProject">
    <span>
      Keterangan
    </span>
    <span>
      : <%= dataH("memoKeterangan")  %>
    </span>
  </div>
  <table class="tblReqBomProject">
    <tr style="text-align:center">
      <th>No</th>
      <th>Kategori</th>
      <th>Jenis</th>
      <th>Item</th>
      <th>Quantity</th>
      <th>Satuan</th>
      <th>Keterangan</th>
      <th>Harga</th>
      <th>Total</th>
    </tr>
    <% 
    no = 0
    gtotal = 0
    do while not dataD.eof
    no = no + 1
    total = 0

    total = dataD("memoHarga") * dataD("memoQtty")
    gtotal = gtotal + total
    %>
      <tr>
        <td><%= no %></td>
        <td>
          <%=dataD("KategoriNama") %>
        </td>
        <td>
          <%= dataD("jenisNama") %>
        </td>
        <td><%= dataD("Brg_Nama") %></td>
        <td><%= dataD("memoQtty") %></td>
        <td><%= dataD("Sat_nama") %></td>
        <td>
          <%= dataD("memoKeterangan") %>
        </td>
        <td style="text-align:right"><%= replace(formatcurrency(dataD("memoHarga")),"$","") %></td>
        <td style="text-align:right"><%= replace(formatcurrency(total),"$","") %></td>
      </tr>
    <% 
    response.flush
    dataD.movenext
    loop
    %>
    <tr>
      <td colspan="8">
        Grand Total
      </td>
      <td style="text-align:right">
        <%= replace(formatcurrency(gtotal),"$","") %>
      </td>
    </tr>
  </table>
</body> 
<%call footer()%>