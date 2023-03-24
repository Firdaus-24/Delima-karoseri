<!--#include file="../../init.asp"-->
<% 
  if session("MQ2A") = false OR session("MQ2B") = false then
    Response.Redirect("index.asp")
  end if

  call header("Tools Unit")
  id = trim(Request.QueryString("id"))

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string

  data_cmd.commandText = "SELECT * FROM DLK_T_UnitCustomerD1 WHERE TFK_ID = '"& id &"'" 
  set data = data_cmd.execute

  ' get data tools unit
  data_cmd.commandText = "SELECT * FROM DLK_M_ItemKendaraan WHERE FK_AktifYN = 'Y'"

  set ditem = data_cmd.execute


%>
<!--#include file="../../navbar.asp"-->
<div class="container">

<%   if not data.eof then %>
<div class="modal" id="setTols" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="setTolsLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="setTolsLabel">Modal Pelengkap Unit</h1>
      </div>
      <div class="modal-body">
        <div class="row">
          <div class="col-sm mb-0 text-danger">
            <p>Pastikan isi keterangan dahulu sebelum aksi ceklis data!!</p>
          </div>
        </div>
        <div class="row">
          <div class="col-sm-12">
            <table class="table">
              <thead class="bg-secondary text-light">
                <tr>
                  <th scope="col">No</th>
                  <th scope="col">Nama</th>
                  <th scope="col">Keterangan</th>
                  <th scope="col">Pilih</th>
                </tr>
              </thead>
              <tbody>
                <%
                no = 0 
                do while not ditem.eof
                no = no + 1

                ' get detail D2
                data_cmd.commandText = "SELECT * FROM DLK_T_UnitCustomerD2 WHERE TFK_ID = '"& id &"' AND TFK_FKID = '"& ditem("FK_ID") &"'"
                set ddata2 = data_cmd.execute
                 %>
                <tr>
                  <th scope="row"><%= no %></th>
                  <td><%= ditem("FK_Nama") %></td>
                  <td>
                    <input class="form-control" type="text" maxlength="30" id="cktoolKeterangan<%=no%>"  <% if not ddata2.eof then %> value="<%= ddata2("TFK_Keterangan") %>" <% end if %> style="border:none;border-bottom:1px solid black;">
                  </td>
                  <td>
                    <input class="form-check-input" type="checkbox" id="cktoolsUnit<%=no%>" onchange="getCkUnit('<%=id%>','<%= ditem("FK_Id") %>','<%=no%>')" <% if not ddata2.eof then %>checked <% end if %>>
                  </td>
                </tr>
                <% 
                response.flush
                ditem.movenext
                loop
                %>
              </tbody>
            </table>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" onclick="window.location.href = 'tfkd_add.asp?id=<%= left(id,17) %>'">Save</button>
      </div>
    </div>
  </div>
</div>
</div>
<%
  else
    call alert("ERORR!!!", "Data tidak terdaftar", "warning","index.asp")
  end if
 call footer() %>
<script>
  $(window).on('load', function() {
    $('#setTols').modal('show');
  });

  const getCkUnit = (id1,id2,no) =>{
    let keterangan = $(`#cktoolKeterangan${no}`).val()
    $.post("getTools.asp",{id1,id2,keterangan}, function(data){
    })

  }
</script>