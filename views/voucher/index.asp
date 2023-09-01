<!--#include file="../../init.asp"-->
<% 
  if session("PP9") = false then
    Response.Redirect(".././")
  end if

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  ' filter agen
  data_cmd.commandText = "SELECT dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID FROM dbo.DLK_T_VoucherH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_VoucherH.VCH_Agenid = dbo.GLB_M_Agen.AgenID GROUP BY dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID, dbo.DLK_T_VoucherH.VCH_AktifYN HAVING (dbo.DLK_T_VoucherH.VCH_AktifYN = 'Y') ORDER BY GLB_M_Agen.AgenName ASC"
  set agendata = data_cmd.execute
  
  ' filter new produksi
  data_cmd.commandTExt = "SELECT VCH_PDDID FROM dbo.DLK_T_VoucherH WHERE (VCH_AktifYN = 'Y') AND VCH_PDDID <> ''  GROUP BY VCH_PDDID ORDER BY VCH_PDDID ASC"

  set pddid = data_cmd.execute

  ' filter  produksi repair
  data_cmd.commandTExt = "SELECT VCH_PDRID FROM   dbo.DLK_T_VoucherH WHERE (VCH_AktifYN = 'Y') AND VCH_PDRID <> '' GROUP BY VCH_PDRID ORDER BY VCH_PDRID"

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
  dpddid = request.QueryString("dpddid")
  if len(dpddid) = 0 then 
    dpddid = trim(Request.Form("dpddid"))
  end if
  dpdrid = request.QueryString("dpdrid")
  if len(dpdrid) = 0 then 
    dpdrid = trim(Request.Form("dpdrid"))
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
    filterAgen = "AND MKT_T_OrJulH.VCH_AgenID = '"& agen &"'"
  else
    filterAgen = ""
  end if
  if dpddid <> "" then
    filterdpddid = "AND DLK_T_VoucherH.VCH_PDDID = '"& dpddid &"'"
  else
    filterdpddid = ""
  end if
  if dpdrid <> "" then
    filterdpdrid = "AND DLK_T_VoucherH.VCH_PDRID = '"& dpdrid &"'"
  else
    filterdpdrid = ""
  end if

  if tgla <> "" AND tgle <> "" then
    filtertgl = "AND dbo.MKT_T_OrJulH.VCH_Date BETWEEN '"& tgla &"' AND '"& tgle &"'"
  elseIf tgla <> "" AND tgle = "" then
    filtertgl = "AND dbo.MKT_T_OrJulH.VCH_Date = '"& tgla &"'"
  else 
    filtertgl = ""
  end if

  ' query seach 
  strquery = "SELECT dbo.GLB_M_Agen.AgenName, dbo.DLK_T_VoucherH.* FROM dbo.DLK_T_VoucherH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_VoucherH.VCH_Agenid = dbo.GLB_M_Agen.AgenID WHERE (DLK_T_VoucherH.VCH_AktifYN = 'Y') "& filterAgen &""& filterdpddid &""& filterdpdrid &""& filtertgl &""
  ' untuk data paggination
  page = Request.QueryString("page")

  orderBy = " ORDER BY VCH_Date DESC"
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

  call header("Voucher")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-lg-12 mb-3 mt-3 text-center">
      <h3>VOUCHER PERMINTAAN BARANG</h3>
    </div>
  </div>
  <% if session("PP9A") = true then %>
  <div class="row">
    <div class="col-lg-12 mb-3">
      <a href="vc_add.asp" class="btn btn-primary ">Tambah</a>
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
          Response.flush
          agendata.movenext
          loop
          %>
        </select>
      </div>
      <div class="col-lg-4 mb-3">
        <label for="dpddid">New Produksi</label>
        <select class="form-select" aria-label="Default select example" name="dpddid" id="dpddid">
          <option value="">Pilih</option>
          <% do while not pddid.eof %>
          <option value="<%= pddid("VCH_PDDID") %>"><%= pddid("VCH_PDDID") %></option>
          <% 
          Response.flush
          pddid.movenext
          loop
          %>
        </select>
      </div>
      <div class="col-lg-4 mb-3">
        <label for="dpdrid">Produksi Repair</label>
        <select class="form-select" aria-label="Default select example" name="dpdrid" id="dpdrid">
          <option value="">Pilih</option>
          <% do while not pdrid.eof %>
          <option value="<%= pdrid("VCH_PDRID") %>"><%= LEFT(pdrid("VCH_PDRID"),3) &"-"& MID(pdrid("VCH_PDRID"),4,2) &"/"& RIGHT(pdrid("VCH_PDRID"),3) %></option>
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
        <button type="submit" class="btn btn-primary">Cari</button>
      </div>
    </div>
  </form>
  <div class="row">
    <div class="col-lg-12">
      <table class="table table-hover">
        <thead class="bg-secondary text-light">
          <th>No</th>
          <th>Kode Voucher</th>
          <th>Tanggal</th>
          <th>New Produksi</th>
          <th>Produksi Repair</th>
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

          data_cmd.commandTExt = "SELECT VCH_VCHID FROM DLK_T_VoucherD WHERE LEFT(VCH_VCHID,13) = '"& rs("VCH_ID") &"'"
          set p = data_cmd.execute
          %>
            <tr><TH><%= recordcounter %></TH>
            <th>
              <%= left(rs("VCH_ID"),2) %>-<%= mid(rs("VCH_ID"),3,3) %>/<%= mid(rs("VCH_ID"),6,4) %>/<%= right(rs("VCH_ID"),4)  %>
            </th>
            <td><%= Cdate(rs("VCH_Date")) %></td>
            <td>
              <%if rs("VCH_PDDID") <>  "" then%>
                <%= left(rs("VCH_PDDID"),2) %>-<%= mid(rs("VCH_PDDID"),3,3) %>/<%= mid(rs("VCH_PDDID"),6,4) %>/<%= mid(rs("VCH_PDDID"),10,4) %>/<%= right(rs("VCH_PDDID"),3)%>
              <%else%>
                -
              <%end if%>
            </td>
            <td>
              <%if rs("VCH_PDRID") <> "" then%>
                <%= LEFT(rs("VCH_PDRID"),3) &"-"& MID(rs("VCH_PDRID"),4,2) &"/"& RIGHT(rs("VCH_PDRID"),3) %>
              <%else%>
                - 
              <%end if%>
            </td>
            <td><%= rs("VCH_Keterangan")%></td>
            <td class="text-center">
              <div class="btn-group" role="group" aria-label="Basic example">
                <% if not p.eof then %>
                  <a href="detail.asp?id=<%= rs("VCH_ID") %>" class="btn badge text-light bg-warning">Detail</a>
                <% end if %>
                <% if session("PP9B") = true then %>
                  <a href="vcd_add.asp?id=<%= rs("VCH_ID") %>" class="btn badge text-bg-primary" >Update</a>
                <% end if %>   
                <% if session("PP9C") = true then %>
                  <% if p.eof then %>
                    <a href="aktifh.asp?id=<%= rs("VCH_ID") %>" class="btn badge text-bg-danger" onclick="deleteItem(event,'DELETE VOUCHER')">Delete</a>
                  <% end if %>
                <%end if %>
              </div>
            </td>
          </tr>
          <% 
          Response.flush
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
            <a class="page-link prev" href="./?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&agen=<%=agen%>&dpddid=<%=dpddid%>&dpdrid=<%=dpdrid%>&tgla=<%=tgla%>&tgle=<%=tgle%>">&#x25C4; Prev </a>
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
                <a class="page-link hal bg-primary text-light" href="./?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&dpddid=<%=dpddid%>&dpdrid=<%=dpdrid%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
            <%else%>
                <a class="page-link hal" href="./?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&dpddid=<%=dpddid%>&dpdrid=<%=dpdrid%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
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
                <a class="page-link next" href="./?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&agen=<%=agen%>&dpddid=<%=dpddid%>&dpdrid=<%=dpdrid%>&tgla=<%=tgla%>&tgle=<%=tgle%>">Next &#x25BA;</a>
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

