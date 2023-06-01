<!--#include file="../../init.asp"-->
<% 
  if session("M11") = false then
    Response.Redirect("../index.asp")
  end if

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
  nama = request.QueryString("nama")
  if len(nama) = 0 then 
    nama = trim(Request.Form("nama"))
  end if

  ' query seach 
  if nama <> "" then
    strquery = "SELECT DLK_M_SatuanPanjang.*, DLK_M_Weblogin.username FROM DLK_M_SatuanPanjang LEFT OUTER JOIN DLK_M_Weblogin ON DLK_M_SatuanPanjang.SP_UpdateID = DLK_M_Weblogin.userid WHERE SP_AktifYN = 'Y' AND SP_Nama LIKE '%"& nama &"%'"
  else
    strquery = "SELECT DLK_M_SatuanPanjang.*, DLK_M_Weblogin.username FROM DLK_M_SatuanPanjang LEFT OUTER JOIN DLK_M_Weblogin ON DLK_M_SatuanPanjang.SP_UpdateID = DLK_M_Weblogin.userid WHERE SP_AktifYN = 'Y'"
  end if

  ' untuk data paggination
  page = Request.QueryString("page")

  orderBy = " order by SP_ID ASC"
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

  call header("Satuan Panjang") 

%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row mt-3">
    <div class="col-lg-12 text-center">
      <h3>MASTER SATUAN PANJANG</h3>
    </div>
  </div>
  <% if session("M11A") = true then %>
  <div class="row mt-3 mb-3">
    <div class="col-lg-2">
      <!-- Button trigger modal -->
      <button type="button" class="btn btn-primary tambahpanjang" data-bs-toggle="modal" data-bs-target="#modalSatuanPanjang">
        Tambah
      </button>
    </div>
  </div>
  <% end if %>
  <div class="row">
    <div class="col-lg-4 mb-3">
    <form action="index.asp" method="post">
      <input type="text" class="form-control" name="nama" id="nama" autocomplete="off" placeholder="cari nama">
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
            <th scope="col">Aktif</th>
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
            <th scope="row"><%= recordcounter %> </th>
            <td><%= rs( "SP_Nama") %></td>
            <td><%= rs("username") %></td>
            <td><%= rs("SP_UpdateTime") %></td>
            <td><%if rs("SP_AktifYN") = "Y" then%>Aktif <% end if %></td>
            <td class="text-center">
              <div class="btn-group" role="group" aria-label="Basic example">
                <% if session("M11B") = true then %>
                  <a href="#" class="btn badge text-bg-primary updateSatuanPanjang" data="<%= rs("SP_ID") %>" valname="<%= rs("SP_Nama") %>" data-bs-toggle="modal" data-bs-target="#modalSatuanPanjang">update</a> 
                <% end if %>
                <% if session("M11C") = true then %>
                  <a href="aktif.asp?id=<%= rs("SP_id") %>" class="btn badge text-bg-danger" onclick="deleteItem(event,'MASTER SATUAN PANJANG')">delete</a>
                <% end if %>
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
            <a class="page-link prev" href="index.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&nama=<%=nama%>">&#x25C4; Prev </a>
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
              <a class="page-link hal bg-primary text-light" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&nama=<%=nama%>"><%= pagelistcounter %></a> 
            <%else%>
              <a class="page-link hal" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&nama=<%=nama%>"><%= pagelistcounter %></a> 
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
              <a class="page-link next" href="index.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&nama=<%=nama%>">Next &#x25BA;</a>
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
<div class="modal fade" id="modalSatuanPanjang" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="modalSatuanPanjangLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalSatuanPanjangLabel">FORM SATUAN PANJANG</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form action="sat_add.asp" method="post" id="formsatuanpanjang" onsubmit="validasiForm(this,event,'MASTER SATUAN PANJANG', 'warning')">
      <div class="modal-body">
        <input type="hidden" class="form-control" name="id" id="id" autocomplete="off" required>
        <input type="text" class="form-control" name="nama" id="inpnama" autocomplete="off" maxlength="5" required>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary tbn-submit-satuanpanjang">Tambah</button>
      </div>
      </form>
    </div>
  </div>
</div>

<% call footer() %>