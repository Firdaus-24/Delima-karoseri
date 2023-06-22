<!--#include file="../../init.asp"-->
<% 
  if session("PP6") = false then
    Response.Redirect("../")
  end if

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' filter agen
  data_cmd.commandText = "SELECT GLB_M_Agen.AgenID , GLB_M_Agen.AgenName FROM DLK_T_BOMRepairH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_BOMRepairH.BMRAgenID = GLB_M_Agen.AgenID WHERE DLK_T_BOMRepairH.BMRAktifYN = 'Y' GROUP BY GLB_M_Agen.AgenID, GLB_M_Agen.AgenName ORDER BY GLB_M_Agen.AgenName ASC"
  set agendata = data_cmd.execute

  ' filter no produksi
  data_cmd.commandText = "SELECT Bmrpdrid FROM DLK_T_BOMRepairH WHERE DLK_T_BOMRepairH.BMRAktifYN = 'Y' ORDER BY Bmrpdrid ASC"
  set pdrid = data_cmd.execute

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
  dkr = request.QueryString("dkr")
  if len(dkr) = 0 then 
    dkr = trim(Request.Form("dkr"))
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
    filterAgen = "AND DLK_T_BOMRepairH.BMRAgenID = '"& agen &"'"
  else
    filterAgen = ""
  end if
  if dkr <> "" then
    filterdkr = "AND DLK_T_BOMRepairH.BMRPDRID = '"& dkr &"'"
  else
    filterdkr = ""
  end if

  if tgla <> "" AND tgle <> "" then
    filtertgl = "AND dbo.DLK_T_BOMRepairH.BMRDate BETWEEN '"& tgla &"' AND '"& tgle &"'"
  elseIf tgla <> "" AND tgle = "" then
    filtertgl = "AND dbo.DLK_T_BOMRepairH.BMRDate = '"& tgla &"'"
  else 
    filtertgl = ""
  end if

  ' query seach 
  strquery = "SELECT DLK_T_BOMRepairH.*, GLB_M_Agen.AgenName FROM DLK_T_BOMRepairH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_BOMRepairH.BMRAgenID = GLB_M_Agen.AgenID WHERE (BMRAktifYN = 'Y') "& filterAgen &" "& filterdkr &" "& filtertgl &""
  ' untuk data paggination
  page = Request.QueryString("page")

  orderBy = " ORDER BY DLK_T_BOMRepairH.BMRID ASC"
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

  call header("B.O.M Repair") 
%>

