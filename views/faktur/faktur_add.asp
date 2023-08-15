<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_Faktur.asp"-->
<% 
    if session("PR4A") = false then
        Response.Redirect("./")
    end if

    id = trim(Request.QueryString("id"))

    set data_cmd =  Server.CreateObject ("ADODB.Command")
    data_cmd.ActiveConnection = mm_delima_string
    
    ' vendor
    data_cmd.commandText = "SELECT ven_Nama, Ven_ID FROM DLK_M_Vendor WHERE Ven_AktifYN = 'Y' ORDER BY ven_Nama ASC"
    set vendor = data_cmd.execute

    call header("Faktur Hutang")

    ' agen / cabang
    data_cmd.commandTExt = "SELECT AgenName, AgenID FROM GLB_M_Agen WHERE AgenAktifYN = 'Y' ORDER BY AgenNAme ASC"

    set agen = data_cmd.execute
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>FORM TAMBAH FAKTUR TERHUTANG</h3>
        </div>
    </div>
    <form action="faktur_add.asp" method="post" id="formfaktur">
        <div class="row">
            <div class="col-lg-2 mb-3">
                <label for="fakturagen" class="col-form-label">Cabang / Agen</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="fakturagen" name="agen" required>
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
                <label for="ophid" class="col-form-label">No P.O</label>
            </div>
            <div class="col-lg-4 mb-3 lpolama">
                <select class="form-select" aria-label="Default select example" name="lpo" id="lpo" > 
                    <option value="" readonly disabled>Pilih Cabang dahulu</option>
                </select>
            </div>
            <div class="col-lg-4 lpobaru">
                <!-- kontent po -->
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
                <input type="text" id="tgljt" name="tgljt" class="form-control" onfocus="(this.type='date')">
            </div>
        </div>
        <div class="row align-items-center">
            <div class="col-lg-2 mb-3">
                <label for="vendor" class="col-form-label">Vendor</label>
            </div>
            <div class="col-lg-4 mb-3">
                <select class="form-select" aria-label="Default select example" id="vendor" name="vendor" required>
                    <option value="">Pilih</option>
                    <% do while not vendor.eof %>
                    <option value="<%= vendor("ven_ID") %>"><%= vendor("ven_Nama") %></option>
                    <% 
                    vendor.movenext
                    loop
                    %>
                </select>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="ppn" class="col-form-label">PPN</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="number" id="ppn" name="ppn" class="form-control" required>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-2 mb-3">
                <label for="asuransi" class="col-form-label">Asuransi</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="asuransi" name="asuransi" class="form-control" onchange="rupiah(parseInt(this.value), 'asuransi')" autocomplete="off" required>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="lain" class="col-form-label">Lain-lain</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="lain" name="lain" class="form-control" autocomplete="off" onchange="rupiah(parseInt(this.value), 'lain')" autocomplete="off" required>
            </div>
        </div>        
        <div class="row">
            <div class="col-lg-2 mb-3">
                <label for="diskon" class="col-form-label">Diskon</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="number" id="diskon" name="diskon" class="form-control" required>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="tukar" class="col-form-label">Tukar Faktur</label>
            </div>
            <div class="col-lg-4 mb-3">
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" id="tukarY" name="tukar" value="Y" required>
                    <label class="form-check-label" for="tukarY">Yes</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" id="tukanN" name="tukar" value="N">
                    <label class="form-check-label" for="tukanN">No</label>
                </div>
            </div>
        </div>      
        <div class="row">
            <div class="col-lg-2 mb-3">
                <label for="kebutuhan" class="col-form-label">Kebutuhan</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="hidden" id="kebutuhan" name="kebutuhan" class="form-control"  autocomplete="off" required>
                <input type="text" id="lkebutuhan" name="lkebutuhan" class="form-control"  autocomplete="off" readonly required>
            </div>
            <div class="col-lg-2 mb-3">
                <label for="keterangan" class="col-form-label">Keterangan</label>
            </div>
            <div class="col-lg-4 mb-3">
                <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" autocomplete="off" required>
            </div>
        </div>    
        <div class="row">
            <div class="col-lg-12 text-center">
                <a href="index.asp" type="button" class="btn btn-danger">Kembali</a>
                <button type="submit" class="btn btn-primary">Save</button>
            </div>
        </div>
    </form>
</div>  
<script>
function format(number){
    if (!isNaN(number)){
        var rupiah = '';
        var angkarev = number.toString().split('').reverse().join('');
        for (var i = 0; i < angkarev.length; i++) if (i % 3 === 0) rupiah += angkarev.substr(i, 3) + '.';
        
        return rupiah.split('', rupiah.length - 1).reverse().join('') + ',-';
    }else{
        swal("yang anda masukan bukan nomor!");
    }
}
const rupiah = (e,t) =>{$(`#${t}`).val(format(e))}

const getValuePO = (id) => {
        $.ajax({
            method: "POST",
            url: "../../ajax/getPoByNo.asp",
            data: { id },
            dataType:'json',
        }).done(function( msg ) {
            $("#tgljt").val(msg.JTDATE)
            $("#vendor").val(msg.VENDOR)
            $("#ppn").val(msg.PPN)
            $("#asuransi").val(format(msg.ASURANSI))
            $("#lain").val(format(msg.LAIN))
            $("#diskon").val(msg.DISKONALL)
            $("#lkebutuhan").val(msg.KEBUTUHANLABEL)
            $("#kebutuhan").val(msg.KEBUTUHANID)
            $("#keterangan").val(msg.KETERANGAN)
        });
    }
</script>
<% 
    if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
        call tambahFaktur()
    end if
    call footer()
%>
