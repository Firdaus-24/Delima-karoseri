<!--#include file="../../init.asp"-->
<% 
  if session("INV10") = false then
    Response.Redirect("../")
  end if

  ' query cabang  
  set agen_cmd =  Server.CreateObject ("ADODB.Command")
  agen_cmd.ActiveConnection = mm_delima_string
  ' filter agen
  agen_cmd.commandText = "SELECT GLB_M_Agen.AgenID , GLB_M_Agen.AgenName FROM DLK_T_Memo_H LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = GLB_M_Agen.AgenID WHERE GLB_M_Agen.AgenAktifYN = 'Y' and DLK_T_Memo_H.memoAktifYN = 'Y' AND memobmid <> '' AND memopdhid <> '' GROUP BY GLB_M_Agen.AgenID, GLB_M_Agen.AgenName ORDER BY GLB_M_Agen.AgenName ASC"
  set agendata = agen_cmd.execute
  ' filter kebutuhan
  agen_cmd.commandText = "SELECT dbo.HRD_M_Departement.DepID, dbo.HRD_M_Departement.DepNama FROM dbo.HRD_M_Departement INNER JOIN dbo.DLK_T_Memo_H ON dbo.HRD_M_Departement.DepID = dbo.DLK_T_Memo_H.memoDepID WHERE dbo.DLK_T_Memo_H.memoAktifYN = 'Y' AND memobmid <> '' AND memopdhid <> '' GROUP BY dbo.HRD_M_Departement.DepID, dbo.HRD_M_Departement.DepNama"
  set DepData = agen_cmd.execute

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
  keb = request.QueryString("keb")
  if len(keb) = 0 then 
      keb = trim(Request.Form("keb"))
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
      filterAgen = "AND memoAgenID = '"& agen &"'"
  else
      filterAgen = ""
  end if

  if keb <> "" then
      filterKeb = "AND memoDepID = '"& keb &"'"
  else
      filterKeb = ""
  end if

  if tgla <> "" AND tgle <> "" then
      filtertgl = "AND memotgl BETWEEN '"& tgla &"' AND '"& tgle &"'"
  elseIf tgla <> "" AND tgle = "" then
      filtertgl = "AND memotgl = '"& tgla &"'"
  else 
      filtertgl = ""
  end if
  ' query seach 
  strquery = "SELECT DLK_T_Memo_H.*, GLB_M_Agen.AgenName, HRD_M_Divisi.DivNama, HRD_M_Departement.DepNama FROM DLK_T_Memo_H LEFT OUTER JOIN GLB_M_Agen ON DLK_T_Memo_H.memoAgenID = LEFT(GLB_M_Agen.AgenID,3) LEFT OUTER JOIN HRD_M_Divisi ON DLK_T_Memo_H.memoDivid = HRD_M_Divisi.divID LEFT OUTER JOIN HRD_M_Departement ON DLK_T_Memo_H.MemoDepID = HRD_M_Departement.DepID WHERE MemoAktifYN = 'Y' AND memobmid <> '' AND memopdhid <> '' "& filterAgen &" "& filterKeb &" "& filtertgl &""

  ' untuk data paggination
  page = Request.QueryString("page")

  orderBy = " order by memoTgl DESC"
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

  call header("Permintaan Anggaran")