<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-lg-12 mb-3 mt-3 text-center">
        <h3>B.O.M REPAIR</h3>
    </div>  
  </div>
  <% if session("PP6A") = true then %>
  <div class="row">
    <div class="col-lg-12 mb-3">
      <button type="button" class="btn btn-primary" onclick="window.location.href='bmr_add.asp'">
        Tambah
      </button>
    </div>
  </div>
  <% end if %>
  <form action="./" method="post">
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
        <label for="dkr">No.Produksi</label>
        <select class="form-select" aria-label="Default select example" name="dkr" id="dkr">
            <option value="">Pilih</option>
            <% do while not pdrid.eof %>
            <option value="<%= pdrid("Bmrpdrid") %>"><%= LEFT(pdrid("BMRPDRID"),3) &"-"& MID(pdrid("BMRPDRID"),4,2) &"/"& RIGHT(pdrid("BMRPDRID"),3) %></option>
            <% 
            Response.flush
            pdrid.movenext
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
          <button type="submRit" class="btn btn-primary">Cari</button>
        </div>
    </div>
  </form>
  <div class="row">
    <div class="col-lg-12">
        <table class="table table-hover">
          <thead class="bg-secondary text-light">
              <th>No</th>
              <th>No.BOM</th>
              <th>Cabang</th>
              <th>No.Produksi</th>
              <th>Man Power</th>
              <th>Approve 1</th>
              <th>Approve 2</th>
              <th class="text-center">Aksi</th>
          </thead>
          <tbody>
              <% 
              'prints records in the table
              showrecords = recordsonpage
              recordcounter = requestrecords
              do until showrecords = 0 OR  rs.EOF
              recordcounter = recordcounter + 1

              ' cek data detail
              data_cmd.commandText = "SELECT BmrdID FROM DLK_T_BOMRepairD WHERE LEFT(BmrdID,13) = '"& rs("BMRID") &"'"

              set ddata = data_cmd.execute

              ' cek data anggaran memo
              data_cmd.commandText = "SELECT memobmrid FROM DLK_T_memo_h where memobmrid = '"& rs("bmrid") &"' AND memoaktifyn = 'Y'"
              set ckmemo = data_cmd.execute
              %>
                <tr><TH><%= recordcounter %></TH>
                <td><%=left(rs("BMRID"),3)&"-"&MID(rs("BMRID"),4,3)&"/"&MID(rs("BMRID"),7,4)&"/"&right(rs("BMRID"),3)%></td>
                <td><%= rs("agenName") %></td>
                <td><%=LEFT(rs("BMRPDRID"),3) &"-"& MID(rs("BMRPDRID"),4,2) &"/"& RIGHT(rs("BMRPDRID"),3) %></td>
                <td><%=rs("BMRManpower")%></td>
                <td>
                  <% if session("PP6F") = true then %>
                    <% if rs("bmrapprove1") = "N" then%>
                      <button type="button" class="btn btn-outline-primary"style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;" data-bs-toggle="modal" data-bs-target="#modalbomrepair" onclick="sendEmailbomrepair(1, '<%=rs("bmrid")%>')">
                        ajukan
                      </button>
                    <% else %>
                      <i class="bi bi-check2"></i>
                    <% end if %>
                  <% else %>
                    -
                  <% end if%>
                </td>
                <td>
                  <% if session("PP6F") = true then %>
                    <% if rs("bmrapprove2") = "N" then%>
                      <button type="button" class="btn btn-outline-primary"style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;" data-bs-toggle="modal" data-bs-target="#modalbomrepair"  onclick="sendEmailbomrepair(2, '<%=rs("bmrid")%>')">
                        ajukan
                      </button>
                    <% else %>
                      <i class="bi bi-check2"></i>
                    <% end if %>
                  <% else %>
                    -
                  <% end if%>
                </td>
                <td class="text-center">
                  <div class="btn-group" role="group" aria-label="Basic example">
                      <% if session("PP7A") = true then %>
                        <% if rs("bmrapprove1") = "Y" AND rs("bmrapprove2") = "Y" then%>
                          <% if ckmemo.eof then %>
                            <a href="anggaran_add.asp?id=<%= rs("BMRID") %>" class="btn badge text-bg-light" >anggarkan</a>
                          <% end if%>
                        <%end if%>
                      <%end if%>
                      <% if session("PP6B") = true then %>
                        <a href="bmrd_add.asp?id=<%= rs("BMRID") %>" class="btn badge text-bg-primary" >Update</a>
                      <% end if %>
                      <% if not ddata.eof then %>
                      <a href="detail.asp?id=<%= rs("BMRID") %>" class="btn badge text-light bg-warning">Detail</a>
                      <% else %>
                        <% if session("PP6C") = true then %>
                            <a href="aktif.asp?id=<%= rs("BMRID") %>&p=N" class="btn badge text-bg-danger" onclick="deleteItem(event,'delete B.O.M Repair')">Delete</a>
                        <%end if %>
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
                <a class="page-link prev" href="./?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&agen=<%=agen%>&dkr=<%=dkr%>&tgla=<%=tgla%>&tgle=<%=tgle%>">&#x25C4; Prev </a>
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
                      <a class="page-link hal bg-primary text-light" href="./?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&dkr=<%=dkr%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
                <%else%>
                      <a class="page-link hal" href="./?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&dkr=<%=dkr%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
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
                      <a class="page-link next" href="./?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&agen=<%=agen%>&dkr=<%=dkr%>&tgla=<%=tgla%>&tgle=<%=tgle%>">Next &#x25BA;</a>
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
<div class="modal fade" id="modalbomrepair" tabindex="-1" aria-labelledby="modalbomrepairLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="modalbomrepairLabel">Send Email</h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form action="sendemail.asp" method="post">
          <input type="hidden" id="ajuanbomke" name="ajuanbomke" required>
          <input type="hidden" id="idbomrepair" name="idbomrepair" required>
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
      </div>
    </div>
  </div>
</div>
<% call footer() %>
<script>
const sendEmailbomrepair = (e, id) => {
  $("#ajuanbomke").val(e)
  $("#idbomrepair").val(id)
}
</script>