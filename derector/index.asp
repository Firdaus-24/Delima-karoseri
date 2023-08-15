<!--#include file="../connections/cargo.asp"-->
<!--#include file="../url.asp"-->
<%
  set data_cmd = Server.CreateObject("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_String

  data_cmd.commandTExt = "SELECT DLK_T_Memo_H.*, GLB_M_Agen.AgenName, HRD_M_Divisi.DivNama, HRD_M_Departement.DepNama FROM DLK_T_Memo_H LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = LEFT(GLB_M_Agen.AgenID,3) LEFT OUTER JOIN HRD_M_Divisi ON DLK_T_Memo_H.memoDivid = HRD_M_Divisi.divID LEFT OUTER JOIN HRD_M_Departement ON DLK_T_Memo_H.MemoDepID = HRD_M_Departement.DepID WHERE memoAktifYN = 'Y' AND memoInventoryYN = 'Y' AND memopurchaseYN = 'Y' AND memoApproveYN = 'Y' AND NOT EXISTS ( SELECT dbo.DLK_T_OrPemH.OPH_MemoID FROM dbo.DLK_T_MaterialReceiptH INNER JOIN dbo.DLK_T_MaterialReceiptD1 ON dbo.DLK_T_MaterialReceiptH.MR_ID = dbo.DLK_T_MaterialReceiptD1.MR_ID LEFT OUTER JOIN dbo.DLK_T_OrPemH ON dbo.DLK_T_MaterialReceiptD1.MR_Transaksi = dbo.DLK_T_OrPemH.OPH_ID GROUP BY dbo.DLK_T_OrPemH.OPH_MemoID, dbo.DLK_T_OrPemH.OPH_AktifYN, dbo.DLK_T_MaterialReceiptH.MR_AktifYN HAVING (dbo.DLK_T_OrPemH.OPH_MemoID = DLK_T_Memo_H.memoid) AND (dbo.DLK_T_OrPemH.OPH_AktifYN = 'Y') AND (dbo.DLK_T_MaterialReceiptH.MR_AktifYN = 'Y') ) ORDER BY memoTgl DESC"
  set data = data_cmd.execute

  data_cmd.commandTExt = "SELECT DLK_T_Memo_H.*, GLB_M_Agen.AgenName, HRD_M_Divisi.DivNama, HRD_M_Departement.DepNama FROM DLK_T_Memo_H LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = LEFT(GLB_M_Agen.AgenID,3) LEFT OUTER JOIN HRD_M_Divisi ON DLK_T_Memo_H.memoDivid = HRD_M_Divisi.divID LEFT OUTER JOIN HRD_M_Departement ON DLK_T_Memo_H.MemoDepID = HRD_M_Departement.DepID WHERE memoAktifYN = 'Y' AND memoInventoryYN = 'Y' AND memopurchaseYN = 'Y' AND memoApproveYN = 'N' ORDER BY memoTgl DESC"
  set data1 = data_cmd.execute

%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Memo Permintaan Anggaran</title>
  <link href="../public/css/bootstrap.min.css" rel="stylesheet" />
  <script src="../public/js/bootstrap.bundle.min.js"></script>
  <!-- sweet alert -->
  <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
  <link href='../public/img/delimalogo.png' rel='website icon' type='png' />
</head>
<body>
  <div class='container'>
    <div class='row'>
      <div class='row'>
        <div class='col-lg-6 mt-4 mb-2 text-center'>
          <h5>MEMO SEDANG DI PROSES</h5>
        </div>
        <div class='col-lg-6 mt-4 mb-2 text-center text-danger'>
          <h5>MEMO BELUM DI PROSES</h5>
        </div>
      </div>
      <div class='row'>
        <div class='col-lg-6 mb-3'>
          <table class="table table-hover table-bordered" style="font-size:12px;">
            <thead>
              <tr class="bg-primary text-light">
                <th scope="col">No</th>
                <th scope="col">Tanggal</th>
                <th scope="col">No Memo</th>
                <th scope="col">Divisi</th>
                <th scope="col">Departement</th>
                <th scope="col">Keterangan</th>
                <th scope="col" class="text-center">Aksi</th>
              </tr>
            </thead>
            <tbody>
              <%
              no = 0
              do while not data.eof 
              no = no + 1
              %>
              <tr>
                <th scope="row"><%= no %></th>
                <td><%= Cdate(data("memoTgl")) %></td>
                <td>
                    <%= left(data("memoID"),4) %>/<%=mid(data("memoId"),5,3) %>-<%= mid(data("memoID"),8,3) %>/<%= mid(data("memoID"),11,4) %>/<%= right(data("memoID"),3) %>
                </td>
                <td><%= data("DivNama") %></td>
                <td><%= data("DepNama")%></td>
                <td><%= data("memoKeterangan") %></td>
                <td class="text-center">
                  <a href="detail.asp?id=<%= data("memoID") %>" class="btn badge text-bg-warning">Detail</a>
                </td>
              </tr>
              <%
              Response.flush
              data.movenext
              loop
              %>
            </tbody>
          </table>
        </div>
        <div class='col-lg-6 mb-3'>
          <table class="table table-hover table-bordered" style="font-size:12px;">
            <thead>
              <tr class="bg-danger text-light">
                <th scope="col">No</th>
                <th scope="col">Tanggal</th>
                <th scope="col">No Memo</th>
                <th scope="col">Divisi</th>
                <th scope="col">Departement</th>
                <th scope="col">Keterangan</th>
                <th scope="col" class="text-center">Aksi</th>
              </tr>
            </thead>
            <tbody>
              <%
              no = 0
              do while not data1.eof 
              no = no + 1
              %>
              <tr>
                <th scope="row"><%= no %></th>
                <td><%= Cdate(data1("memoTgl")) %></td>
                <td>
                    <%= left(data1("memoID"),4) %>/<%=mid(data1("memoId"),5,3) %>-<%= mid(data1("memoID"),8,3) %>/<%= mid(data1("memoID"),11,4) %>/<%= right(data1("memoID"),3) %>
                </td>
                <td><%= data1("DivNama") %></td>
                <td><%= data1("DepNama")%></td>
                <td><%= data1("memoKeterangan") %></td>
                <td class="text-center">
                  <div class="btn-group" role="group" aria-label="Basic example">
                    <a href="detail.asp?id=<%= data1("memoID") %>" class="btn badge text-bg-warning">Detail</a>
                  </div>
                </td>
              </tr>
              <%
              Response.flush
              data1.movenext
              loop
              %>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>  
  <!-- jquery -->
  <script src="../../public/js/jquery-min.js"></script>
  <!-- bootstrap -->
  <script src="../../public/js/bootstrap.min.js"></script>
</body>
</html>
