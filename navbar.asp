    <div id="navbar">
      <a href="#" class="menu-bars" id="show-menu" onclick="openNav()">
        <i class="bi bi-list"></i>
      </a>
    </div>
    <nav id="nav-menu">
      <ul class="nav-menu-items">
        <div id="navbar-toggle">
          <a href="" class="menu-bars" id="hide-menu" onclick="closeNav()">
            <i class="bi bi-list"></i>
          </a>
          <a href="\dashboard.asp">
            <h1>
              <img src="<%= url %>public/img/delimalogo.png" alt="delima-logo" width="40" height="40" id="delima-logo"
              />
              DELIMA
            </h1>
          </a>
        </div>
        <hr />
        <div class="nav-section">
        <!-- master -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-master')"><i class="bi bi-boxes"></i> Master</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-master">
              <li>
                <a href="<%= url %>views/Barang/">Master Barang</a>
              </li>
              <li>
                <a href="<%= url %>views/customer/">Master Customer</a>
              </li>
              <li>
                <a href="<%= url %>views/jenis/">Master jenis</a>
              </li>
              <li>
                <a href="<%= url %>views/kategori/">Master Kategori</a>
              </li>
              <li>
                <a href="<%= url %>views/kebutuhan/">Master Kebutuhan</a>
              </li>
              <li>
                <a href="<%= url %>views/Rak/">Master Rak</a>
              </li>
              <li>
                <a href="<%= url %>views/satbarang/">Master Satuan Barang</a>
              </li>
              <li>
                <a href="<%= url %>views/type/">Master Type Barang</a>
              </li>
              <li>
                <a href="<%= url %>views/vendor/">Master Vandor</a>
              </li>
            </ul>
          <!-- inventory -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-inventory')"><i class="bi bi-box-seam"></i> Inventory</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-inventory">
              <li>
                <a class="link-name" href="<%= url %>views/inventory/reqAnggaran.asp">Anggaran Permintaan</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/incoming/index.asp">Incomming</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/klaim/index.asp">Klaim Barang</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/outgoing/index.asp">Outgoing</a>
              </li>
              <!-- 
              <li>
                <a class="link-name" href="<%= url %>views/inventory/permintaan.asp">Form Produksi</a>
              </li>
               -->
              <li>
                <a class="link-name" href="<%= url %>views/inventory/POMin.asp">Permintaan Kurang</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/inventory/mutasiStok.asp">Mutasi Stok Barang</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/inventory/">Stok Barang</a>
              </li>
            </ul>
          <!-- marketing -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-marketing')"><i class="bi bi-activity"></i> Marketing</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-marketing">
              <li>
                <a class="link-name" href="<%= url %>views/so/">Sales Order</a>
              </li>
            </ul>
          <!-- qc -->
          <li class="nav-text">
            <a href="#"><i class="bi bi-check2-all"></i> QR/QC</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
          <!-- engineering -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-engineering')"><i class="bi bi-easel3"></i> Engineering</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-engineering">
              <li>
                <a class="link-name" href="<%= url %>views/engineering/">Engineering</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/produksi/">Produksi</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/bom/">Master B.O.M</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/brand/">Master Brand</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/class/">Master Class</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/sasis/">Standart Product</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/produksi/report.asp">Report Proses Produksi</a>
              </li>
            </ul>
          <!-- ppic -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-ppic')"><i class="bi bi-layers"></i> PPIC/Prod Dev</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-ppic">
              <li>
                <a class="link-name" href="<%= url %>views/rc/">Produksi Received</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/manpower/">Man Power</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/finishgood/">Produksi Finish</a>
              </li>
            </ul>
          <!-- purchase -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-purces')"><i class="bi bi-cash-stack"></i> Purchase</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-purces">
              <li>
                <a class="link-name" href="<%= url %>views/purces/">Purchase</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/purces/purcesDetail.asp">Purchase Detail</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/purces/uprice.asp">Update Harga Memo</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/faktur/">Faktur Terhutang</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/returnBarang/">Return Barang</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/purces/invPOmin.asp">Barang Kurang</a>
              </li>
            </ul>
          <!-- general ladger -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-gl')"><i class="bi bi-currency-dollar"></i> General Ledger</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-gl">
              <li>
                <a class="link-name" href="<%= url %>views/gl/item.asp">Daftar Kas Masuk/Keluar</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/gl/catitem.asp">Kategori Item</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/gl/kelompok.asp">Kelompok Perkiraan</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/gl/perkiraan.asp">Kode Perkiraan</a>
              </li>
            </ul>
          <!-- finance -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-finance')"><i class="bi bi-bag-plus-fill"></i> Finc/Accounting</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-finance">
              <li>
                <a class="link-name" href="<%= url %>views/finance/appmemo.asp">Approve Memo</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/finance/index.asp">Finance</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/Bank/">Master Bank</a>
              </li>
            </ul>
          <!-- hr/ga -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-hr')"><i class="bi bi-globe2"></i> HR/GA</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-hr">
              <li>
                <a class="link-name" href="<%= url %>views/aset/">Aset</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/divisi/">Divisi</a>
              </li>
              <li>
                <a href="<%= url %>views/departement/">Departement</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/jabatan/">Jabatan</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/jenjang/">Jenjang</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/karyawan/">Karyawan</a>
              </li>
            </ul>
        </div>
        <hr />
        <div class="nav-section">
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-cabang')"><i class="bi bi-house-door"></i> Cabang</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-cabang">
              <li>
                <a class="link-name" href="<%= url %>views/cabang/">Cabang</a>
              </li>
            </ul>
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-report')"><i class="bi bi-book"></i> Report</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
          <li class="nav-text">
            <a href="<%= url %>logout.asp"><i class="bi bi-box-arrow-in-left"></i> Log Out</a>
          </li>
        </div>
      </ul>
    </nav>
