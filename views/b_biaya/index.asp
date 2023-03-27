<!--#include file="../../init.asp"-->
<% 
  ' if session("HR2") = false then
  '   Response.Redirect("../index.asp")
  ' end if


  set conn = Server.CreateObject("ADODB.Connection")
  conn.open MM_Delima_string

  dim recordsonpage, requestrecords, allrecords, hiddenrecords, showrecords, lastrecord, recordconter, pagelist, pagelistcounter, sqlawal
  dim angka
  dim code, nama, aktifId, UpdateId, uTIme, orderBy
  ' untuk angka
  angka = request.QueryString("angka")
  if len(angka) = 0 then 
    angka = Request.form("urut") + 1
  end if
  nama = trim(Request.Form("nama"))
  if len(nama) = 0 then 
    nama = Request.form("nama")
  end if

  ' query seach 
  if nama <> "" then
    strquery = "SELECT DLK_M_BebanBiaya.*, DLK_M_WebLogin.username FROM DLK_M_BebanBiaya LEFT OUTER JOIN DLK_M_WebLogin ON DLK_M_BebanBiaya.BN_UpdateID = DLK_M_WebLogin.userid WHERE BN_Nama LIKE '%"& nama &"%'"
  else
    strquery = "SELECT DLK_M_BebanBiaya.*, DLK_M_WebLogin.username FROM DLK_M_BebanBiaya LEFT OUTER JOIN DLK_M_WebLogin ON DLK_M_BebanBiaya.BN_UpdateID = DLK_M_WebLogin.userid "
  end if

  ' untuk data paggination
  page = Request.QueryString("page")

  orderBy = " order by BN_ID ASC"
  set rs = Server.CreateObject("ADODB.Recordset")
  sqlawal = strquery

  sql= sqlawal + orderBy
  rs.open sql, conn
  ' records per halaman
  recordsonpage = 10
  ' count all records
  allrecords = 0
  do until rs.EOF
    allrecords = allrecords + 1
    rs.movenext
  loop
  ' if offset is zero then the first page will be loaded
  offset = Request.QueryString("offset")
  if offset = 0 OR offset = "" then
    requestrecords = 0
  else
    requestrecords = requestrecords + offset
  end if
  rs.close
  set rs = server.CreateObject("ADODB.RecordSet")
  sqlawal = strquery
  sql=sqlawal + orderBy
  rs.open sql, conn
  ' reads first records (offset) without showing them (can't find another solution!)
  hiddenrecords = requestrecords
  do until hiddenrecords = 0 OR rs.EOF
    hiddenrecords = hiddenrecords - 1
    rs.movenext
    if rs.EOF then
    lastrecord = 1
    end if	
  loop

  call header("Beban Biaya") 

