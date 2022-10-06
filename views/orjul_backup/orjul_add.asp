<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_orjul.asp"-->
<% 
    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    ' satuan
    data_cmd.commandText = "SELECT sat_Nama, sat_ID FROM DLK_M_satuanBarang WHERE sat_AktifYN = 'Y' ORDER BY sat_Nama ASC"
    set psatuan = data_cmd.execute
    ' agen
    data_cmd.commandText = "SELECT GLB_M_Agen.AgenID , GLB_M_Agen.AgenName FROM DLK_T_InvPemH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_InvPemH.IPH_AgenID = GLB_M_Agen.AgenID WHERE GLB_M_Agen.AgenAktifYN = 'Y' and DLK_T_InvPemH.IPH_AktifYN = 'Y' GROUP BY GLB_M_Agen.AgenID, GLB_M_Agen.AgenName ORDER BY GLB_M_Agen.AgenName ASC"
    set agen = data_cmd.execute
    ' divisi
    data_cmd.commandText = "SELECT divNama, divID FROM DLK_M_divisi WHERE divAktifYN = 'Y' ORDER BY divNama ASC"
    set divisi = data_cmd.execute

    call header("Prosess Orderjual")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>FORM PERMINTAAN BARANG</h3>
        </div>
    </div>
    <form action="orjul_add.asp" method="post" id="formorjul">
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="agen" class="col-form-label">Cabang / Agen</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="agen" name="agen" autofocusrequired>
                    <option value="">Pilih</option>
                    <% do while not agen.eof %>
                    <option value="<%= agen("AgenID") %>"><%= agen("AgenName") %></option>
                    <% 
                    agen.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="tgl" class="col-form-label">Tanggal</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="tgl" name="tgl" value="<%= date %>" class="form-control" onfocus="(this.type='date')" required>
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="div" class="col-form-label">Divisi</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="orjuldiv" name="div" required>
                    <option value="">Pilih</option>
                    <% do while not divisi.eof %>
                    <option value="<%= divisi("divID") %>"><%= divisi("divNama") %></option>
                    <% 
                    divisi.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="dep" class="col-form-label">Departement</label>
            </div>
            <div class="col-lg-4 mb-3 orjulDeplast">
                <select class="form-select" aria-label="Default select example" id="ldep" name="ldep">
                    <option value desabled selected>Pilih Divisi Dahulu</option>
                </select>
            </div>
            <div class="col-lg-4 mb-3 orjulDepfirst">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="keterangan" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-lg-10 mb-3">
                <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" autocomplete="off">
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12 mb-3 mt-3 text-center">
                <a href="outgoing.asp" type="button" class="btn btn-danger">Kembali</a>
                <button type="submit" class="btn btn-primary">Save</button>
            </div>
        </div>
    </form>
</div>  


<% 
    if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
        call tambahOrjul()
    end if
    call footer()
%>