<!--#include file="../../init.asp"-->
<% 
   set data_cmd =  Server.CreateObject ("ADODB.Command")
   data_cmd.ActiveConnection = mm_delima_string

   ' filter agen
   data_cmd.commandText = "SELECT GLB_M_Agen.AgenID , GLB_M_Agen.AgenName FROM DLK_T_BOMH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_BOMH.BMH_AgenID = GLB_M_Agen.AgenID WHERE DLK_T_BOMH.BMH_AktifYN = 'Y' AND DLK_T_BOMH.BMH_Approve1 = 'Y' AND DLK_T_BOMH.BMH_Approve2 = 'Y' GROUP BY GLB_M_Agen.AgenID, GLB_M_Agen.AgenName ORDER BY GLB_M_Agen.AgenName ASC"
   set agendata = data_cmd.execute
   ' filter produk
   data_cmd.commandTExt = "SELECT dbo.DLK_M_ProductH.PDID, dbo.DLK_M_Barang.Brg_Nama FROM dbo.DLK_M_Barang INNER JOIN dbo.DLK_M_ProductH ON dbo.DLK_M_Barang.Brg_Id = dbo.DLK_M_ProductH.PDBrgID RIGHT OUTER JOIN dbo.DLK_T_BOMH ON dbo.DLK_M_ProductH.PDID = dbo.DLK_T_BOMH.BMH_PDID WHERE dbo.DLK_T_BOMH.BMH_AktifYN = 'Y' AND DLK_T_BOMH.BMH_Approve1 = 'Y' AND DLK_T_BOMH.BMH_Approve2 = 'Y' GROUP BY dbo.DLK_M_ProductH.PDID, dbo.DLK_M_Barang.Brg_Nama, dbo.DLK_T_BOMH.BMH_AktifYN ORDER BY Brg_Nama ASC"

   set dataproduk = data_cmd.execute

   agen = trim(Request.Form("agen"))
   produk = trim(Request.Form("produk"))
   tgla = trim(Request.Form("tgla"))
   tgle = trim(Request.Form("tgle"))

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
   
   if agen <> "" then
      filterAgen = "AND DLK_T_BOMH.BMH_AgenID = '"& agen &"'"
   else
      filterAgen = ""
   end if

   if produk <> "" then
      filterproduk = "AND dbo.DLK_T_BOMH.BMH_PDID = '"& produk &"'"
   else
      filterproduk = ""
   end if

   if tgla <> "" AND tgle <> "" then
      filtertgl = "AND dbo.DLK_T_BOMH.BMH_Date BETWEEN '"& tgla &"' AND '"& tgle &"'"
   elseIf tgla <> "" AND tgle = "" then
      filtertgl = "AND dbo.DLK_T_BOMH.BMH_Date = '"& tgla &"'"
   else 
      filtertgl = ""
   end if

   ' query seach 
   strquery = "SELECT dbo.DLK_T_BOMH.*, dbo.GLB_M_Agen.AgenName, dbo.DLK_M_ProductH.PDBrgID, DLK_M_Barang.Brg_Nama FROM dbo.DLK_T_BOMH LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.DLK_T_BOMH.BMH_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN dbo.DLK_M_ProductH ON dbo.DLK_T_BOMH.BMH_PDID = dbo.DLK_M_ProductH.PDID INNER JOIN DLK_M_Barang ON DLK_M_ProductH.PDBrgID = DLK_M_Barang.Brg_ID WHERE DLK_T_BOMH.BMH_AktifYN = 'Y' AND DLK_T_BOMH.BMH_Approve1 = 'Y' AND DLK_T_BOMH.BMH_Approve2 = 'Y' "& filterAgen &" "& filterproduk &" "& filtertgl &""
   ' untuk data paggination
   page = Request.QueryString("page")

   orderBy = " ORDER BY BMH_Date DESC"
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

    call header("Permintaan BOM")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>FORM PERMINTAAN B.O.M</h3>
        </div>
    </div>
    <form action="permintaan.asp" method="post">
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
                <label for="produk">Produk</label>
                <select class="form-select" aria-label="Default select example" name="produk" id="produk">
                <option value="">Pilih</option>
                <% do while not dataproduk.eof %>
                <option value="<%= dataproduk("PDID") %>"><%= dataproduk("Brg_Nama") %></option>
                <% 
                dataproduk.movenext
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
                <th>Bom ID</th>
                <th>Cabang</th>
                <th>Tanggal</th>
                <th>Product</th>
                <th>Approve1</th>
                <th>Approve2</th>
                <th>Prototype</th>
                <th class="text-center">Aksi</th>
                </thead>
                <tbody>
                <% 
                'prints records in the table
                showrecords = recordsonpage
                recordcounter = requestrecords
                do until showrecords = 0 OR  rs.EOF
                recordcounter = recordcounter + 1

                data_cmd.commandTExt = "SELECT BMD_ID FROM DLK_T_BOMD WHERE LEFT(BMD_ID,13) = '"& rs("BMH_ID") &"'"
                set p = data_cmd.execute
                %>
                    <tr><TH><%= recordcounter %></TH>
                    <th><%= rs("BMH_ID") %></th>
                    <td><%= rs("AgenNAme")%></td>
                    <td><%= Cdate(rs("BMH_Date")) %></td>
                    <td><%= rs("Brg_Nama") %></td>
                    <td>
                        <% if rs("BMH_Approve1") = "Y" then %>
                            Yes
                        <% end if %>
                    </td>
                    <td>
                        <% if rs("BMH_Approve2") = "Y" then %>
                            Yes
                        <% end if %>
                    </td>
                    <td>
                        <% if rs("BMH_PrototypeYN") = "Y" then %>
                            Yes
                        <% else %>
                            No
                        <% end if %>
                    </td>
                    <td class="text-center">
                        <div class="btn-group" role="group" aria-label="Basic example">
                            <% if not p.eof then %>
                            <a href="detailPermintaan.asp?id=<%= rs("BMH_ID") %>" class="btn badge text-light bg-warning">Detail</a>
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
                        <a class="page-link prev" href="permintaan.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>">&#x25C4; Prev </a>
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
                            <a class="page-link hal bg-primary text-light" href="permintaan.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>"><%= pagelistcounter %></a> 
                        <%else%>
                            <a class="page-link hal" href="permintaan.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>"><%= pagelistcounter %></a> 
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
                            <a class="page-link next" href="permintaan.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>">Next &#x25BA;</a>
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

