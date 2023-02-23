<!-- #include file='../../init.asp' -->
<% 
  if session("HR7") = false then  
    Response.Redirect("../index.asp")
  end if

  set conn = Server.CreateObject("ADODB.Connection")
  conn.open MM_delima_string

  dim recordsonpage, requestrecords, allrecords, hiddenrecords, showrecords, lastrecord, recordconter, pagelist, pagelistcounter, sqlawal
  dim angka
  dim code, nama, aktifId, UpdateId, uTIme, orderBy

  ' untuk angka
  angka = request.QueryString("angka")
  page = request.QueryString("page")
  if len(angka) = 0 then 
    angka = Request.form("urut") + 1
  end if

  ' untuk data
  code = Request.QueryString("code")
  if len(code) = 0 then
    code = Request.form("code")
  end if

  nama = Request.QueryString("nama")
  if len(nama) = 0 then 
    nama = Request.form("nama")
  end if

  if nama <> "" then
    filterNama = "WHERE UPPER(JJ_Nama) LIKE '%"& nama &"%'"
  else
    filterNama = ""
  end if

  orderBy = " order by JJ_ID, JJ_Nama, JJ_AktifYN, JJ_UpdateID, JJ_UpdateTime"

  set rs = Server.CreateObject("ADODB.Recordset")

  sqlawal = "SELECT HRD_M_Jenjang.*, DLK_M_webLogin.username FROM HRD_M_Jenjang LEFT OUTER JOIN DLK_M_Weblogin ON HRD_M_Jenjang.JJ_UpdateID = DLK_M_webLogin.userid "& filterNama &""

  sql=sqlawal + orderBy

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

  sqlawal = "SELECT HRD_M_Jenjang.*, DLK_M_webLogin.username from HRD_M_Jenjang LEFT OUTER JOIN DLK_M_Weblogin ON HRD_M_Jenjang.JJ_UpdateID = DLK_M_webLogin.userid "& filterNama &""
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

  call header("Jenjang")

%> 

<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-md-12 mt-3 mb-3">   
      <h3 class="text-uppercase text-center">  JENJANG </h3>
    </div>
  </div>
  <div class="row">
    <div class="col">
      <%if session("HR7A") = true then%>
        <button type="button" class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#formModalJenjang" onclick="return tambahJenjang()">
          Tambah
        </button>
      <%end if%>
    </div>
  </div>
  <form action="index.asp" method="post">
  <div class="row">
    <div class="col-sm-6">
      <div class="input-group mb-3">
        <input type="text" class="form-control" name="nama" id="nama" placeholder="Cari Berdasarkan Nama...." autocomplate="off">
      </div>
    </div>
    <div class="col-sm-2">
      <button type="submit" class="btn btn-primary">
        Cari
      </button>
    </div>
  </div>
  </form>
  <div class="row">
    <div class="col-md-12 tableJenjang">
      <table class="table table-striped"> 
        <input name="urut" id="urut"  type="hidden" value="<%response.write angka%>" size="1" hidden="">
        <thead class="bg-secondary text-light">
          <tr>
            <th class="text-center" scope="col">ID</th>
            <th class="text-center" scope="col">Nama</th>
            <th class="text-center" scope="col">Aktif ID</th>
            <th class="text-center" scope="col">Update ID</th>
            <th class="text-center" scope="col">Terakhir Update</th>
            <th class="text-center" scope="col">Aksi</th>
          </tr>
        </thead>
        <tbody>
        <%
				  showrecords = recordsonpage
					recordcounter = requestrecords
					do until showrecords = 0 OR  rs.EOF
					recordcounter = recordcounter + 1
				%>
          <tr class="text-center"> 
            <td><%= rs("JJ_ID") %> </td>
            <td><%= rs("JJ_Nama") %> </td>
            <td><%= rs("JJ_AktifYN") %> </td>
            <td><%= rs("username") %> </td>
            <td><%= rs("JJ_UpdateTime") %> </td>
            <td> 
              <div class="btn-group" role="group" aria-label="Basic mixed styles example" id="buttonjenjang">
                <%if session("HR7B") = true then%>
                  <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#formModalJenjang" onclick="return ubahJenjang('<%= rs("JJ_ID") %>','<%= rs("JJ_Nama") %>')" >UPDATE</button>
                <%end if%>
                <%if session("HR7C") = true then%>
                  <% if rs("JJ_AktifYN") = "Y" then %>
                    <button type="button" class="btn btn-danger btn-sm" onclick="return jjAktif('<%= rs("JJ_ID") %>','N')">NO</button>
                  <% else %>  
                    <button type="button" class="btn btn-warning btn-sm" onclick="return jjAktif('<%= rs("JJ_ID") %>','Y')">YES</button>
                  <% end if %>      
                <%end if%>
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
    <div class="col-md-12">
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
              if requestrecords <> 0 then %>
                <a class="page-link" href="index.asp?offset=<%= requestrecords - recordsonpage%>&angka=<%=angka%>&page=<%=npage%>&nama=<%= nama %>">&#x25C4; Prev </a>
              <% else %>
                <p class="page-link-p">&#x25C4; Prev </p>
              <% end if %>
            </li>
						<li class="page-item d-flex" style="overflow-y:auto;">	
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
                <a class="page-link hal d-flex bg-primary text-light" href="index.asp?offset=<% = pagelist %>&angka=<%=angka%>&page=<%=pagelistcounter%>&nama=<%= nama %>"><%= pagelistcounter %></a> 
                <%else%>
                <a class="page-link hal d-flex" href="index.asp?offset=<% = pagelist %>&angka=<%=angka%>&page=<%=pagelistcounter%>&nama=<%= nama %>"><%= pagelistcounter %></a> 
                <%end if%>
              <%
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
                <a class="page-link next" href="index.asp?offset=<%= requestrecords + recordsonpage %>&angka=<%=angka%>&page=<%=page%>&nama=<%= nama %>">Next &#x25BA;</a>
              <% else %>
                <p class="page-link next-p">Next &#x25BA;</p>
              <% end if %>
						</li>	
					</ul>
				</nav>
    </div>
  </div>
