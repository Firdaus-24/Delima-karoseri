<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_orjul.asp"-->
<% 
    set data =  Server.CreateObject ("ADODB.Command")
    data.ActiveConnection = mm_delima_string

    ' get agen / cabang
    data.commandText = "SELECT AgenName, AgenID FROM DLK_M_Barang LEFT OUTER JOIN GLB_M_Agen ON left(DLK_M_Barang.Brg_ID,3) = GLB_M_Agen.AgenID WHERE agenAktifYN = 'Y' AND DLK_M_Barang.Brg_AktifYN = 'Y' GROUP BY AgenName, AgenID ORDER BY AgenName ASC"

    set pcabang = data.execute    

    ' get divisi
    data.commandText = "SELECT DivNama, DivID FROM DLK_M_Divisi WHERE DivAktifYN = 'Y' ORDER BY DivNama ASC"
    set pdivisi = data.execute    

    call header("From Permintaan Barang") 
%>

<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>FORM PERMINTAAN BARANG</h3>
        </div>
    </div>
    <form action="permintaan_add.asp" method="post" id="formorjulbarang" onsubmit="validasiForm(this,event,'Permintaan Barang','warning')">
        <div class="row">
            <div class="col-sm-2">
                <label for="tgl" class="col-form-label">Tanggal</label>
            </div>
            <div class="col-sm-4 mb-3">
                <input type="text" id="tgl" class="form-control" name="tgl" value="<%= Date() %>" onfocus="(this.type='date')" required>
            </div>
            <div class="col-sm-2">
                <label for="agen" class="col-form-label">Cabang / Agen</label>
            </div>
            <div class="col-sm-4 mb-3">
                <select class="form-select" aria-label="Default select example" name="agen" id="orjulagen" required> 
                    <option value="">Pilih</option>
                    <% do while not pcabang.eof %>
                    <option value="<%= pcabang("agenID") %>"><%= pcabang("agenNAme") %></option>
                    <%  
                    pcabang.movenext
                    loop
                    %>
                </select>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-2">
                <label for="divisi" class="col-form-label">Divisi</label>
            </div>
            <div class="col-sm-4 mb-3">
                <select class="form-select" aria-label="Default select example" name="divisi" id="orjuldivisi" required> 
                    <option value="">Pilih</option>
                    <% do while not pdivisi.eof %>
                    <option value="<%= pdivisi("divId") %>"><%= pdivisi("divNama") %></option>
                    <%  
                    pdivisi.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-sm-2">
                <label for="deputuhan" class="col-form-label">Departement</label>
                </div>
            <div class="col-sm-4  orjuldeplama">
                <select class="form-select" aria-label="Default select example" name="ldep" id="ldep" > 
                    <option value="" readonly disabled>Pilih Divisi dahulu</option>
                </select>
            </div>
            <div class="col-sm-4  orjuldepbaru">
                <!-- kontent departement -->
            </div>
        </div>
        <div class="row">
            <div class="col-sm-2">
                <label for="Kebutuhan" class="col-form-label">Kebutuhan</label>
            </div>
            <div class="col-sm-4 mb-3">
                <select class="form-select" aria-label="Default select example" name="kebutuhan" id="orjulkebutuhan" required> 
                    <option value="">Pilih</option>
                    <option value="0">Produksi</option>
                    <option value="1">Khusus</option>
                    <option value="2">Umum</option>
                    <option value="3">Sendiri</option>
                </select>
            </div>
            <div class="col-sm-2">
                <label for="produksi" class="col-form-label">No Produksi</label>
            </div>
            <div class="col-sm-4 mb-3">
                <div class="lproduk">
                    <select class="form-select" aria-label="Default select example" name="lproduk" id="lproduk"> 
                        <option value="">Pilih</option>
                    </select>
                </div>
                <div class="cariProduk">
                
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-2">
                <label for="keterangan" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-sm-10 mb-3">
                <input type="text" id="keterangan" class="form-control" name="keterangan" maxlength="50" autocomplete="off" required>
            </div>
        </div>
    </div>
     
    <!-- end button -->
    <div class="row">
        <div class="col-lg-12 text-center">
            <button type="button" onclick="window.location.href='index.asp'" class="btn btn-danger">Kembali</button>
            <button type="submit" class="btn btn-primary">Tambah</button>
        </div>
    </div>
    </form>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call tambahOrjulH()
end if
call footer() 
%>