<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_invnew.asp"-->
<% 
  if session("MK3A") = false then
      Response.Redirect("index.asp")
  end if

  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string
  
  ' agen / cabang
  data_cmd.commandTExt = "SELECT AgenName, AgenID FROM GLB_M_Agen WHERE AgenAktifYN = 'Y' ORDER BY AgenNAme ASC"
  set agen = data_cmd.execute

  call header("Form Invoice")
%>
<!--#include file="../../navbar.asp"--> 
<div class="container">
  <div class="row">
    <div class="col-lg-12 mb-3 mt-3 text-center">
      <h3>FORM TAMBAH INVOICE</h3>
    </div>
  </div>
  <form action="inv_add.asp" method="post" onsubmit="validasiForm(this,event,'Tambah Invoce Brand New','warning')">
    <div class="row">
      <div class="col-lg-2 mb-3">
        <label for="fakturagen" class="col-form-label">Cabang / Agen</label>
      </div>
      <div class="col-lg-4 mb-3">
        <select class="form-select" aria-label="Default select example" id="ageninvnew" name="cabang" required>
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
      <div class="col-lg-4 mb-3 invmktlama">
        <select class="form-select" aria-label="Default select example" name="lpo" id="lpo" > 
          <option value="" readonly disabled>Pilih Cabang dahulu</option>
        </select>
      </div>
      <div class="col-lg-4 invmktbaru">
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
        <label for="customer" class="col-form-label">customer</label>
      </div>
      <div class="col-lg-4 mb-3">
        <input type="hidden" id="cust" name="cust" class="form-control" required>
        <input type="text" id="lscust" name="lscust" class="form-control" required>
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
        <label for="keterangan" class="col-form-label">Keterangan</label>
      </div>
      <div class="col-lg-10 mb-3">
        <div class="form-floating">
          <textarea class="form-control" placeholder="Keterangan" id="keterangan" name="keterangan" style="height: 100px" maxlength="255"></textarea>
          <label for="keterangan">Keterangan</label>
        </div>
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
  const getValuePO = (id) => {
    $.ajax({
        method: "POST",
        url: "getnopo.asp",
        data: { id },
        dataType:'json',
    }).done(function( msg ) {
        if (msg.JTDATE != "1900-01-01"){
          $("#tgljt").val(msg.JTDATE)
        }else{
          $("#tgljt").val('')
        }
        $("#cust").val(msg.CUSTID)
        $("#lscust").val(msg.CUSTNAME)
        $("#ppn").val(msg.PPN)
        $("#diskon").val(msg.DISKONALL)
        $("#keterangan").val(msg.KETERANGAN)
    });
  }
</script>
<% 
  if Request.ServerVariables("REQUEST_METHOD") = "POST" then 
    call tambahinv()
  end if
  call footer()
%>
