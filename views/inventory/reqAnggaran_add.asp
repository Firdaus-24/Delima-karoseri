<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_reqAnggaran.asp"-->
<% 
    if session("INV1A") = false then 
        Response.Redirect("index.asp")
    end if
    set data =  Server.CreateObject ("ADODB.Command")
    data.ActiveConnection = mm_delima_string
    ' get barang
    data.commandText = "SELECT Brg_ID, Brg_Nama FROM DLK_M_Barang WHERE Brg_AktifYN = 'Y' ORDER BY Brg_Nama ASC"
    set getBarang = data.execute
    ' get agen / cabang
    data.commandText = "SELECT AgenName, AgenID FROM DLK_M_Barang LEFT OUTER JOIN GLB_M_Agen ON left(DLK_M_Barang.Brg_ID,3) = GLB_M_Agen.AgenID WHERE agenAktifYN = 'Y' AND DLK_M_Barang.Brg_AktifYN = 'Y' GROUP BY AgenName, AgenID ORDER BY AgenName ASC"
    set pcabang = data.execute    
    ' get satuan
    data.commandText = "SELECT sat_Nama, sat_ID FROM DLK_M_satuanBarang WHERE sat_AktifYN = 'Y' ORDER BY sat_Nama ASC"
    set psatuan = data.execute    
    ' get divisi
    data.commandText = "SELECT DivNama, DivID FROM HRD_M_Divisi WHERE DivAktifYN = 'Y' ORDER BY DivNama ASC"
    set pdivisi = data.execute    

    ' cek kebutuhan
    data.commandText = "SELECT K_ID,K_Name FROM DLK_M_Kebutuhan WHERE K_AktifYN = 'Y' ORDER BY K_ID ASC"

    set ckkebutuhan = data.execute

    call header("From Permintaan Anggaran") 
%>

<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>FORM PERMINTAAN ANGGARAN</h3>
        </div>
    </div>
    <form action="reqAnggaran_add.asp" method="post" id="formAnggaranH" onsubmit="validasiForm(this,event,'Permintaan Anggaran','warning')">
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
                <select class="form-select" aria-label="Default select example" name="agen" id="agenpb" required> 
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
                <select class="form-select" aria-label="Default select example" name="divisi" id="pbdivisi" required> 
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
                <label for="departement" class="col-form-label">Departement</label>
            </div>
            <div class="col-sm-4  deplama">
                <select class="form-select" aria-label="Default select example" name="ldep" id="ldep" > 
                    <option value="" readonly disabled>Pilih Divisi dahulu</option>
                </select>
            </div>
            <div class="col-sm-4  depbaru">
                <!-- kontent departement -->
            </div>
        </div>
        <div class="row">
            <div class="col-sm-2">
                <label for="kebutuhan" class="col-form-label">Kebutuhan</label>
            </div>
            <div class="col-sm-4 mb-3">
                <select class="form-select" aria-label="Default select example" name="kebutuhan" id="kebutuhan" required> 
                    <option value="">Pilih</option>
                    <% do while not ckkebutuhan.eof %>
                    <option value="<%= ckkebutuhan("K_ID") %>"><%= ckkebutuhan("K_Name") %></option>
                    <% 
                    response.flush
                    ckkebutuhan.movenext
                    loop
                    %>

                </select>
            </div>
            <div class="col-sm-2">
                <label for="keterangan" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-sm-4 mb-3">
                <input type="text" id="keterangan" class="form-control" name="keterangan" maxlength="50" autocomplete="off" required>
            </div>
        </div>
     
    <!-- end button -->
    <div class="row">
        <div class="col-lg-12 text-center">
            <button type="button" onclick="window.location.href='reqAnggaran.asp'" class="btn btn-danger">Kembali</button>
            <button type="submit" class="btn btn-primary">Tambah</button>
        </div>
    </div>
    </form>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call tambahAnggaranH()
end if
call footer() 
%>