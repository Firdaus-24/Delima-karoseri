<!--#include file="../../init.asp"-->
<% 
    if session("PP2") = false then
        Response.Redirect("../index.asp")
    end if

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    '    filter agen
    data_cmd.commandText = "SELECT dbo.GLB_M_Agen.AgenName, dbo.GLB_M_Agen.AgenID FROM dbo.DLK_T_ManpowerH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_ManpowerH.MP_AgenID = dbo.GLB_M_Agen.AgenID GROUP BY GLB_M_Agen.AgenID, GLB_M_Agen.AgenName ORDER BY GLB_M_Agen.AgenName ASC"
    set agendata = data_cmd.execute
    
    ' filter produksi
    data_cmd.commandTExt = "SELECT dbo.DLK_T_ProduksiH.PDH_ID FROM dbo.DLK_T_ManPowerH LEFT OUTER JOIN dbo.DLK_T_ProduksiH ON dbo.DLK_T_ManPowerH.MP_PDHID = dbo.DLK_T_ProduksiH.PDH_ID GROUP BY dbo.DLK_T_ProduksiH.PDH_ID ORDER BY dbo.DLK_T_ProduksiH.PDH_ID"

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
    prodmp = request.QueryString("prodmp")
    if len(prodmp) = 0 then 
        prodmp = trim(Request.Form("prodmp"))
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
        filterAgen = "AND DLK_T_ManpowerH.MP_AgenID = '"& agen &"'"
    else
        filterAgen = ""
    end if
    if prodmp <> "" then
        filterprodmp = "AND DLK_T_ManpowerH.MP_PDHID = '"& prodmp &"'"
    else
        filterprodmp = ""
    end if


    if tgla <> "" AND tgle <> "" then
        filtertgl = "AND dbo.DLK_T_ManpowerH.MP_Date BETWEEN '"& tgla &"' AND '"& tgle &"'"
    elseIf tgla <> "" AND tgle = "" then
        filtertgl = "AND dbo.DLK_T_ManpowerH.MP_Date = '"& tgla &"'"
    else 
        filtertgl = ""
    end if

   ' query seach 
   strquery = "SELECT dbo.DLK_T_ManPowerH.*, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_WebLogin.UserName FROM dbo.DLK_T_ManPowerH LEFT OUTER JOIN dbo.DLK_M_WebLogin ON dbo.DLK_T_ManPowerH.MP_Updateid = dbo.DLK_M_WebLogin.UserID LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_ManPowerH.MP_AgenID = dbo.GLB_M_Agen.AgenID WHERE ((dbo.DLK_T_ManPowerH.MP_AktifYN = 'Y') OR (dbo.DLK_T_ManPowerH.MP_AktifYN = 'N')) "& filterAgen &""& filterprodmp &""& filtertgl &""
   ' untuk data paggination
   page = Request.QueryString("page")

   orderBy = " ORDER BY dbo.DLK_T_ManPowerH.MP_ID"
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

    call header("Man Power")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>MAN POWER</h3>
        </div>
    </div>
    <% if session("PP2A") = true then %>
    <div class="row">
        <div class="col-lg-12 mb-3">
            <a href="mp_add.asp" class="btn btn-primary ">Tambah</a>
        </div>
    </div>
   <% end if %>
    <form action="index.asp" method="post">
        <div class="row">
            <div class="col-lg-4 mb-3">
                <label for="Agen">Cabang</label>
                <select class="form-select" aria-label="Default select example" name="agen" id="agen">
                <option value="">Pilih</option>
                <%do while not agendata.eof %>
                <option value="<%= agendata("agenID") %>"><%= agendata("agenNAme") %></option>
                <% 
                Response.flush
                agendata.movenext
                loop
                %>
                </select>
            </div>
            <div class="col-lg-4 mb-3">
                <label for="prodmp">No.Produksi</label>
                <select class="form-select" aria-label="Default select example" name="prodmp" id="prodmp">
                <option value="">Pilih</option>
                <% do while not proddata.eof %>
                <option value="<%= proddata("PDH_ID") %>">
                    <%= left(proddata("PDH_ID"),2) %>-<%= mid(proddata("PDH_ID"),3,3) %>/<%= mid(proddata("PDH_ID"),6,4) %>/<%= right(proddata("PDH_ID"),4)  %>
                </option>
                <% 
                Response.flush
                proddata.movenext
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
                <% if session("PP2D") = true then %>
                <% if agen <> "" OR tgla <> "" OR tgle <> "" OR prodmp <> "" then %>
                    <button type="button" class="btn btn-secondary" onclick="window.location.href='export-XLSMpH.asp?tgla=<%=tgla%>&tgle=<%=tgle%>&agen=<%=agen%>&prodmp=<%=prodmp%>'">Export</button>
                <% end if %>
                <%end if %>
            </div>
        </div>
    </form>
    <div class="row">
        <div class="col-lg-12">
            <table class="table table-hover">
                <thead class="bg-secondary text-light">
                <th>No</th>
                <th>ID</th>
                <th>No.Produksi</th>
                <th>Cabang</th>
                <th>Tanggal</th>
                <th>Update ID</th>
                <th class="text-center">Aksi</th>
                </thead>
                <tbody>
                <% 
                'prints records in the table
                showrecords = recordsonpage
                recordcounter = requestrecords
                do until showrecords = 0 OR  rs.EOF
                recordcounter = recordcounter + 1

                data_cmd.commandTExt = "SELECT MP_ID FROM DLK_T_ManPowerD WHERE LEFT(MP_ID,4) = '"& LEFT(rs("MP_ID"),4) &"' AND RIGHT(MP_ID,7) = '"& RIGHT(rs("MP_ID"),7) &"'"
                set p = data_cmd.execute
                %>
                    <tr><TH><%= recordcounter %></TH>
                    <th>
                        <%= left(rs("MP_ID"),2) %>-<%= mid(rs("MP_ID"),3,2) %>/<%= mid(rs("MP_ID"),5,4) %>/<%= right(rs("MP_ID"),3)  %>
                    </th>
                    <th>
                        <%= left(rs("MP_PDHID"),2) %>-<%= mid(rs("MP_PDHID"),3,3) %>/<%= mid(rs("MP_PDHID"),6,4) %>/<%= right(rs("MP_PDHID"),4)  %>
                    </th>
                    <td><%= rs("AgenNAme")%></td>
                    <td><%= Cdate(rs("MP_Date")) %></td>
                    <td><%= rs("username")%></td>
                    <td class="text-center">
                        <div class="btn-group" role="group" aria-label="Basic example">
                            <% if not p.eof then %>
                            <a href="detail.asp?id=<%= rs("MP_ID") %>" class="btn badge text-light bg-warning">Detail</a>
                            <% end if %>
                            <% if session("PP2B") = true then %>
                            <a href="mpd_u.asp?id=<%= rs("MP_ID") %>" class="btn badge text-bg-primary" >Update</a>
                            <% end if %>   
                            <% if session("PP2C") = true then %>
                            <% if p.eof then %>
                                <% if rs("MP_AktifYN") = "Y" then%>
                                    <a href="aktifh.asp?id=<%= rs("MP_ID") %>&p=N" class="btn badge text-bg-danger" onclick="deleteItem(event,'DELETE TRANSAKSI MANPOWER')">Delete</a>
                                <% else %>
                                    <a href="aktifh.asp?id=<%= rs("MP_ID") %>&p=Y" class="btn badge text-bg-light" onclick="deleteItem(event,'AKTIF TRANSAKSI MANPOWER')">Aktif</a>
                                <% end if %>
                            <% end if %>
                            <%end if %>
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
                    <a class="page-link prev" href="index.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&agen=<%=agen%>&prodmp=<%=prodmp%>&tgla=<%=tgla%>&tgle=<%=tgle%>">&#x25C4; Prev </a>
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
                        <a class="page-link hal bg-primary text-light" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&prodmp=<%=prodmp%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
                    <%else%>
                        <a class="page-link hal" href="index.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&prodmp=<%=prodmp%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
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
                        <a class="page-link next" href="index.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&agen=<%=agen%>&prodmp=<%=prodmp%>&tgla=<%=tgla%>&tgle=<%=tgle%>">Next &#x25BA;</a>
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

