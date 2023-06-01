<!--#include file="../../init.asp"-->
<% 
  if session("HR8") = false then
      Response.Redirect("../index.asp")
  end if

  nama = trim(Request.Form("nama"))

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

  ' query seach 
  if nama <> "" then
      strquery = "SELECT HRD_M_JnsUsaha.*, DLK_M_Weblogin.username FROM HRD_M_JnsUsaha LEFT OUTER JOIN DLK_M_Weblogin ON HRD_M_JnsUsaha.Ush_Updateid = DLK_M_Weblogin.userid WHERE Ush_AktifYN = 'Y' AND Ush_Nama LIKE '%"& nama &"%'"
  else
      strquery = "SELECT HRD_M_JnsUsaha.*, DLK_M_Weblogin.username FROM HRD_M_JnsUsaha LEFT OUTER JOIN DLK_M_Weblogin ON HRD_M_JnsUsaha.Ush_Updateid = DLK_M_Weblogin.userid WHERE Ush_AktifYN = 'Y'"
  end if

  ' untuk data paggination
  page = Request.QueryString("page")

  orderBy = " order by Ush_Id ASC"
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

  call header("Jenis Usaha") 

%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row mt-3">
    <div class="col-lg-12 text-center">
      <h3>MASTER JENIS USAHA</h3>
    </div>
  </div>
  <% if session("HR8A") = true then %>
  <div class="row mt-3 mb-3">
    <div class="col-lg-2">
      <button type="button" class="btn btn-primary tambahusaha" data-bs-toggle="modal" data-bs-target="#staticBackdrop">
        Tambah
      </button>
    </div>
  </div>
  <% end if %>
  <div class="row">
      <div class="col-lg-4 mb-3">
      <form action="index.asp" method="post">
          <input type="text" class="form-control" name="nama" id="nama" autocomplete="off" placeholder="cari jenis usaha">
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
                      <th scope="row"><%= rs("Ush_Id") %> </th>
                      <td><%= rs( "Ush_Nama") %></td>
                      <td><%= rs("username") %></td>
                      <td><%= rs("Ush_UpdateTime") %></td>
                      <td><%if rs("Ush_AktifYN") = "Y" then%>Aktif <% end if %></td>
                      <td class="text-center">
                          <div class="btn-group" role="group" aria-label="Basic example">
                              <% if session("HR8B") = true then %>
                              <a href="#" class="btn badge text-bg-primary updateusaha" data="<%= rs("Ush_Id") %>" valname="<%= rs("Ush_Nama") %>" data-bs-toggle="modal" data-bs-target="#staticBackdrop">update</a> 
                              <% end if %>
                              <% if session("HR8C") = true then %>
                              <a href="aktif.asp?id=<%= rs("ush_Id") %>" class="btn badge text-bg-danger" onclick="deleteItem(event, 'MASTER JENIS USAHA')">delete</a>
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
<div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
<div class="modal-dialog">
  <div class="modal-content">
    <div class="modal-header">
      <h5 class="modal-title titleusaha" id="staticBackdropLabel">FORM TAMBAH</h5>
      <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
    </div>
      <form action="ush_a.asp" method="post" id="formusaha">
    <div class="modal-body">
      <input type="hidden" class="form-control" name="initialush" id="initialush" autocomplete="off" required>
      <input type="hidden" class="form-control" name="id" id="id" autocomplete="off" required>
      <input type="text" class="form-control" name="nama" id="inpnama" autocomplete="off" maxlength="50" required>
    </div>
    <div class="modal-footer">
      <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
      <button type="submit" class="btn btn-primary subusaha">Tambah</button>
    </div>
      </form>
  </div>
</div>
</div>

<% call footer() %>