<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_permintaanb.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT * FROM DLK_T_Memo_H WHERE memoID = '"& id &"' and memoAktifYN = 'Y'"
    ' response.write data_cmd.commandText
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
    <div class="row mb-3">
        <div class="col-sm-6">
            <div class="row g-3 align-items-center">
                <div class="col-auto">
                    <label class="col-form-label">Nomor :</label>
                </div>
                <div class="col-auto">
                    <label>
                        <b>
                            <%= left(dataH("memoID"),4) %>/<% call getKebutuhan(mid(dataH("memoId"),5,3),"") %>-<% call getAgen(mid(dataH("memoID"),8,3),"") %>/<%= mid(dataH("memoID"),11,4) %>/<%= right(dataH("memoID"),3) %>
                        </b>
                    </label>
                </div>
            </div>
        </div>
        <div class="col-sm-6">
            <div class="row g-3 align-items-center">
                <div class="col-auto">
                    <label class="col-form-label">Cabang :</label>
                </div>
                <div class="col-auto">
                    <% call getAgen(dataH("memoAgenID"),"p") %>
                </div>
            </div>
        </div>
        <div class="col-sm-6">
            <div class="row g-3 align-items-center">
                <div class="col-auto">
                    <label class="col-form-label">Hari :</label>
                </div>
                <div class="col-auto">
                    <label><% call getHari(weekday(dataH("memoTgl"))) %></label>
                </div>
            </div>
        </div>
        <div class="col-sm-6">
            <div class="row g-3 align-items-center">
                <div class="col-auto">
                    <label class="col-form-label">Kebutuhan :</label>
                </div>
                <div class="col-auto">
                    <label><% call getKebutuhan(dataH("memoKebID"),"P") %></label>
                </div>
            </div>
        </div>
        <div class="col-sm-6">
            <div class="row g-3 align-items-center">
                <div class="col-auto">
                    <label class="col-form-label">Tanggal :</label>
                </div>
                <div class="col-auto">
                    <label><%= Cdate(dataH("memoTgl")) %></label>
                </div>
            </div>
        </div>
        <div class="col-sm-6">
            <div class="row g-3 align-items-center">
                <div class="col-auto">
                    <label class="col-form-label">Divisi :</label>
                </div>
                <div class="col-auto">
                    <label><% call getDivisi(dataH("memoDivID")) %></label>
                </div>
            </div>
        </div>
        <div class="col-sm-6">
            <div class="row g-3 align-items-center">
                <div class="col-auto">
                    <label class="col-form-label">Keterangan :</label>
                </div>
                <div class="col-auto">
                    <label><%= dataH("memoKeterangan") %></label>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="d-flex mb-3">
            <div class="me-auto p-2">
                <button type="button" class="btn btn-secondary" onClick="window.open('export-detailpb.asp?id=<%=id%>')" class="btn btn-danger">Export</button>
            </div>
            <div class="p-2">
                <a href="index.asp" class="btn btn-danger">Kembali</a>
            </div>
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
                        <th scope="col" class="text-center">Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    data_cmd.commandText = "SELECT DLK_T_Memo_D.*, DLK_M_Barang.Brg_Nama FROM DLK_T_Memo_D LEFT OUTER JOIN DLK_M_Barang ON DLK_T_Memo_D.MemoItem = DLK_M_Barang.Brg_ID WHERE left(MemoID,17) = '"& dataH("MemoID") &"' ORDER BY memoItem ASC"
                    ' response.write data_cmd.commandText
                    set dataD = data_cmd.execute

                    no = 0
                    do while not dataD.eof
                    no = no + 1
                    %>
                        <tr>
                            <th scope="row"><%= no %></th>
                            <td><%= dataD("Brg_Nama") %></td>
                            <td><%= dataD("memoSpect") %></td>
                            <td><%= dataD("memoQtty") %></td>
                            <td><% call getSatBerat(dataD("memoSatuan")) %></td>
                            <td><%= replace(formatCurrency(dataD("memoHarga")),"$","") %></td>
                            <td>
                                <%if dataD("memoKeterangan") <> "null" then%>
                                    <%= dataD("memoKeterangan") %>
                                <% end if %>
                            </td>
                            <td  class="text-center">
                                <% if dataH("memoApproveYN") = "Y" then %>
                                    <b style="color:green">Done</b>
                                <% else %>
                                    -
                                <% end if %>
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
<% 
    call footer()
%>