<!--#include file="../../init.asp"-->
<% 
  if session("ENG8") = false then 
    Response.Redirect("../index.asp")
  end if

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' filter cabang
  data_cmd.CommandText = "SELECT AgenID, AgenName FROM DLK_T_SuratJalanH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_SuratJalanH.SJ_AgenID = GLB_M_agen.agenid WHERE SJ_aktifyn = 'Y' GROUP BY AgenID, AgenName ORDER BY AgenName ASC"
  set dataagen = data_cmd.execute

  ' filter customer
  data_cmd.commandtext = "SELECT Custid, CustNama FROM DLK_T_SuratJalanH LEFT OUTER JOIN DLK_M_Customer ON DLK_T_SuratJalanH.SJ_CustID = DLK_M_Customer.custID WHERE SJ_AktifYN = 'Y' GROUP BY CustID, CustNama ORDER BY CustNama ASC"

  set datacust = data_cmd.execute 


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
  
  cabang = request.QueryString("cabang")
  if len(cabang) = 0 then 
    cabang = trim(Request.Form("cabang"))
  end if
  cust = request.QueryString("cust")
  if len(cust) = 0 then 
    cust = trim(Request.Form("cust"))
  end if

  if cabang <> "" then
    filtercabang = " AND SJ_AgenID = '"& cabang &"'"
  else
    filtercabang = ""
  end if
  if cust <> "" then
    filtercust = " AND SJ_Custid = '"& cust &"'"
  else
    filtercust = ""
  end if

  strquery = "SELECT dbo.DLK_T_SuratJalanH.SJ_ID, dbo.DLK_T_SuratJalanH.SJ_Date, dbo.DLK_T_SuratJalanH.SJ_Keterangan, dbo.DLK_T_SuratJalanH.SJ_UpdateID, dbo.DLK_M_Customer.custNama, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_WebLogin.UserName FROM dbo.DLK_T_SuratJalanH LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_SuratJalanH.SJ_UpdateID = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_SuratJalanH.SJ_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN dbo.DLK_M_Customer ON dbo.DLK_T_SuratJalanH.SJ_CustID = dbo.DLK_M_Customer.custId WHERE (dbo.DLK_T_SuratJalanH.SJ_AktifYN = 'Y') "& filtercabang &" "& filtercust &" "
  ' response.write strquery
  ' untuk data paggination
  page = Request.QueryString("page")

  orderBy = " order by SJ_ID ASC"
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

  call header("Surat Jalan") 

%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row mt-3">
    <div class="col-lg-12 text-center">
      <h3>SURAT JALAN UNIT</h3>
    </div>
  </div>
  <% if session("ENG8A") = true then  %>
  <div class="row mt-3 mb-3">
    <div class="col-lg-2">
      <a href="sj_add.asp" class="btn btn-primary">Tambah</a>
    </div>
  </div>
  <%  end if %>
  <form action="index.asp" method="post">
  <div class="row">
    <div class="col-sm-3 mb-3">
      <select class="form-select" aria-label="Default select example" id="cabang" name="cabang" >
        <option value="">Pilih Cabang</option>
        <% do while not dataagen.eof %>
        <option value="<%= dataagen("AgenID") %>"><%= dataagen("AgenName") %></option>
        <% 
        Response.flush
        dataagen.movenext
        loop
        %>
      </select>
    </div>
    <div class="col-sm-3 mb-3">
      <select class="form-select" aria-label="Default select example" id="cust" name="cust" >
        <option value="">Pilih Customers</option>
        <% do while not datacust.eof %>
        <option value="<%= datacust("custid") %>"><%= datacust("custnama") %></option>
        <% 
        Response.flush
        datacust.movenext
        loop
        %>
      </select>
    </div>
    <div class="col-sm mb-3">
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
            <th scope="col">Tanggal</th>
            <th scope="col">Cabang</th>
            <th scope="col">Customer</th>
            <th scope="col">Keterangan</th>
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
            data_cmd.commandText = "SELECT TOP 1 SJD_ID FROM DLK_T_SuratJalanD WHERE LEFT(SJD_ID,10) = '"& rs("SJ_ID") &"'"
            set detail = data_cmd.execute
            %>
            <tr>
              <th scope="row"><%= LEft(rs("SJ_ID"),3) &"-"& mid(rs("SJ_ID"),4,4) &"/"& right(rs("SJ_ID"),3) %> </th>
                <td><%= Cdate(rs("SJ_Date")) %></td>
                <td><%= rs("agenname") %></td>
                <td><%= rs("custnama") %></td>
                <td><%= rs("SJ_Keterangan") %></td>
                <td class="text-center">
                    <div class="btn-group" role="group" aria-label="Basic example">
                      <% if session("ENG8B") = true then  %>
                        <a href="sjd_u.asp?id=<%= rs("SJ_ID") %>" class="btn badge text-bg-primary">update</a>
                      <% end if %>
                      <% if detail.eof then %>
                        <% if session("ENG8C") = true then  %>
                        <a href="aktif.asp?id=<%= rs("SJ_ID") %>" class="btn badge text-bg-danger" onclick="ApproveYN(event,'Surat Jalan Unit','Delete Teransaksi','warning')">delete</a>
                        <% end if %>
                      <% else %>
                        <a href="detail.asp?id=<%= rs("SJ_ID") %>" class="btn badge text-bg-warning">detail</a>
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
            <a class="page-link prev" href="index.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&cabang=<%=cabang%>&cust=<%=cust%>">&#x25C4; Prev </a>
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
                <a class="page-link hal bg-primary text-light" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&cabang=<%=cabang%>&cust=<%=cust%>"><%= pagelistcounter %></a> 
              <%else%>
                <a class="page-link hal" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&cabang=<%=cabang%>&cust=<%=cust%>"><%= pagelistcounter %></a> 
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
                <a class="page-link next" href="index.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&cabang=<%=cabang%>&cust=<%=cust%>">Next &#x25BA;</a>
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