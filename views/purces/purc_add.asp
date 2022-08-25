<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_purce.asp"-->
<% 
    id = trim(Request.QueryString("id"))
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string


    data_cmd.commandText = "SELECT dbo.DLK_T_AppPermintaan.AppID, dbo.DLK_T_AppPermintaan.Appdana, dbo.DLK_T_Memo_D.memoID, dbo.DLK_T_Memo_D.memoItem, dbo.DLK_T_Memo_D.memoSpect, dbo.DLK_T_Memo_D.memoQtty, dbo.DLK_T_Memo_D.memoSatuan, dbo.DLK_T_Memo_D.memoHarga,dbo.DLK_T_Memo_D.memoKeterangan, DLK_M_Barang.Brg_Nama FROM DLK_T_Memo_D LEFT OUTER JOIN dbo.DLK_T_AppPermintaan ON left(dbo.DLK_T_Memo_D.memoID,17) = dbo.DLK_T_AppPermintaan.AppMemoID LEFT OUTER JOIN DLK_M_Barang ON DLK_T_Memo_D.Memoitem = DLK_M_Barang.Brg_ID WHERE dbo.DLK_T_AppPermintaan.AppmemoID = '"& id &"' AND DLK_T_Memo_D.memoAktifYN = 'Y'"
    ' response.write data_cmd.commandText & "<br>"
    set data = data_cmd.execute

    ' vendor
    data_cmd.commandText = "SELECT ven_Nama, Ven_ID FROM DLK_M_Vendor WHERE Ven_AktifYN = 'Y' ORDER BY ven_Nama ASC"
    set vendor = data_cmd.execute

    call header("Prosess Purchase")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>FORM TAMBAH PURCHES ORDER</h3>
        </div>
    </div>
    <form action="purc_add.asp?id=<%= id %>" method="post" id="formpur">
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="memoId" class="col-form-label">No Memo</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="memoId" name="memoId" class="form-control" value="<%= id %>" readonly>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="nfinance" class="col-form-label">No Finance</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="nfinance" name="nfinance" class="form-control" value="<%= data("AppID") %>" readonly>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="agen" class="col-form-label">Cabang / Agen</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="agen" name="agen" required>
                    <option value="<%= mid(data("memoID"),8,3) %>" selected ><% call getAgen(mid(data("memoID"),8,3),"P") %></option>
                </select>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="tgl" class="col-form-label">Tanggal</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="date" id="tgl" name="tgl" class="form-control" required>
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="vendor" class="col-form-label">Vendor</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="vendor" name="vendor" required>
                    <option value="">Pilih</option>
                    <% do while not vendor.eof %>
                    <option value="<%= vendor("ven_ID") %>"><%= vendor("ven_Nama") %></option>
                    <% 
                    vendor.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="tgljt" class="col-form-label">Tanggal Jatuh Tempo</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="date" id="tgljt" name="tgljt" class="form-control">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="metpem" class="col-form-label">Metode Pembayaran</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="metpem" name="metpem" required>
                    <option value="">Pilih</option>
                    <option value="1">Transfer</option>
                    <option value="2">Cash</option>
                    <option value="3">PayLater</option>
                </select>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="diskon" class="col-form-label">Diskon All</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="number" id="diskon" name="diskon" class="form-control">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="ppn" class="col-form-label">PPn</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="number" id="ppn" name="ppn" class="form-control">
            </div>
            <div class="col-lg-2 mb-3">
                <label for="dana_tpo" class="col-form-label">Acc Dana</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="dana_tpo" name="dana_tpo" class="form-control" value="<%= replace(formatCurrency(data("appDana")),"$","") %>" readonly> 
            </div>
        </div>
         <div class="row">
            <div class="col-lg-2 mb-3">
                <label for="keterangan" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-lg-10 mb-3">
                <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" autocomplete="off">
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12 mb-3 mt-3">
                <table class="table table-hover">
                    <thead class="bg-secondary text-light" style="white-space: nowrap;">
                        <tr>
                            <th>Pilih</th>
                            <th>Item</th>
                            <th>Quantty</th>
                            <th>Harga</th>
                            <th>Satuan Barang</th>
                            <th>Disc1</th>
                            <th>Disc2</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% do while not data.eof %>
                        <tr>
                            <td class="text-center">
                                <input class="form-check-input ckpo" type="checkbox" value="" id="ckpo">
                            </td>
                            <td>
                                <select class="form-control" aria-label="Default select example" id="item" name="item" >
                                    <option value="<%= data("memoItem") %>"><%= data("Brg_Nama")%></option>
                                    
                                </select>
                            </td>
                            <td>
                                <input type="text" id="qtty" name="qtty" class="form-control " value="<%= data("memoQtty") %>">
                            </td>
                            <td>
                                <input type="text" id="hargapo" name="harga" class="form-control " value="<%= data("memoharga") %>">
                            </td>
                            <td>
                                <select class="form-control" aria-label="Default select example" id="satuan" name="satuan" >
                                    <option value="<%= data("memosatuan") %>"><% call getSatBerat(data("memosatuan")) %></option>
                                    
                                </select>
                            </td>
                            <td>
                                <input type="number" id="disc1" name="disc1" class="form-control " required>
                            </td>
                            <td>
                                <input type="number" id="disc2" name="disc2" class="form-control" required>
                            </td>
                        </tr>
                        <% 
                        data.movenext
                        loop
                        %>
                    </tbody>
                </table>
            </div>
        </div>
        <!-- value get data -->
        <div class="value" style="display:none;">
            <div class="row">
                <div class="col-lg-12">
                    <input type="text" id="valitem" name="valitem" class="form-control">
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <input type="text" id="valqtty" name="valqtty" class="form-control">
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <input type="text" id="valharga" name="valharga" class="form-control">
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <input type="text" id="valsatuan" name="valsatuan" class="form-control">
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <input type="text" id="valdisc1" name="valdisc1" class="form-control">
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <input type="text" id="valdisc2" name="valdisc2" class="form-control">
                </div>
            </div>
            <!-- 
            <div class="row">
                <div class="col-lg-12">
                    <input type="text" id="thargapo" name="thargapo" class="form-control">
                </div>
            </div>
             -->
        </div>
        <!-- end getdata -->
        <div class="row">
            <div class="col-lg-12 text-center">
                <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
                <button type="submit" class="btn btn-primary">Save</button>
            </div>
        </div>
    </form>
</div>  


<% 
    if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
        call tambahPurce()
        if value = 1 then
            call alert("PURCHES ORDER", "berhasil di tambahkan", "success","index.asp") 
        elseif value = 2 then
            call alert("PURCHES ORDER", "sudah terdaftar", "warning","index.asp")
        else
            value = 0
        end if
    end if
    call footer()
%>