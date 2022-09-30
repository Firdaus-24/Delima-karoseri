<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_produksi.asp"-->
<% 
    set data =  Server.CreateObject ("ADODB.Command")
    data.ActiveConnection = mm_delima_string

    ' get agen / cabang
    data.commandText = "SELECT AgenName, AgenID FROM GLB_M_Agen WHERE agenAktifYN = 'Y' ORDER BY AgenName ASC"
    set pcabang = data.execute    

    ' get kode akun
    data.commandText = "SELECT cat_id, cat_Name FROM GL_M_CategoryItem WHERE Cat_AktifYN = 'Y' ORDER BY Cat_Name ASC"
    set kodeakun = data.execute    

    call header("From Produksi") 
%>

<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>FORM TAMBAH PRODUKSI</h3>
        </div>
    </div>
    <form action="product_add.asp" method="post" id="formProdukH" onsubmit="validasiForm(this,event,'Master Produksi','warning')">
    <div class="row">
        <div class="col-sm-2">
            <label for="tgl" class="col-form-label">Tanggal</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="text" id="tgl" class="form-control" name="tgl" value="<%= Date() %>" onfocus="(this.type='date')" required>
        </div>
        <div class="col-sm-2">
            <label for="cabang" class="col-form-label">Cabang</label>
        </div>
        <div class="col-sm-4 mb-3">
            <select class="form-select" aria-label="Default select example" name="cabang" id="produkcabang" required> 
                <option value="">Pilih</option>
                <% do while not pcabang.eof %>
                <option value="<%= pcabang("agenID") %>"><%= pcabang("AgenName") %></option>
                <%  
                pcabang.movenext
                loop
                %>
            </select>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-2">
            <label for="produkbrg" class="col-form-label">Barang</label>
        </div>
        <div class="col-sm-4 mb-3 produkbrg">
            <select class="form-select" aria-label="Default select example" name="produkbrg" id="produkbrg" required> 
                <option value="" readonly disabled>Pilih cabang dahulu</option>
            </select>
        </div>
        <div class="col-sm-2">
            <label for="kdakun" class="col-form-label">Kode Akun</label>
        </div>
        <div class="col-sm-4 mb-3">
            <select class="form-select" aria-label="Default select example" name="kdakun" id="kdakun" required> 
                <option value="">Pilih</option>
            <% do while not kodeakun.eof %> 
                <option value="<%= kodeakun("cat_ID") %>"><%= kodeakun("cat_Name") %></option>
            <% 
            kodeakun.movenext
            loop
            %>
            </select>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-2">
            <label for="capacityday" class="col-form-label">Capacity Day</label>
        </div>
        <div class="col-sm-4 mb-3 capacityday">
            <input type="number" class="form-control" name="capacityday" id="capacityday" required>
        </div>
        <div class="col-sm-2">
            <label for="capacitymonth" class="col-form-label">Capacity Month</label>
        </div>
        <div class="col-sm-4 mb-3">
            <input type="number" class="form-control" name="capacitymonth" id="capacitymonth" required>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-2">
            <label for="keterangan" class="col-form-label">Keterangan</label>
        </div>
        <div class="col-sm-10 mb-3 keterangan">
            <input type="text" class="form-control" name="keterangan" id="keterangan" maxlength="50" autocomplete="off" required>
        </div>
    </div>
    <!-- end button -->
    <div class="row">
        <div class="col-lg-12 text-center">
            <button type="button" onclick="window.location.href='produksi.asp'" class="btn btn-danger">Kembali</button>
            <button type="submit" class="btn btn-primary">Tambah</button>
        </div>
    </div>
    </form>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call tambahProduksiH()
end if
call footer() 
%>