</div>
    
<!-- tampil modal -->
<div class="modal fade" id="formModalJenjang" tabindex="-1" aria-labelledby="formModalJenjangLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="formModalJenjangLabel">Update Data</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form method="post" action="tambah.asp">
        <input type="hidden" name="code" id="code">
            <div class="mb-3">
                <label for="nama" class="form-label">Nama</label>
                <input type="text" class="form-control" name="nama" id="nama" maxlength="30" autofocus="on" autocomplate="off" required>
            </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary" name="submit" id="submit" >Update Data</button>
      </form>
      </div>
    </div>
  </div>
</div>
<script>
  function tambahJenjang() {
    $('#formModalJenjangLabel').html('TAMBAH DATA');
    $('.modal-footer button[type=submit]').html('Save');
    $('.modal-body form').attr('action', 'tambah.asp');
    // $('#labelID').hide();
    $('#code').attr('readonly', false);
    $('#code').val('');
    $('#nama').val('');
  }
  function ubahJenjang(id, data) {
    $('#ModallabelJabatan').html('UPDATE DATA');
    $('.modal-footer button[type=submit]').html('UPDATE');
    $('.modal-body form').attr('action', 'update.asp');
    // $('#labelID').hide();
    $('#code').attr('readonly', true);
    $('#code').val(id);
    $('#nama').val(data);
  }
  function jjAktif(id,aktif){
    let str
    if (aktif == 'Y'){
      str = 'HAPUS'
    }else{
      str = 'AKTIFKAN'
    }
    swal({
      title: `YAKIN UNTUK DI ${str}??`,
      text: "MASTER JENJANG",
      icon: "warning",
      buttons: [
          'No',
          'Yes'
      ],
      dangerMode: true,
    }).then(function(isConfirm) {
      if (isConfirm) {
        window.location.href = (`aktif.asp?id=${id}&aktif=${aktif}`) // <--- submit form programmatically
      } else {
        swal("Request gagal di kirim");
      }
    })  
  
  }
</script>
<% call footer() %>