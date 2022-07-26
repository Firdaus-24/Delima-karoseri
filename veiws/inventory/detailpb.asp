<!--#include file="../../init.asp"-->
<% 
    id = trim(Request.QueryString("id"))
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT memoID FROM DLK_T_Memo_H WHERE memoID = '"& id &"' and memoAktifYN = 'Y'"
    set dataH = data_cmd.execute

%>
<% call header("Detail Permintaan Barang") %>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 mb-3 text-center">
            <h3>DETAIL PERMINTAAN BARANG</h3>
        </div>  
    </div> 
    <div class="row">
        <div class="col-lg-12 mb-3">
            <label>
                Nomor :
                <b>
                    <%= left(dataH("memoID"),4) %>/<% call getKebutuhan(mid(dataH("memoId"),5,3),"") %>-<% call getAgen(mid(dataH("memoID"),8,3),"") %>/<%= mid(dataH("memoID"),11,4) %>/<%= right(dataH("memoID"),3) %>
                </b>
            </label>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3">
            <table class="table">
                <thead class="bg-secondary text-light">
                    <tr>
                        <th scope="col">No</th>
                        <th scope="col">Item</th>
                        <th scope="col">Spesification</th>
                        <th scope="col">Quantity</th>
                        <th scope="col">Satuan</th>
                        <th scope="col">Harga</th>
                        <th scope="col">Keterangan</th>
                        <th scope="col">AktifYN</th>
                        <th scope="col">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    data_cmd.commandText = "SELECT * FROM DLK_T_Memo_D WHERE left(MemoID,17) = '"& dataH("MemoID") &"'"
                    ' response.write data_cmd.commandText
                    set dataD = data_cmd.execute

                    no = 0
                    do while not dataD.eof
                    no = no + 1
                    %>
                        <tr>
                            <th scope="row"><%= no %></th>
                            <td><%= dataD("memoItem") %></td>
                            <td><%= dataD("memoSpect") %></td>
                            <td><%= dataD("memoQtty") %></td>
                            <td><% call getSatBerat(dataD("memoSatuan")) %></td>
                            <td><%= replace(formatCurrency(dataD("memoHarga")),"$","") %></td>
                            <td><%= dataD("memoKeterangan") %></td>
                            <td><%= dataD("memoAktifYN") %></td>
                            <td>
                                <div class="btn-group" role="group" aria-label="Basic example">
                                    <a href="#" class="btn badge text-bg-primary">Update</a>
                                    <a href="aktif.asp?id=<%= dataD("memoID") %>" class="btn badge text-bg-danger btn-aktifvendor">delete</a>
                                </div>
                            </td>
                        </tr>
                    <% 
                    dataD.movenext
                    loop
                    %>
                </tbody>
            </table>
        </div>
    </div> 
</div>




<% call footer() %>