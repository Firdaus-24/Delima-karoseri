<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_aset.asp"-->
<%  
    if session("HR1A") = false then
        Response.Redirect("index.asp")
    end if

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' get cabang
    data_cmd.commandText = "SELECT AgenID, AgenNAme FROM GLB_M_Agen WHERE AgenAKtifYN = 'Y' ORDER BY AgenName ASC"
    set cabang = data_cmd.execute

    ' get penanggung jawab
    data_cmd.commandTExt = "SELECT UserID, Username FROM DLK_M_WebLogin WHERE UserAktifYN = 'Y' ORDER BY Username ASC"
    set user = data_cmd.execute

    ' get divisi
    data_cmd.commandTExt = "SELECT Divid, DivNama FROM DLK_M_Divisi WHERE divAktifYN = 'Y' ORDER BY divnama ASC"
    set divisi = data_cmd.execute

call header("Form Aset") 
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3 mb-3">
        <div class="col-lg text-center">
            <h3>FORM TAMBAH ASET BARANG</h3>
        </div>
    </div>
    <form action="aset_add.asp" method="post" id="formaset" >
        <div class="row  mb-3 mt-3">
            <div class="col-sm-2">
                <label for="cabang" class="form-label">Cabang</label>
            </div>
            <div class="col-sm-5">
                <select class="form-select" aria-label="Default select example" name="cabang" id="asetcabang" required>
                    <option value="">Pilih</option>
                    <% do while not cabang.eof %>
                        <option value="<%= cabang("agenID") %>"><%= cabang("AgenName") %></option>
                    <% 
                    cabang.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-sm-2">
                <label for="tgl" class="form-label">Tanggal</label>
            </div>
            <div class="col-sm-3">
                <input type="text" class="form-control" name="tgl" id="tgl" value="<%= now %>" autocomplete="off" onfocus="(this.type='datetime-local')" required>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-2">
                <label for="divisi" class="form-label">Divisi</label>
            </div>
            <div class="col-sm-5 mb-3">
                <select class="form-select" aria-label="Default select example" name="divisi" id="divisi" required>
                    <option value="">Pilih</option>
                    <% do while not divisi.eof %>
                        <option value="<%= divisi("divId") %>"><%= divisi("DivNama") %></option>
                    <% 
                    divisi.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-sm-2 ">
                <label for="depAset" class="form-label">Departement</label>
            </div>
            <div class="col-sm-3  asetdeplama">
                <select class="form-select" aria-label="Default select example" name="ldep" id="ldep" > 
                    <option value="" readonly disabled>Pilih Divisi dahulu</option>
                </select>
            </div>
            <div class="col-sm-3  asetdepbaru">
                <!-- kontent departement -->
            </div>
        </div>
        <div class="row">
            <div class="col-sm-2">
                <label for="keterangan" class="form-label">Keterangan</label>
            </div>
            <div class="col-sm-5 mb-3">
                <input type="text" class="form-control" name="keterangan" id="keterangan" autocomplete="off" maxlength="50" required>
            </div>
            <div class="col-sm-2">
                <label for="pJawab" class="form-label">Penanggung Jawab</label>
            </div>
            <div class="col-sm-3 mb-3">
                <select class="form-select" aria-label="Default select example" name="pJawab" id="pJawab" required>
                    <option value="">Pilih</option>
                    <% do while not user.eof %>
                        <option value="<%= user("userID") %>"><%= user("Username") %></option>
                    <% 
                    user.movenext
                    loop
                    %>
                </select>
            </div>
        </div>
        <div class="row text-center">
            <div class="col-lg">
                <button type="submit" class="btn btn-primary">Tambah</button>
                <a href="index.asp"><button type="button" class="btn btn-danger">kembali</button></a>
            </div>
        </div>
    </form>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call tambahAsetH()
   
end if
call footer() 
%>