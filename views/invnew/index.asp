<!--#include file="../../init.asp"-->
<% 
  if session("MK3") = false then
    Response.Redirect("../index.asp")
  end if

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' filter agen
  data_cmd.commandText = "SELECT GLB_M_Agen.AgenID , GLB_M_Agen.AgenName FROM MKT_T_InvJulNewH LEFT OUTER JOIN GLB_M_Agen ON MKT_T_InvJulNewH.IPH_AgenID = GLB_M_Agen.AgenID WHERE MKT_T_InvJulNewH.IPH_AktifYN = 'Y' GROUP BY GLB_M_Agen.AgenID, GLB_M_Agen.AgenName ORDER BY GLB_M_Agen.AgenName ASC"
  set agendata = data_cmd.execute
  ' filter customer
  data_cmd.commandText = "SELECT dbo.DLK_M_Customer.custNama, dbo.DLK_M_Customer.custId FROM dbo.MKT_T_InvJulNewH LEFT OUTER JOIN dbo.DLK_M_Customer ON dbo.MKT_T_InvJulNewH.IPH_Custid = dbo.DLK_M_Customer.custId WHERE MKT_T_InvJulNewH.IPH_AktifYN = 'Y' GROUP BY dbo.DLK_M_Customer.custNama, dbo.DLK_M_Customer.custId ORDER BY custnama ASC"
  set vendata = data_cmd.execute

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
  cust = request.QueryString("cust")
  if len(cust) = 0 then 
    cust = trim(Request.Form("cust"))
  end if
  tgla = request.QueryString("tgla")
  if len(tgla) = 0 then 
    tgla = trim(Request.Form("tgla"))
  end if
  tgle = request.QueryString("tgle")
  if len(tgle) = 0 then 
    tgle = trim(Request.Form("tgle"))
  end if
  
  if agen <> "" then
    filterAgen = "AND MKT_T_InvJulNewH.IPH_AgenID = '"& agen &"'"
  else
    filterAgen = ""
  end if

  if cust <> "" then
    filtercust = "AND dbo.MKT_T_InvJulNewH.IPH_custID = '"& cust &"'"
  else
    filtercust = ""
  end if

  if tgla <> "" AND tgle <> "" then
    filtertgl = "AND dbo.MKT_T_InvJulNewH.IPH_Date BETWEEN '"& tgla &"' AND '"& tgle &"'"
  elseIf tgla <> "" AND tgle = "" then
    filtertgl = "AND dbo.MKT_T_InvJulNewH.IPH_Date = '"& tgla &"'"
  else 
    filtertgl = ""
  end if

  ' query seach 
  strquery = "SELECT MKT_T_InvJulNewH.*, GLB_M_Agen.AgenName, DLK_M_Customer.custnama FROM MKT_T_InvJulNewH LEFT OUTER JOIN GLB_M_Agen ON MKT_T_InvJulNewH.IPH_AgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_Customer ON MKT_T_InvJulNewH.IPH_custID = DLK_M_Customer.custID WHERE IPH_AktifYN = 'Y' "& filterAgen &"  "& filtercust &" "& filtermetpem &" "& filtertgl &""
  ' untuk data paggination
  page = Request.QueryString("page")

  orderBy = " ORDER BY IPH_Date DESC"
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

  call header("Invoice")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-lg-12 mb-3 mt-3 text-center">
      <h3>INVOICE PENJUALAN BRAND BARU</h3>
    </div>
  </div>
  <% if session("MK3A") = true then %>
  <div class="row">
    <div class="col-lg-12 mb-3">
      <a href="inv_add.asp" class="btn btn-primary ">Tambah</a>
    </div>
  </div>
  <% end if %>
  <form action="index.asp" method="post">
    <div class="row">
      <div class="col-lg-4 mb-3">
        <label for="Agen">Cabang</label>
        <select class="form-select" aria-label="Default select example" name="agen" id="agen">
          <option value="">Pilih</option>
          <% do while not agendata.eof %>
          <option value="<%= agendata("agenID") %>"><%= agendata("agenNAme") %></option>
          <% 
          agendata.movenext
          loop
          %>
        </select>
      </div>
      <div class="col-lg-4 mb-3">
        <label for="cust">Customer</label>
        <select class="form-select" aria-label="Default select example" name="cust" id="cust">
          <option value="">Pilih</option>
          <% do while not vendata.eof %>
          <option value="<%= vendata("custid") %>"><%= vendata("custnama") %></option>
          <% 
          vendata.movenext
          loop
          %>
        </select>
      </div>
    </div>
    <div class="row">
      <div class="col-lg-4 mb-3">
        <label for="tgla">Tanggal Pertama</label>
        <input type="date" class="form-control" name="tgla" id="tgla" autocomplete="off" >
      </div>
      <div class="col-lg-4 mb-3">
        <label for="tgle">Tanggal Kedua</label>
        <input type="date" class="form-control" name="tgle" id="tgle" autocomplete="off" >
      </div>
      <div class="col-lg-2 mt-4 mb-3">
        <button type="submit" class="btn btn-primary">Cari</button>
      </div>
    </div>
  </form>
  <div class="row">
    <div class="col-lg-12">
      <table class="table table-hover">
        <thead class="bg-secondary text-light">
          <th>No</th>
          <th>No.Invoice</th>
          <th>Cabang</th>
          <th>Tanggal</th>
          <th>Tanggal JT</th>
          <th>Customer</th>
          <th>Keterangan</th>
          <th class="text-center">Aksi</th>
        </thead>
        <tbody>
          <% 
          'prints records in the table
          showrecords = recordsonpage
          recordcounter = requestrecords
          do until showrecords = 0 OR  rs.EOF
          recordcounter = recordcounter + 1

          data_cmd.commandTExt = "SELECT IPD_IphID FROM MKT_T_InvJulNewD WHERE LEFT(IPD_IphID,13) = '"& rs("IPH_ID") &"'"
          set p = data_cmd.execute
          %>
            <tr>
              <TH><%= recordcounter %></TH>
              <th><%= LEFT(rs("IPH_ID"),2) &"-"& mid(rs("IPH_ID"),3,3) &"/"& mid(rs("IPH_ID"),6,4) &"/"& right(rs("IPH_ID"),4)%></th>
              <td><%= rs("AgenNAme")%></td>
              <td><%= Cdate(rs("IPH_Date")) %></td>
              <td>
                <% if rs("IPH_JTDate") <> "1900-01-01" then %>
                  <%= Cdate(rs("IPH_JTDate")) %>
                <% end if %>
              </td>
              <td><%= rs("custnama") %></td>
              <td><%= rs("IPH_Keterangan") %></td>
              <td class="text-center">
                <div class="btn-group" role="group" aria-label="Basic example">
                  <% if not p.eof then %>
                    <a href="detail.asp?id=<%= rs("IPH_ID") %>" class="btn badge text-light bg-warning">Detail</a>
                  <% end if %>
                  <% if session("MK3B") = true then %>    
                  <a href="invd_add.asp?id=<%= rs("IPH_ID") %>" class="btn badge text-bg-primary" >Update</a>
                  <% end if %>  
                  <% if session("MK3C") = true then %>    
                    <% if p.eof then %>
                      <a href="aktif.asp?id=<%= rs("IPH_ID") %>" class="btn badge text-bg-danger" onclick="deleteItem(event, 'HEADER INVOICE')">Delete</a>
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
                <a class="page-link prev" href="index.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&agen=<%=agen%>&cust=<%=cust%>&tgla=<%=tgla%>&tgle=<%=tgle%>">&#x25C4; Prev </a>
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
              <a class="page-link hal bg-primary text-light" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&cust=<%=cust%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
            <%else%>
              <a class="page-link hal" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&cust=<%=cust%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
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
                <a class="page-link next" href="index.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&agen=<%=agen%>&cust=<%=cust%>&tgla=<%=tgla%>&tgle=<%=tgle%>">Next &#x25BA;</a>
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

