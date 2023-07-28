<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_outgoing.asp"-->
<% 
    if session("INV4A") = false then
        Response.Redirect("./")
    end if

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string

    data_cmd.commandText = "SELECT AgenID, AgenName FROM GLB_M_Agen WHERE AgenAktifYN = 'Y' ORDER BY AgenName ASC"

    set dataAgen = data_cmd.execute
    call header("Form Outgoing")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
    <div class="row">
        <div class="col-lg-12 mt-3 mb-3 text-center">
            <h3>FORM OUTGOING</h3>
        </div>
    </div>
    <form action="out_add.asp" method="post" onsubmit="validasiForm(this,event,'Outgoing Prosess','warning')">
        <div class="row">
            <div class="col-lg-2 mb-3">
                <label for="agen" class="col-form-label">Cabang / Agen</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="agenOutgoing" name="agen" required>
                    <option value="">Pilih</option>
                    <% do while not dataAgen.eof %>
                    <option value="<%= dataAgen("AgenID") %>"><%= dataAgen("AgenName") %></option>
                    <% 
                    dataAgen.movenext
                    loop
                    %>
                </select>
            </div>
             <div class="col-lg-2 mb-3">
                <label for="tgl" class="col-form-label">Tanggal</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="tgl" name="tgl" class="form-control" value="<%= date() %>" onfocus="(this.type='date')" required>
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="Jenis" class="col-form-label">Jenis Produksi</label>
            </div>
            <div class="col-lg-4 mb-3">
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="typeRadioPdr" id="repair" value="R" onchange="getPdrOutgoing(this.value)" required>
                    <label class="form-check-label" for="repair">Repair</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="typeRadioPdr" id="project" value="P" onchange="getPdrOutgoing(this.value)">
                    <label class="form-check-label" for="project">Project</label>
                </div>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="bmhid" class="col-form-label">No Produksi</label>
            </div>
            <div class="col-lg-4 mb-3 loutgoinglama">
                <select class="form-select" aria-label="Default select example" name="lbom" id="lbom" > 
                    <option value="" readonly disabled>Pilih Cabang dahulu</option>
                </select>
            </div>
        </div>
        <div class='row'>
            <div class="col-lg-2 mb-3">
                <label for="keterangan" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-lg-10 mb-3">
                <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" autocomplete="off">
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12 text-center">
                <a href="./" type="button" class="btn btn-danger">Kembali</a>
                <button type="submit" class="btn btn-primary">Save</button>
            </div>
        </div>
    </form>
</div>  
<% 
    if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
        call tambahOutgoing()
    end if
    call footer()
%>