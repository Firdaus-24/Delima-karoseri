<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_ReturnBarang.asp"-->
<% 
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT AgenID, AgenName FROM GLB_M_Agen WHERE AgenAktifYN = 'Y' ORDER BY AgenNAme asc"

    set agen = data_cmd.execute

    call header("FORM RETURN BARANG")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 mb-3 text-center">
            <h3>FORM RETURN BARANG PEMBELIAN</h3>
        </div>
    </div>
    <form action="rb_add.asp" method="post" id="formReturnBarang">
        <div class="row">
            <div class="col-sm-2">
                <label for="cabang" class="col-form-label">Cabang / Agen</label>
            </div>
            <div class="col-sm-4 mb-3">
                <select class="form-select" aria-label="Default select example" name="cabang" id="returncabang" required> 
                    <option value="">Pilih</option>
                    <% do while not agen.eof %>
                    <option value="<%= agen("agenID") %>"><%= agen("agenNAme") %></option>
                    <%  
                    agen.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-sm-2">
                <label for="tgl" class="col-form-label">Tanggal</label>
            </div>
            <div class="col-sm-4 mb-3">
                <input type="text" id="tgl" class="form-control" name="tgl" value="<%= Date() %>" onfocus="(this.type='date')" required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-2">
                <label for="agen" class="col-form-label">Vendor</label>
            </div>
            <div class="col-sm-4 mb-3 vendorlama">
                <select class="form-select" aria-label="Default select example" name="lvendor" id="lvendor"> 
                    <option value=""disabled>Pilih Cabang dahulu</option>
                 </select>
            </div>
            <div class="col-sm-4 mb-3 vendorbaru" style="display:none">
                <!-- content vendor by cabang -->
            </div>
            <div class="col-sm-2">
                <label for="keterangan" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-sm-4 mb-3">
                <input type="text" id="keterangan" class="form-control" name="keterangan" maxlength="50" autocomplete="off" required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm text-center">
                <button type="button" class="btn btn-danger" onclick="window.location.href='index.asp'">Kembali</button>
                <button type="submit" class="btn btn-primary">Save</button>
            </div>
        </div>
    </form>
</div>
<% 
    if request.serverVariables("REQUEST_METHOD") = "POST" then
        call tambahReturnBarang()
    end if
    call footer()
%>