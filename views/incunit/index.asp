<!--#include file="../../init.asp"-->
<% 
  if session("MQ4") = false then
    Response.Redirect("../")
  end if

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' filter agen
  data_cmd.commandText = "SELECT GLB_M_Agen.AgenID , GLB_M_Agen.AgenName FROM DLK_T_IncRepairH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_IncRepairH.IRH_AgenID = GLB_M_Agen.AgenID WHERE DLK_T_IncRepairH.IRH_AktifYN = 'Y' GROUP BY GLB_M_Agen.AgenID, GLB_M_Agen.AgenName ORDER BY GLB_M_Agen.AgenName ASC"
  set agendata = data_cmd.execute

  ' filter customer
  data_cmd.commandTExt = "SELECT custNama, CustID FROM DLK_T_IncRepairH LEFT OUTER JOIN DLK_M_Customer ON LEFT(DLK_T_IncRepairH.IRH_TFKID,11) = DLK_M_Customer.custID WHERE IRH_AktifYN = 'Y' GROUP BY custNama, custID ORDER BY CustNama ASC"
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
  agen = request.QueryString("agen")
  if len(agen) = 0 then 
    agen = trim(Request.Form("agen"))
  end if
  custid = request.QueryString("custid")
  if len(custid) = 0 then 
    custid = trim(Request.Form("custid"))
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
    filterAgen = "AND DLK_T_IncRepairH.IRH_AgenID = '"& agen &"'"
  else
    filterAgen = ""
  end if
  if custid <> "" then
    filtercustid = "AND LEFT(DLK_T_IncRepairH.IRH_TFKID,11) = '"& custid &"'"
  else
    filtercustid = ""
  end if

  if tgla <> "" AND tgle <> "" then
    filtertgl = "AND dbo.DLK_T_IncRepairH.IRH_Date BETWEEN '"& tgla &"' AND '"& tgle &"'"
  elseIf tgla <> "" AND tgle = "" then
    filtertgl = "AND dbo.DLK_T_IncRepairH.IRH_Date = '"& tgla &"'"
  else 
    filtertgl = ""
  end if

  ' query seach 
  strquery = "SELECT DLK_T_IncRepairH.*, GLB_M_Agen.AgenName FROM DLK_T_IncRepairH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_IncRepairH.IRH_AgenID = GLB_M_Agen.AgenID WHERE IRH_AktifYN = 'Y' "& filterAgen &"  "& filtercust &" "& filtermetpem &" "& filtertgl &" "& filtercustid &""
  ' untuk data paggination
  page = Request.QueryString("page")

  orderBy = " ORDER BY IRH_ID, IRH_Date DESC"
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
  
  call header("Incoming Unit")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-lg-12 mb-3 mt-3 text-center">
      <h3>INCOMMING UNIT INSPECTION </h3>
    </div>
  </div>
  <% if session("MQ4A") = true then %>
  <div class="row">
    <div class="col-lg-12 mb-3">
      <a href="incr_add.asp" class="btn btn-primary ">Tambah</a>
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
        <label for="custid">Customer</label>
        <select class="form-select" aria-label="Default select example" name="custid" id="custid">
          <option value="">Pilih</option>
          <% do while not datacust.eof %>
          <option value="<%= datacust("custid") %>"><%= datacust("custnama") %></option>
          <% 
          datacust.movenext
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
          <th>No.Unit</th>
          <th>Cabang</th>
          <th>Tanggal</th>
          <th>Aprrove 1</th>
          <th>Aprrove 2</th>
          <th>Aprrove 3</th>
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

          data_cmd.commandTExt = "SELECT IRD_IRHID FROM DLK_T_IncRepairD WHERE LEFT(IRD_IRHID,13) = '"& rs("IRH_ID") &"'"
          set p = data_cmd.execute
          %>
            <tr>
              <TH><%= recordcounter %></TH>
              <th><%= LEFT(rs("IRH_ID"),4) &"-"& mid(rs("IRH_ID"),5,3) &"/"& mid(rs("IRH_ID"),8,4) &"/"& right(rs("IRH_ID"),2)%></th>
              <td><%= rs("AgenNAme")%></td>
              <td><%= Cdate(rs("IRH_Date")) %></td>
              <td class="text-center">
                <% if rs("IRH_Approve1") = "N" then %>
                  <%if session("MQ4F") = true then%>
                  <button type="button" class="btn btn-light" style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;" data-bs-toggle="modal" data-bs-target="#modalEmailincrd" onclick="sendEmailIncrepair(1, '<%=rs("IRH_ID")%>')">
                    Ajukan
                  </button>
                  <%else%>
                    -
                  <%end if%>
                <%else%>
                  <i class="bi bi-check2"></i>
                <%end if%>
              </td>
              <td class="text-center">
                <% if rs("IRH_Approve2") = "N" then %>
                  <%if session("MQ4F") = true then%>
                  <button type="button" class="btn btn-light" style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;" data-bs-toggle="modal" data-bs-target="#modalEmailincrd"  onclick="sendEmailIncrepair(2,'<%=rs("IRH_ID")%>')">
                    Ajukan
                  </button>
                  <%else%>
                    -
                  <%end if%>
                <%else%>
                  <i class="bi bi-check2"></i>
                <%end if%>  
              </td>
              <td class="text-center">
                <% if rs("IRH_Approve3") = "N" then %>
                  <%if session("MQ4F") = true then%>
                  <button type="button" class="btn btn-light" style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;" data-bs-toggle="modal" data-bs-target="#modalEmailincrd"  onclick="sendEmailIncrepair(3, '<%=rs("IRH_ID")%>')">
                    Ajukan
                  </button>
                  <%else%>
                    -
                  <%end if%>
                <%else%>
                  <i class="bi bi-check2"></i>
                <%end if%>  
              </td>
              <td><%= rs("IRH_Keterangan") %></td>
              <td class="text-center">
                <div class="btn-group" role="group" aria-label="Basic example">
                  <% if not p.eof then %>
                    <a href="detail.asp?id=<%= rs("IRH_ID") %>" class="btn badge text-light bg-warning">Detail</a>
                  <% end if %>
                  <% if session("MQ4B") = true then %>    
                  <a href="incrd_add.asp?id=<%= rs("IRH_ID") %>" class="btn badge text-bg-primary" >Update</a>
                  <% end if %>  
                  <% if session("MQ4C") = true then %>    
                    <% if p.eof then %>
                      <a href="aktif.asp?id=<%= rs("IRH_ID") %>" class="btn badge text-bg-danger" onclick="deleteItem(event, 'INCOMING UNIT REPAIR')">Delete</a>
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
                <a class="page-link prev" href="index.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&agen=<%=agen%>&tgla=<%=tgla%>&tgle=<%=tgle%>&custid=<%=custid%>">&#x25C4; Prev </a>
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
              <a class="page-link hal bg-primary text-light" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&tgla=<%=tgla%>&tgle=<%=tgle%>&custid=<%=custid%>"><%= pagelistcounter %></a> 
            <%else%>
              <a class="page-link hal" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&tgla=<%=tgla%>&tgle=<%=tgle%>&custid=<%=custid%>"><%= pagelistcounter %></a> 
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
                <a class="page-link next" href="index.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&agen=<%=agen%>&tgla=<%=tgla%>&tgle=<%=tgle%>&custid=<%=custid%>">Next &#x25BA;</a>
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
<div class="modal fade" id="modalEmailincrd" tabindex="-1" aria-labelledby="modalEmailincrdLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="modalEmailincrdLabel">Verifikasi Email</h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form action="sendemail.asp" method="post">
          <input type="hidden" id="ajuanincrepair" name="ajuanincrepair" required>
          <input type="hidden" id="idincrepair" name="idincrepair" required>
          <div class="row">
            <div class="col-md-3 mb-3">
              <label for="email" class="col-form-label">Email Ke-</label>
            </div>
            <div class="col-md-9 mb-3">
              <input type="email" id="email" name="email" class="form-control" required>
            </div>
          </div>
          <div class="row">
            <div class="col-md-3 mb-3">
              <label for="subject" class="col-form-label">Subject</label>
            </div>
            <div class="col-md-9 mb-3">
              <input type="text" id="subject" name="subject" class="form-control" required>
            </div>
          </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary">Send</button>
        </form>
      </div>
    </div>
  </div>
</div>
<% call footer() %>


