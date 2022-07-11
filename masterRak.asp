<!--#include file="Connections/cargo.asp"-->
<!--#include file="functions/func_template.asp"-->
<% 
    set data =  Server.CreateObject ("ADODB.Command")
    data.ActiveConnection = mm_Delima_string

    data.CommandText = "SELECT * FROM DLK_M_Rak"
    set rak = data.execute

    call header("Master Rak") 

%>
<!--#include file="navbar.asp"-->
<div class="container">
    <div class="row mt-3">
        <div class="col-lg-12 text-center">
            <h3>MASTER RAK</h3>
        </div>
    </div>
    <div class="row mt-3 mb-3">
        <div class="col-lg-2">
            <button type="button" class="btn btn-primary">Tambah</button>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <table class="table">
                <thead class="bg-secondary text-light">
                    <tr>
                    <th scope="col">No</th>
                    <th scope="col">Rak ID</th>
                    <th scope="col">Nama</th>
                    <th scope="col">Aktif</th>
                    <th scope="col">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    no = 0
                    do while not rak.eof 
                    no = no + 1
                    %>
                    <tr>
                        <th scope="row"><%= no %> </th>
                        <td><%= rak("Rak_ID") %> </td>
                        <td><%= rak("Rak_Nama") %></td>
                        <td><%= rak("Rak_AktifYN") %></td>
                        <td><button type="button" class="btn btn-primary btn-sm">update</button></td>
                    </tr>
                    <% 
                    rak.movenext
                    loop
                     %>
                </tbody>
            </table>
        </div>
    </div>

</div>
<% call footer() %>