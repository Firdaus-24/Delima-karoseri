<!--#include file="../../init.asp"-->
<% 
  if session("PP4") = false then
    Response.Redirect("../index.asp")
  end if

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = MM_Delima_string
  ' filter cabang
  data_cmd.CommandText = "SELECT AgenID, AgenName FROM DLK_T_BB_ProsesH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_BB_ProsesH.BP_AgenID = GLB_M_Agen.AgenID WHERE BP_AktifYN = 'Y' GROUP BY AgenID, AgenName ORDER BY AgenName ASC"

  set agen =data_cmd.execute

  ' filter username
  data_cmd.CommandText = "SELECT DLK_M_WebLogin.userid, DLK_M_WebLogin.username FROM DLK_T_BB_ProsesH LEFT OUTER JOIN DLK_M_WebLogin ON DLK_T_BB_ProsesH.BP_UpdateID = DLK_M_Weblogin.userid WHERE DLK_T_BB_ProsesH.BP_Aktifyn = 'Y' GROUP BY userid, username ORDER BY Username asc"

  set datauser = data_cmd.execute

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
 
  users = request.QueryString("users")
  if len(users) = 0 then 
    users = request.form("users")
  end if
  pagen = request.QueryString("pagen")
  if len(pagen) = 0 then 
    pagen = request.form("pagen")
  end if

  ' query seach 
  if users <> "" then
    filterusers = " AND DLK_M_weblogin.userid = '"& users &"'"
  else
    filterusers = ""
  end if
  if pagen <> "" then
    filterAgen = " AND DLK_T_BB_ProsesH.BP_AgenID = '"& pagen &"'"
  else
    filterAgen = ""
  end if
  ' real query
  strquery = "SELECT DLK_T_BB_ProsesH.*,GLB_M_Agen.AgenNAme, DLK_M_WebLogin.Username FROM DLK_T_BB_ProsesH LEFT OUTER JOIN DLK_M_WebLogin ON DLK_T_BB_ProsesH.BP_UpdateID = DLK_M_Weblogin.userid LEFT OUTER JOIN GLB_M_Agen ON DLK_T_BB_ProsesH.BP_AgenID = GLB_M_Agen.AgenID WHERE DLK_T_BB_ProsesH.BP_AktifYN = 'Y' "& filterusers &""& filterAgen &""
  ' untuk data paggination
  page = Request.QueryString("page")

  orderBy = " order by BP_ID ASC"
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

  call header("Transaksi Beban Produksi") 
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row mt-3">
    <div class="col-lg-12 text-center">
      <h3>TRANSAKSI BEBAN PROSES PRODUKSI</h3>
    </div>
  </div>
  <% if session("PP4A") = true then%>
  <div class="row mt-3 mb-3">
    <div class="col-lg-2">
      <a href="bp_add.asp" class="btn btn-primary">
        Tambah
      </a>
    </div>
  </div>
  <% end if %>
  <form action="index.asp" method="post">
  <div class="row">
    <div class="col-lg-4 mb-3">
      <select class="form-select" aria-label="Default select example" name="pagen" id="pagen">
        <option value="">Pilih Cabang / Agen</option>
        <% do while not agen.eof %>
        <option value="<%= agen("AgenID") %>"><%= agen("AgenName") %></option>
        <% 
        agen.movenext
        loop
        %>
      </select>
    </div>
    <div class="col-lg mb-3">
      <select class="form-select" aria-label="Default select example" name="users" id="users">
        <option value="">Pilih User</option>
        <% do while not datauser.eof %>
        <option value="<%= datauser("userid") %>"><%= datauser("username") %></option>
        <% 
        datauser.movenext
        loop
        %>
      </select>
    </div>
    <div class="col-lg mb-3">
      <button type="submit" class="btn btn-primary">Cari</button>
    </div>  
  </div>
  </form>
  <div class="row">
    <div class="col-lg-12">
      <table class="table">
        <thead class="bg-secondary text-light">
          <tr>
            <th scope="col">No.</th>
            <th scope="col">Tanggal</th>
            <th scope="col">Cabang</th>
            <th scope="col">No.Produksi</th>
            <th scope="col" >Keterangan</th>
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

          ' cek data detail
          data_cmd.CommandText = "SELECT TOP 1 BP_ID FROM DLK_T_BB_ProsesD WHERE LEFT(BP_ID,12) = '"& rs("BP_ID") &"'"

          set detail = data_cmd.execute
          %>
          <tr>
            <th>
              <%= recordcounter %>
            </th>
            <td><%= Cdate(rs("BP_Date")) %></td>
            <td><%= rs("AgenName") %></td>
            <td>
               <%= left(rs("BP_PDHID"),2) %>-<%= mid(rs("BP_PDHID"),3,3) %>/<%= mid(rs("BP_PDHID"),6,4) %>/<%= right(rs("BP_PDHID"),4)  %>
            </td>
            <td><%= rs("BP_Keterangan")%></td>
            <td class="text-center">
              <div class="btn-group" role="group" aria-label="Basic example">
                <% if session("PP4B") = true then%>
                  <a href="bp_u.asp?id=<%= rs("BP_ID") %>" class="btn badge text-bg-primary">update</a> 
                <% end if %>

                <% if detail.eof then %>
                  <% if session("PP4C") = true then%>
                    <a href="aktifh.asp?id=<%= rs("BP_ID") %>" class="btn badge text-bg-danger" onclick="deleteItem(event,'Hapus Header Beban') ">delete</a>
                  <% end if %>
                <% else %>
                  <% if session("PP4D") = true then%>
                  <a href="detail.asp?id=<%= rs("BP_ID") %>" class="btn badge text-bg-warning">detail</a>
                  <% end if %>
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
            <a class="page-link prev" href="index.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&users=<%=users%>&pagen=<%= pagen %>">&#x25C4; Prev </a>
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
              <a class="page-link hal bg-primary text-light" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&users=<%=users%>&pagen=<%= pagen %>"><%= pagelistcounter %></a> 
            <%else%>
              <a class="page-link hal" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&users=<%=users%>&pagen=<%= pagen %>"><%= pagelistcounter %></a> 
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
              <a class="page-link next" href="index.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&users=<%=users%>&pagen=<%= pagen %>">Next &#x25BA;</a>
            <% else %>
              <p class="page-link next-p">Next &#x25BA;</p>
            <% end if %>
          </li>	
        </ul>
      </nav> 
    </div>
  </div>
</div>
<% call footer()%>