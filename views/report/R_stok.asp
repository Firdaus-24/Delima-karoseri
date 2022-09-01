<!--#include file="../../init.asp"-->
<% 
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT AgenName, AgenID FROM GLB_M_Agen WHERE AgenAktifYN = 'Y' ORDER BY AgenName ASC"
    set agen = data_cmd.execute

    data_cmd.commandText = "SELECT Brg_Nama, Brg_ID FROM DLK_M_Barang WHERE Brg_AktifYN = 'Y' AND Brg_StokYN = 'Y' ORDER BY Brg_nama ASC"
    set barang = data_cmd.execute

    call header("Stok Barang")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 text-center mt-3 mb-3">
            <h3>STOK BARANG</h3>
        </div>
    </div>
    <form>
        <div class="row">
            <div class="d-flex justify-content-center">
                <div class="col-sm-6 mb-3">
                    <label for="agen" class="form-label">Cabang</label>
                    <select class="form-select" aria-label="Default select example" name="agen" id="agen">
                        <option value="">Pilih</option>
                        <% do while not agen.eof %>
                        <option value="<%= agen("AgenID") %>"><%= agen("AgenName") %></option>
                        <% 
                        agen.movenext
                        loop
                        %>
                    </select>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="d-flex justify-content-center">
                <div class="col-sm-6 mb-3">
                    <label for="barang" class="form-label">Barang</label>
                    <select class="form-select" aria-label="Default select example" name="barang" id="barang">
                        <option value="">Pilih</option>
                        <% do while not barang.eof %>
                        <option value="<%= barang("brg_ID") %>"><%= barang("brg_nama") %></option>
                        <% 
                        barang.movenext
                        loop
                        %>
                    </select>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="d-flex justify-content-center">
                <div class="col-6 mb-3">
                    <button type="submit" class="btn btn-primary">Tampilkan</button>
                    <button type="button" class="btn btn-danger float-end">Kembali</button>
                </div>
            </div>
        </div>
    </form>

</div>


<% 
    call footer()
%>