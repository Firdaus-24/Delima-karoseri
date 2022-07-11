<!--#include file="../../init.asp"-->
<% 
    set data =  Server.CreateObject ("ADODB.Command")
    data.ActiveConnection =  mm_delima_string

    data.commandText = "SELECT * FROM DLK_M_KodeBarang WHERE Kode_AktifYN = 'Y'"
    set kdbarang = data.execute

    call header("kode barang")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3 mb-3 text-center">
        <div class="col-lg">
            <h3>MASTER KODE BARANG</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg">
            <a href="tambah.asp"><button type="button" class="btn btn-primary">Tambah</button></a>
        </div>
    </div>
    <div class="row mt-3">
        <div class="col-lg-12">
            <table class="table">
                <thead class="bg-secondary text-light">
                    <tr>
                    <th scope="col">No</th>
                    <th scope="col">Kode</th>
                    <th scope="col">Keterangan</th>
                    <th scope="col">Aktif</th>
                    <th scope="col" class="text-center">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    no = 0
                    do while not kdbarang.eof
                    no = no + 1
                    %>
                    <tr>
                        <th scope="row"><%= no %> </th>
                        <td><%= kdbarang("kode_nama") %> </td>
                        <td><%= kdbarang("kode_Keterangan") %> </td>
                        <td>
                            <%if kdbarang("kode_AktifYN") = "Y" then %>Aktif <% else %>Off <% end if %> 
                        </td>
                        <td class="text-center">
                            <a href="update.asp?id=<%= kdbarang("Kode_ID") %>" class="btn badge text-bg-primary">update</a>
                            <a href="aktif.asp?id=<%= kdbarang("Kode_ID") %>" class="btn badge text-bg-danger">delete</a>
                        </td>
                    </tr>
                    <% 
                    kdbarang.movenext
                    loop
                    %>
                </tbody>
            </table>
        </div>
    </div>

</div>
<% call footer() %>