%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row mt-3">
    <div class="col-lg-12 text-center">
      <h3>MASTER BEBAN BIAYA PRODUKSI</h3>
    </div>
  </div>
  <%' if session("HR2A") = true then %>
  <div class="row mt-3 mb-3">
    <div class="col-lg-2">
      <!-- Button trigger modal -->
      <button type="button" class="btn btn-primary tambahBebanBiaya" data-bs-toggle="modal" data-bs-target="#modalBbiaya">
        Tambah
      </button>
    </div>
  </div>
  <%' end if %>
  <div class="row">
    <div class="col-lg-4 mb-3">
    <form action="index.asp" method="post">
      <input type="text" class="form-control" name="nama" id="nama" autocomplete="off" placeholder="Cari Beban Biaya">
    </div>
    <div class="col-lg mb-3">
      <button type="submit" class="btn btn-primary">Cari</button>
      </form>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12">
      <table class="table">
        <thead class="bg-secondary text-light">
          <tr>
          <th scope="col">Id</th>
          <th scope="col">Nama</th>
          <th scope="col">UpdateId</th>
          <th scope="col">Update Time</th>
          <th scope="col" class="text-center">Aksi</th>
          </tr>
        </thead>
        <tbody>
          <% 
          'prints records in the table
          showrecords = recordsonpage
          recordcounter = requestrecords
          do until showrecords = 0 OR  rs.EOF
          recordcounter = recordcounter + 1
          %>
          <tr>
              <th scope="row"><%= rs("BN_Id") %> </th>
              <td><%= rs( "BN_Nama") %></td>
              <td><%= rs("username") %></td>
              <td><%= rs("BN_UpdateTime") %></td>
              <td class="text-center">
                <div class="btn-group" role="group" aria-label="Basic example">
                  <%' if session("HR2B") = true then %>
                    <a href="#" class="btn badge text-bg-primary updatebebanBiaya" data="<%= rs("BN_ID") %>" valname="<%= rs("BN_Nama") %>" data-bs-toggle="modal" data-bs-target="#modalBbiaya">update</a> 
                  <%' end if %>
                  <%' if session("HR2C") = true then %>
                    <% if rs("BN_AktifYN") = "Y" then %>
                      <a href="aktif.asp?id=<%= rs("BN_ID") %>&p=N" class="btn badge text-bg-danger" onclick="ApproveYN(event,'APA ANDA YAKIN?', 'Menonaktifkan data ini','warning')">delete</a>
                    <% else%>
                      <a href="aktif.asp?id=<%= rs("BN_ID") %>&p=Y" class="btn badge text-bg-warning" onclick="ApproveYN(event,'APA ANDA YAKIN?', 'Mengaktifkan data ini','warning')">Aktif</a>
                    <% end if %>
                  <%' end if %>
                </div>
              </td>
          </tr>
          <% 
          showrecords = showrecords - 1
          rs.movenext
          if rs.EOF then
          lastrecord = 1
          end if
          loop
          rs.close
          %>
        </tbody>
      </table>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-12">
      <!-- paggination -->
      <nav aria-label="Page navigation example">
        <ul class="pagination">
          <li class="page-item">
            <% 
              if page = "" then
                npage = 1
              else
                npage = page - 1
              end if
              if requestrecords <> 0 then 
            %>
              <a class="page-link prev" href="index.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>">&#x25C4; Prev </a>
          <% else %>
              <p class="page-link prev-p">&#x25C4; Prev </p>
          <% end if %>
          </li>
            <li class="page-item d-flex" style="overflow-y:auto;height: max-content;">	
              <%
              pagelist = 0
              pagelistcounter = 0
              do until pagelist > allrecords  
              pagelistcounter = pagelistcounter + 1
              if page = "" then
                page = 1
              else
                page = page
              end if
              if Cint(page) = pagelistcounter then
              %>
                <a class="page-link hal bg-primary text-light" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>"><%= pagelistcounter %></a> 
              <%else%>
                <a class="page-link hal" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>"><%= pagelistcounter %></a> 
              <%
              end if
              pagelist = pagelist + recordsonpage
              loop
              %>
            </li>
            <li class="page-item">
              <% 
              if page = "" then
                page = 1
              else
                page = page + 1
              end if
              %>
              <% if(recordcounter > 1) and (lastrecord <> 1) then %>
                <a class="page-link next" href="index.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>">Next &#x25BA;</a>
              <% else %>
                <p class="page-link next-p">Next &#x25BA;</p>
              <% end if %>
            </li>	
        </ul>
      </nav> 
    </div>
  </div>
</div>
<!-- Modal -->
<div class="modal fade" id="modalBbiaya" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="modalBbiayaLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title titBebanBiaya" id="modalBbiayaLabel">FORM TAMBAH</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
        <form action="bn_add.asp" method="post" id="formBebanBiaya" onsubmit="validasiForm(this,event, 'MASTER BEBAN BIAYA PRODUKSI', 'warning')" >
      <div class="modal-body">
        <input type="hidden" class="form-control" name="id" id="id" autocomplete="off" required>
        <input type="text" class="form-control" name="nama" id="bnNama" autocomplete="off" maxlength="50" required>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary subBB">Tambah</button>
      </div>
        </form>
    </div>
  </div>
</div>
<% call footer() %>
