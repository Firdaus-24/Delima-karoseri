<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_jbarang.asp"-->
<!--#include file="../../functions/func_metpem.asp"-->
<% 
    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string
    
    ' get data
    data_cmd.commandText = "SELECT dbo.DLK_T_OrJulH.OJH_ID, dbo.DLK_T_OrJulH.OJH_AgenID, dbo.DLK_T_OrJulH.OJH_Date, dbo.DLK_T_OrJulH.OJH_custID, dbo.DLK_T_OrJulH.OJH_JTDate, dbo.DLK_T_OrJulH.OJH_Keterangan,dbo.DLK_T_OrJulH.OJH_DiskonAll, dbo.DLK_T_OrJulH.OJH_PPn, dbo.DLK_T_OrJulH.OJH_AktifYN, dbo.DLK_T_OrJulH.OJH_MetPem, dbo.DLK_T_OrJulD.OJD_OJHID,dbo.DLK_T_OrJulD.OJD_Item, dbo.DLK_T_OrJulD.OJD_QtySatuan, dbo.DLK_T_OrJulD.OJD_Disc1, dbo.DLK_T_OrJulD.OJD_JenisSat, dbo.DLK_T_OrJulD.OJD_Harga, dbo.DLK_T_OrJulD.OJD_Disc2, DLK_M_Barang.Brg_Nama, DLK_M_Customer.custNama FROM dbo.DLK_T_OrJulH LEFT OUTER JOIN dbo.DLK_T_OrJulD ON dbo.DLK_T_OrJulH.OJH_ID = LEFT(dbo.DLK_T_OrJulD.OJD_OJHID,13) LEFT OUTER JOIN DLK_M_Barang ON DLK_T_OrJulD.OJD_Item = DLK_M_Barang.Brg_ID LEFT OUTER JOIN DLK_M_Customer ON DLK_T_OrJulH.OJH_CustID = DLK_M_Customer.custID where DLK_T_OrJulH.OJH_ID = '"& id &"' AND DLK_T_OrJulH.OJH_AktifYN = 'Y'"

    set data = data_cmd.execute

    ' customer
    data_cmd.commandText = "SELECT custNama, custID FROM DLK_M_customer WHERE custAktifYN = 'Y' ORDER BY custNama ASC"
    set customer = data_cmd.execute

    call header("Faktur Hutang")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>FORM TAMBAH FAKTUR PENJUALAN</h3>
        </div>
    </div>
    <form action="jbarang_add.asp?id=<%= id %>" method="post" id="formPenjualanH">
        <div class="row">
            <div class="col-lg-2 mb-3">
                <label for="ojhid" class="col-form-label">P.O ID</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="ojhid" name="ojhid" class="form-control" value="<%= data("OJH_ID") %>" readonly>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="agen" class="col-form-label">Cabang / Agen</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="hidden" class="form-control" name="agen" id="agen" value="<%= data("OJH_AgenID") %>" readonly>
                <input type="text" class="form-control" name="lagen" id="lagen" value="<% call getAgen(data("OJH_AgenID"),"p") %>" readonly>
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="tgl" class="col-form-label">Tanggal</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="tgl" name="tgl" class="form-control" value="<%= date() %>" onfocus="(this.type='date')" required>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="tgljt" class="col-form-label">Tanggal Jatuh Tempo</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="tgljt" name="tgljt" class="form-control" <% if data("OJH_JTDAte") <> "1900-01-01"  then%> value="<%= data("OJH_JTDate") %>" <% end if %> onfocus="(this.type='date')">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="customer" class="col-form-label">customer</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="customer" name="customer" required>
                    <option value="<%= data("OJH_custid") %>"><%= data("custNama") %></option>
                    <% do while not customer.eof %>
                    <option value="<%= customer("custID") %>"><%= customer("custNama") %></option>
                    <% 
                    customer.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="ppn" class="col-form-label">PPn</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="number" id="ppn" name="ppn" class="form-control" value="<%= data("OJH_ppn") %>">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="metpem" class="col-form-label">Metode Pembayaran</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="metpem" name="metpem" required>
                    <option value="<%= data("OJH_MetPem") %>"><% call getmetpem(data("OJH_MetPem")) %></option>
                    <option value="1">Transfer</option>
                    <option value="2">Cash</option>
                    <option value="3">PayLater</option>
                </select>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="diskon" class="col-form-label">Diskon All</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="number" id="diskon" name="diskon" class="form-control" value="<%= data("OJH_Diskonall") %>">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="keterangan" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" value="<%= data("OJH_Keterangan") %>" autocomplete="off">
            </div>
            <div class="col-lg-2 mb-3">
                <label for="typejual" class="col-form-label">Type Pejualan</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="typejual" name="typejual" required>
                    <option value="">Pilih</option>
                    <option value="1">Harian</option>
                    <option value="2">Bulanan</option>
                    <option value="3">Tahunan</option>
                </select>
            </div>
        </div>
        
        
        <div class="row">
            <div class="col-lg-12 text-center">
                <a href="jbarang.asp" type="button" class="btn btn-danger">Kembali</a>
                <button type="submit" class="btn btn-primary">Save</button>
            </div>
        </div>
    </form>
</div>  


<% 
    if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
        call tambahPenjualan()
    end if
    call footer()
%>