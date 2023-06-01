<!--#include file="../../init.asp"-->
<% 
  if session("PP3") = false then
    Response.Redirect("../index.asp")
  end if

  set data_cmd =  Server.CreateObject ("ADODB.Command")   
  data_cmd.ActiveConnection = mm_delima_string    
  ' filter agen
  data_cmd.commandText = "SELECT AgenID, AgenName FROM DLK_T_ReturnMaterialH LEFT OUTER JOIN  GLB_M_Agen ON DLK_T_ReturnMaterialH.RM_agenID = GLB_M_Agen.AgenID WHERE RM_aktifYN = 'Y' GROUP BY AgenID, AgenName ORDER BY AgenName ASC"

  set agendata = data_cmd.execute
  ' filter NO produksi
  data_cmd.commandText = "SELECT RM_PDHID FROM DLK_T_ReturnMaterialH WHERE RM_aktifYN = 'Y' GROUP BY RM_PDHID ORDER BY RM_PDHID ASC"

  set proddata = data_cmd.execute

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
  agen = request.QueryString("agen")
  if len(agen) = 0 then 
    agen = trim(Request.Form("agen"))
  end if
  noprod = request.QueryString("noprod")
  if len(noprod) = 0 then 
    noprod = trim(Request.Form("noprod"))
  end if
  tgla = request.QueryString("tgla")
  if len(tgla) = 0 then 
    tgla = trim(Request.Form("tgla"))
  end if
  tgle = request.QueryString("tgle")
  if len(tgle) = 0 then 
    tgle = trim(Request.Form("tgle"))
  end if

  ' query seach 
  if agen <> "" then
    filterAgen = "AND DLK_T_ReturnMaterialH.RM_AgenID = '"& agen &"'"
  else
    filterAgen = ""
  end if

  if noprod <> "" then
    filternoprod = "AND dbo.DLK_T_ReturnMaterialH.RM_PDHID = '"& noprod &"'"
  else
    filternoprod = ""
  end if

  if tgla <> "" AND tgle <> "" then
    filtertgl = "AND dbo.DLK_T_ReturnMaterialH.RM_Date BETWEEN '"& Cdate(tgla) &"' AND '"& Cdate(tgle) &"'"
  elseIf tgla <> "" AND tgle = "" then
    filtertgl = "AND dbo.DLK_T_ReturnMaterialH.RM_Date = '"& Cdate(tgla) &"'"
  else 
    filtertgl = ""
  end if

  strquery = "SELECT dbo.DLK_T_ReturnMaterialH.*, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_WebLogin.UserName FROM            dbo.DLK_T_ReturnMaterialH LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_ReturnMaterialH.RM_UpdateID = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_ReturnMaterialH.RM_AgenID = dbo.GLB_M_Agen.AgenID WHERE (dbo.DLK_T_ReturnMaterialH.RM_AktifYN = 'Y') "& filterAgen &" "& filternoprod &" "& filtertgl &""

  ' untuk data paggination
  page = Request.QueryString("page")

  orderBy = " ORDER BY RM_ID DESC   "
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
    response.flush
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
    response.flush
    rs.movenext
    if rs.EOF then
    lastrecord = 1
    end if	
  loop

  call header("Return Barang")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-lg-12 text-center mt-3 mb-3">
        <h3>MATERIAL SISA PRODUKSI</h3>
    </div>
  </div>
  <% if session("PP3A") = true then %>
  <div class="row mt-3 mb-3">
    <div class="col-lg-2">
      <a href="rm_add.asp" class="btn btn-primary">Tambah</a>
    </div>
  </div>
  <% end if %>
  <form action="index.asp" method="post">
  <div class="row">
      <div class="col-lg-4 mb-3">
          <label>Agen / Cabang</label>
          <select class="form-select" aria-label="Default select example" name="agen" id="agen">
              <option value="">Pilih</option>
              <% do while not agendata.eof %>
              <option value="<%= agendata("agenID") %>"><%= agendata("agenNAme") %></option>
              <% 
              response.flush
              agendata.movenext
              loop
              %>
          </select>
        </div>
      <div class="col-lg-4 mb-3">
          <label>No.Produksi</label>
          <select class="form-select" aria-label="Default select example" name="noprod" id="noprod">
            <option value="">Pilih</option>
            <% do while not proddata.eof %>
            <option value="<%= proddata("RM_PDHID") %>"><%= left(proddata("RM_PDHID") ,2)%>-<%= mid(proddata("RM_PDHID") ,3,3)%>/<%= mid(proddata("RM_PDHID") ,6,4) %>/<%= right(proddata("RM_PDHID"),4) %></option>
            <% 
            response.flush
            proddata.movenext
            loop
            %>
          </select>
      </div>
  </div>
  <div class="row">
      <div class="col-lg-4 mb-3">
          <label>Tanggal awal</label>
          <input type="date" class="form-control" name="tgla" id="tgla" autocomplete="off">
        </div>
      <div class="col-lg-4 mb-3">
          <label>Tanggal akhir</label>
          <input type="date" class="form-control" name="tgle" id="tgle" autocomplete="off">
        </div>
        <div class="col-lg mb-3 d-flex align-items-end">
          <button type="submit" class="btn btn-primary">Cari</button>
      </div>
  </div>
  </form>
  <div class="row">
    <div class="col-lg-12">
      <table class="table">
        <thead class="bg-secondary text-light">
          <tr>
            <th scope="col">No</th>
            <th scope="col">No.Transaksi</th>
            <th scope="col">No.Produksi</th>
            <th scope="col">Tanggal</th>
            <th scope="col">Cabang</th>
            <th scope="col">Terima Y/N</th>
            <th scope="col">Update ID</th>
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
            data_cmd.commandText = "SELECT TOP 1 RM_ID FROM DLK_T_ReturnMaterialD WHERE LEFT(RM_ID,13) = '"& rs("RM_ID") &"'"
            ' response.write data_cmd.commandText & "<br>"
            set detail = data_cmd.execute
          %>
          <tr>
            <th scope="row"><%= recordcounter %> </th>
            <td><%= left(rs("RM_ID") ,2)%>-<%= mid(rs("RM_ID") ,3,3)%>/<%= mid(rs("RM_ID") ,6,4) %>/<%= right(rs("RM_ID"),4) %></td>
            <td><%= left(rs("RM_PDHID") ,2)%>-<%= mid(rs("RM_PDHID") ,3,3)%>/<%= mid(rs("RM_PDHID") ,6,4) %>/<%= right(rs("RM_PDHID"),4) %></td>
            <td><%= Cdate(rs("RM_Date")) %></td>
            <td><%= rs("AgenNAme") %></td>
            <td><%= rs("RM_TerimaYN") %></td>
            <td><%= rs("username") %></td>
            <td class="text-center">
              <div class="btn-group" role="group" aria-label="Basic example">
                <% if session("PP3B") = true then %>
                  <a href="rmd_u.asp?id=<%= rs("RM_ID") %>" class="btn badge text-bg-primary">update</a>
                <%end if %>
                <% if detail.eof then %>
                  <% if rs("RM_TerimaYN") = "N" then %>
                    <% if session("PP3C") = true then %>
                    <a href="aktif.asp?id=<%= rs("RM_ID") %>" class="btn badge text-bg-danger" onclick="deleteItem(event,'RETURN BARANG HEADER')">delete</a>
                    <% end if %>
                  <%end if %>
                <% else %>
                  <a href="detail.asp?id=<%= rs("RM_ID") %>" class="btn badge text-bg-warning">detail</a>
                <% end if %>    
              </div>
            </td>
          </tr>
          <% 
          response.flush
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
            <a class="page-link prev" href="index.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&agen=<%=agen%>&noprod=<%=noprod%>&tgla=<%=tgla%>&tgle=<%=tgle%>">&#x25C4; Prev </a>
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
            <a class="page-link hal bg-primary text-light" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&noprod=<%=noprod%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
          <%else%>
            <a class="page-link hal" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&noprod=<%=noprod%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
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
              <a class="page-link next" href="index.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&agen=<%=agen%>&noprod=<%=noprod%>&tgla=<%=tgla%>&tgle=<%=tgle%>">Next &#x25BA;</a>
            <% else %>
              <p class="page-link next-p">Next &#x25BA;</p>
            <% end if %>
          </li>	
        </ul>
      </nav> 
    </div>
  </div>
</div>
<% call footer() %>
