<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_purce.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string
    
    ' get data
    data_cmd.commandText = "SELECT dbo.DLK_T_InvPemH.*, GLB_M_Agen.AgenName, DLK_M_Vendor.Ven_Nama FROM dbo.DLK_T_InvPemH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_InvPemH.IPH_AgenID = GLB_M_Agen.AgenID LEFT OUTER JOIN DLK_M_vendor ON DLK_T_InvPemH.IPH_venid = DLK_M_vendor.ven_ID where DLK_T_InvPemH.IPH_ID = '"& id &"' AND DLK_T_InvPemH.IPH_AktifYN = 'Y'"
    set data = data_cmd.execute

    call header("Update Invoices Reserve")
%>
<style>
    .tableufaktur .form-control{
        padding-top:0;
        padding-bottom:0;
        border:none;
        background:transparent;
    }
    .tableufaktur .form-control:focus{
        outline: none !important;
        border:none;
    }
</style>
<!--#include file="../../navbar.asp"--> 
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 text-center">
            <h3>UPDATE INVOICES RESERVE</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mb-3 text-center labelId">
            <h3><%= data("IPH_ID") %></h3>
        </div>
    </div>
    <form action="inv_u.asp?id=<%= id %>" method="post" id="UpdateInvoice" onsubmit="validasiForm(this,event,'INVOICES RESERVE','warning')">
        <input type="hidden" name="iphid" id="iphid" value="<%= data("IPH_ID") %>" readonly>
        <div class="row">
            <div class="col-lg-2 mb-3">
                <label for="ophid" class="col-form-label">P.O ID</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="ophid" name="ophid" class="form-control" value="<%= left(data("IPH_OPHID"),2) %>-<% call getAgen(mid(data("IPH_OPHID"),3,3),"") %>/<%= mid(data("IPH_OPHID"),6,4) %>/<%= right(data("IPH_OPHID"),4) %>" readonly>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="agen" class="col-form-label">Cabang / Agen</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="hidden" class="form-control" name="agen" id="agen" value="<%= data("IPH_AgenID") %>" readonly>
                <input type="text" class="form-control" name="lagen" id="lagen" value="<%= data("AgenName") %>" readonly>
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="tgl" class="col-form-label">Tanggal</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="tgl" name="tgl" class="form-control" value="<%= Cdate(data("IPH_Date")) %>" readonly>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="tgljt" class="col-form-label">Tanggal Jatuh Tempo</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="tgljt" name="tgljt" class="form-control" <% if data("IPH_JTDAte") <> "1900-01-01"  then%> value="<%= Cdate(data("IPH_JTDate")) %>" <% end if %> onfocus="(this.type='date')">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="vendor" class="col-form-label">Vendor</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="vendor" name="vendor" disabled>
                    <option value="<%= data("IPH_venid") %>" ><%= data("ven_Nama") %></option>
                </select>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="diskon" class="col-form-label">Diskon All</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="number" id="diskon" name="diskon" class="form-control" value="<%= data("IPH_Diskonall") %>" readonly>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-2 mb-3">
                <label for="keterangan" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" value="<%= data("IPH_Keterangan") %>">
            </div>
            <div class="col-lg-2 mb-3">
                <label for="ppn" class="col-form-label">PPn</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="number" id="ppn" name="ppn" class="form-control" value="<%= data("IPH_ppn") %>" readonly>
            </div>
        </div>
        <!-- detail barang -->
        <div class="row">
            <div class="col-lg-12 mb-3 mt-3">
                <table class="table table-hover tableufaktur">
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
                        <%
                        data_cmd.commandTExt = "SELECT DLK_T_InvPemD.*, DLK_M_Barang.Brg_Nama, DLK_M_Barang.Brg_ID, DLK_M_Rak.Rak_Nama, DLK_M_SatuanBarang.Sat_Nama FROM DLK_T_InvPemD LEFT OUTER JOIN DLK_M_Barang ON DLK_T_InvPemD.IPD_Item = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_Rak ON DLK_T_InvPemD.IPD_RakID = DLK_M_Rak.Rak_ID LEFT OUTER JOIN DLK_M_SatuanBarang ON DLK_T_InvPemD.IPD_JenisSat = DLK_M_SatuanBarang.Sat_ID WHERE LEFT(IPD_IPHID,13) = '"& data("IPH_ID") &"'ORDER BY DLK_M_Barang.Brg_Nama ASC "

                        set ddata = data_cmd.execute
                        do while not ddata.eof %>
                        <tr>
                            <th>
                                <!-- 
                                <input class="form-check-input ckinv" type="checkbox" value="" id="ckinv">
                                 -->
                                <input class="form-control" type="hidden" name="ipdiphid" id="ipdiphid" value="<%= ddata("IPD_IPHID") %>">
                                <%= ddata("IPD_IPHID") %>
                            </th>
                            <td>
                                <%= ddata("Brg_Nama")%>
                            </td>
                            <td>
                                <%= ddata("IPD_QtySatuan") %>
                            </td>
                            <td>
                                <input type="text" id="harga" name="harga" class="form-control " value="<%= ddata("IPD_Harga") %>" autocomplete="off">
                            </td>
                            <td>
                                <%= ddata("Sat_Nama") %>
                            </td>
                            <td>
                                <input type="number" id="disc1" name="disc1" class="form-control " value="<%= ddata("IPD_Disc1") %>" required>
                            </td>
                            <td>
                                <input type="number" id="disc2" name="disc2" class="form-control" value="<%= ddata("IPD_Disc2") %>" required>
                            </td>
                        </tr>
                        <% 
                        ddata.movenext
                        loop
                        %>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12 text-center">
                <a href="invoReserve.asp" type="button" class="btn btn-danger">Kembali</a>
                <button type="submit" class="btn btn-primary">Save</button>
            </div>
        </div>
    </form>
</div>  
<% 
    if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
        call updateInvoice()
    end if

    call footer()
%>