%>    
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row mt-3 mb-3 text-center">
      <div class="col-lg-12">
          <h3>PERMINTAAN ANGGARAN PEMBELANJAAN PROJECT</h3>
      </div>
  </div>
  <form action="bomproject.asp" method="post">
      <div class="row">
          <div class="col-lg-3 mb-3">
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
          <div class="col-lg-3 mb-3">
              <label for="keb">Kebutuhan</label>
              <select class="form-select" aria-label="Default select example" name="keb" id="keb">
                  <option value="">Pilih</option>
                  <% do while not DepData.eof %>
                  <option value="<%= DepData("DepID") %>"><%= DepData("DepNama") %></option>
                  <% 
                  DepData.movenext
                  loop
                  %>
              </select>
          </div>
          <div class="col-lg-2 mb-3">
              <label for="tgl">Tanggal Pertama</label>
              <input type="date" class="form-control" name="tgla" id="tgla" autocomplete="off" >
          </div>
          <div class="col-lg-2 mb-3">
              <label for="tgl">Tanggal Kedua</label>
              <input type="date" class="form-control" name="tgle" id="tgle" autocomplete="off" >
          </div>
          <div class="col-lg-2 mt-4 mb-3">
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
                  <th scope="col">No Memo</th>
                  <th scope="col">Divisi</th>
                  <th scope="col">Departement</th>
                  <th scope="col">Keterangan</th>
                  <th scope="col">Prosess</th>
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
                  agen_cmd.commandText = "SELECT memoID FROM DLK_T_Memo_D WHERE Left(memoID,17) = '"& rs("memoID") &"'"
                  set ddetail = agen_cmd.execute

                  ' cek pembuatan po 
                  agen_cmd.commandText = "SELECT OPH_MemoID FROM DLK_T_OrPemH WHERE OPH_memoID = '"& rs("memoID") &"'"
                  set orderpo = agen_cmd.execute
                  %>
                  <tr>
                      <th scope="row"><%= recordcounter %></th>
                      <td><%= Cdate(rs("memoTgl")) %></td>
                      <td>
                          <%= left(rs("memoID"),4) %>/<%=mid(rs("memoId"),5,3) %>-<% call getAgen(mid(rs("memoID"),8,3),"") %>/<%= mid(rs("memoID"),11,4) %>/<%= right(rs("memoID"),3) %>
                      </td>
                      <td><%= rs("DivNama") %></td>
                      <td><%= rs("DepNama")%></td>
                      <td><%= rs("memoKeterangan") %></td>
                      <td>
                          <%if not orderpo.eof then %>
                          <b class="text-success">
                              Done
                          </b>
                          <% else %>
                          <b>
                              Waiting
                          </b>
                          <% end if %>
                      </td>
                      <td class="text-center">
                        <div class="btn-group" role="group" aria-label="Basic example">
                            <% if rs("memoApproveYN") = "N" then %>
                                <% if rs("memoInventoryYN") = "N" then%>
                                    <%if session("INV10G") = true then%>
                                        <a href="appanggaraninv.asp?id=<%= rs("memoID") %>" class="btn badge bg-secondary" onclick="ApproveYN(event,'PASTIKAN SEMUA DATA BENAR!!', 'approve memo project', 'info')">Ajukan</a>
                                    <%end if%>
                                    <% if session("INV10B") = true then %>
                                        <a href="bomproject_u.asp?id=<%= rs("memoID") %>" class="btn badge btn-primary btn-sm">Update</a>
                                    <% end if %>
                                    <a href="detailbomproject.asp?id=<%= rs("memoID") %>" class="btn badge text-bg-warning">Detail</a>
                                <%else%>
                                    <div class="loaderSpiner"></div>
                                <%end if%>
                            <%else%>
                                <a href="detailbomproject.asp?id=<%= rs("memoID") %>" class="btn badge text-bg-warning">Detail</a>
                            <% end if %>
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
                      <a class="page-link prev" href="bomproject.asp?offset=<%= requestrecords - recordsonpage%>&page=<%=npage%>&agen=<%=agen%>&keb=<%=keb%>&tgla=<%=tgla%>&tgle=<%=tgle%>">&#x25C4; Prev </a>
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
                          <a class="page-link hal bg-primary text-light" href="bomproject.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&keb=<%=keb%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
                      <%else%>
                          <a class="page-link hal" href="bomproject.asp?offset=<% = pagelist %>&page=<%=pagelistcounter%>&agen=<%=agen%>&keb=<%=keb%>&tgla=<%=tgla%>&tgle=<%=tgle%>"><%= pagelistcounter %></a> 
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
                          <a class="page-link next" href="bomproject.asp?offset=<%= requestrecords + recordsonpage %>&page=<%=page%>&agen=<%=agen%>&keb=<%=keb%>&tgla=<%=tgla%>&tgle=<%=tgle%>">Next &#x25BA;</a>
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