<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_vendor.asp"-->
<% 
    if session("M8A") = false then  
        Response.Redirect("index.asp")
    end if
    set cabang_cmd =  Server.CreateObject ("ADODB.Command")
    cabang_cmd.ActiveConnection = mm_delima_string
    ' cabang / agen
    cabang_cmd.commandText = "SELECT GLB_M_Agen.AgenName, AgenID FROM GLB_M_Agen WHERE AgenAktifYN = 'Y' ORDER BY AgenName ASC"
    set cabang = cabang_cmd.execute
    ' kode akun
    cabang_cmd.commandText = "SELECT GL_M_chartAccount.CA_ID, GL_M_chartAccount.CA_Name FROM GL_M_chartAccount WHERE CA_AktifYN = 'Y' ORDER BY CA_Name ASC"
    set dataakun = cabang_cmd.execute
    ' bank
    cabang_cmd.commandText = "SELECT Bank_ID, Bank_Name FROM GL_M_Bank WHERE Bank_AktifYN = 'Y' ORDER BY Bank_Name ASC"
    set databank = cabang_cmd.execute

    call header("Tambah Vendor")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row mt-3 mb-3">
        <div class="col-lg text-center">
            <h3>FORM TAMBAH VENDOR</h3>
        </div>
    </div>
    <div class="row d-flex justify-content-center">
        <div class="col-lg-10">
            <form action="ven_add.asp" method="post" id="formVendor">
                <div class="row">
                    <div class="col-sm-12 text-center p-2 rounded mb-3" style="background:#ddd;">
                        <label>DETAIL VENDOR</label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-6 mb-3">
                        <label for="cabang" class="form-label">Pilih Cabang</label>
                        <select class="form-select" aria-label="Default select example" name="cabang" id="cabang" required>
                            <option value="">Pilih</option>
                            <% do while not cabang.eof %>
                                <option value="<%= cabang("agenID") %>"><%= cabang("agenName") %></option>
                            <% 
                            cabang.movenext
                            loop
                            %>
                        </select>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <label for="kdakun" class="form-label">Kode Akun</label>
                        <select class="form-select" aria-label="Default select example" id="kdakun" name="kdakun" required>
                            <option value="">Pilih</option>
                            <% do while not dataakun.eof %>
                                <option value="<%= dataakun("CA_ID") %>"><%= dataakun("CA_Name") %></option>
                            <% 
                            dataakun.movenext
                            loop
                            %>
                        </select>
                    </div>
                </div> 
                <div class="row">
                    <div class="col-lg-6 mb-3">
                        <label for="typet" class="form-label">Type Transaksi</label>
                        <select class="form-select" aria-label="Default select example" name="typet" id="typet" required>
                            <option value="">Pilih</option>
                            <option value="1">CBD</option>
                            <option value="2">COD</option>
                            <option value="3">TOP</option>
                        </select>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <label for="nama" class="form-label">Nama</label>
                        <input type="text" class="form-control" id="nama" name="nama" maxlength="30" autocomplete="off" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-6 mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" name="email" maxlength="50" autocomplete="off" required>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <label for="phone" class="form-label">Phone</label>
                        <input type="number" class="form-control" id="phone" name="phone" autocomplete="off" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-6 mb-3">
                        <label for="provinsi" class="form-label">Provinsi</label>
                        <span id="tampilProvinsi">
                        </span>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <label for="kota" class="form-label">Kota</label>
                        <span id="kotaLama">
                            <select class="form-select" aria-label="Default select example">
                                <option value disabled readonly>Pilih Provinsi Dahulu</option>
                            </select>
                        </span>
                        <span id="tampilKota">
                        </span>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-6 mb-3">
                        <label for="alamat" class="form-label">Detail Alamat</label>
                        <input type="text" class="form-control" id="alamat" name="alamat" maxlength="50" autocomplete="off" required>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <label for="top" class="form-label">Payment Term</label>
                        <input type="number" class="form-control" id="top" name="top" autocomplete="off">
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12 text-center p-2 rounded mb-3" style="background:#ddd;">
                        <label>AKUN BANK</label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-6 mb-3">
                        <label for="bank" class="form-label">Bank</label>
                        <select class="form-select" aria-label="Default select example" name="bank" id="bank" required>
                            <option value="">Pilih</option>
                            <% do while not databank.eof %>
                            <option value="<%= databank("bank_ID") %>"><%= databank("Bank_Name") %></option>
                            <% 
                            databank.movenext
                            loop
                            %>
                        </select>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <label for="norek" class="form-label">No.Rekening</label>
                        <input type="number" maxlength="20" class="form-control" id="norek" name="norek" autocomplete="off" required>
                    </div>
                </div>
                <div class="row ">
                    <div class="col-lg-6 mb-3">
                        <label for="rekName" class="form-label">Nama Pemilik Rekening</label>
                        <input type="text" class="form-control" id="rekName" name="rekName" maxlength="50" autocomplete="off" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12 text-center p-2 rounded mb-3" style="background:#ddd;">
                        <label>ORANG YANG DAPAT DI HUBUNGI</label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-6 mb-3">
                        <label for="cp" class="form-label">Contact Person</label>
                        <input type="text" class="form-control" id="cp" name="cp" maxlength="50" autocomplete="off" >
                    </div>
                    <div class="col-lg-6 mb-3">
                        <label for="phoneCp" class="form-label">Phone Cp</label>
                        <input type="number" class="form-control" id="phoneCp" name="phoneCp" maxlength="13"  autocomplete="off" >
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg text-center">
                        <a href="index.asp"><button type="button" class="btn btn-danger">kembali</button></a>
                        <button type="submit" class="btn btn-primary">Tambah</button>
                    </div>
                </div>                
            </form>
        </div>
    </div>
</div>
<% 
if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call tambahVendor()
end if
call footer() 
%>
<script>
    $(document).ready(function(){
        // get api provinsi
        const getApiProvinsi = function(url,params) {
            let result = `<option value="">Pilih</option>`
            let obj 
            $.ajax({
                url: url,
                type: 'get',
                dataType: 'json',
                async: false,
                success: function(data) {
                    if(params == 1){
                        obj = data.provinsi;
                    }else{
                        obj = data.kota_kabupaten;
                    }
                    
                    for(i=0;i < obj.length;i++){
                        result += `<option value="${obj[i].id},${obj[i].nama}">${obj[i].nama}</option>`
                    }
                } 
            });
            return result 
        }
        // set provinsi select
        $("#tampilProvinsi").html(
            `<select class='form-select' aria-label='Default select example' name='provinsi' id='provinsi' required>` + getApiProvinsi("https://dev.farizdotid.com/api/daerahindonesia/provinsi", 1) + `</select>` )
        // set kota select
        $("#provinsi").change(function(){
            let kotaID
            kotaID = $("#provinsi").val().split(",")[0]
             
            if (kotaID != ""){
                $("#kotaLama").html('')

                $("#tampilKota").html(`<select class='form-select' aria-label='Default select example' name='kota' id='kota' required>` + getApiProvinsi("https://dev.farizdotid.com/api/daerahindonesia/kota?id_provinsi=" + kotaID, 2) + `</select>` )
            }
        })

        // set payterm
        $("#typet").change(function() {
            if($("#typet").val() == 3){
                $("#top").prop('required',true);
            }
        })
    })
</script>