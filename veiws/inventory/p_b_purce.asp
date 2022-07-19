<!--#include file="../../init.asp"-->
<% call header("From Permintaan Barang") %>

<!--#include file="../../navbar.asp"-->
<div class="container">
    <div class="row">
        <div class="col-lg-12 mb-3 mt-3 text-center">
            <h3>FORM PERMINTAAN BARANG</h3>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-6 mb-3">
            <div class="col-auto">
                <label for="kdbarang" class="col-form-label">Kode Barang</label>
            </div>
            <div class="col-auto">
                <input type="password" id="kdbarang" class="form-control" name="kdbarang">
            </div>
            <div class="col-auto">
                <label for="nama" class="col-form-label">Nama</label>
            </div>
            <div class="col-auto">
                <input type="password" id="nama" class="form-control" name="nama">
            </div>
        </div>
    </div>
</div>





<% call footer() %>