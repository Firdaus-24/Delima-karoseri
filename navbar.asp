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
          <a href="dashboard.asp">
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
                <a class="link-name" href="<%= url %>views/inventory/incomming.asp">Incomming</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/klaim/index.asp">Klaim Barang</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/inventory/jbarang.asp">Outgoing</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/inventory/permintaan.asp">Permintaan Barang</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/inventory/POMin.asp">Permintaan Kurang</a>
              </li>
            </ul>
          <!-- repair -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-repair')"><i class="bi bi-activity"></i> Repair</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-repair">
              <li>
                <a class="link-name" href="<%= url %>views/repair/">reparir</a>
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
                <a class="link-name" href="<%= url %>views/engineering/produksi.asp">Produksi</a>
              </li>
            </ul>
          <!-- ppic -->
          <li class="nav-text">
            <a href="#"><i class="bi bi-layers"></i> PPIC/Prod Dev</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
          <!-- purchase -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-purces')"><i class="bi bi-cash-stack"></i> Mark/Purchase</a>
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
                <a class="link-name" href="<%= url %>views/returnBarang/">Return Barang</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/purces/invoReserve.asp">Invoices Reserve</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/purces/invPOmin.asp">Barang Kurang</a>
              </li>
            </ul>
          <!-- finance -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-finance')"><i class="bi bi-bag-plus-fill"></i> Finc/Acc Dev</a>
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
                <a class="link-name" href="<%= url %>views/finance/catitem.asp">Kategori Item</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/finance/mutasiStok.asp">Mutasi Stok Barang</a>
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
            </ul>
          <!-- permintaan barang -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-permintaanb')"><i class="bi bi-folder2-open"></i> Permintaan Barang</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-permintaanb">
              <li>
                <a class="link-name" href="<%= url %>views/permintaan/index.asp">Permintaan Barang</a>
              </li>
            <ul>
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
             <ul class="sub-menu" id="sublist-report">
              <li>
                <a class="link-name" href="<%= url %>views/report/R_stok.asp">Stok Barang</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/report/R_cekin.asp">Barang Masuk</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>views/report/R_cekout.asp">Barang Keluar</a>
              </li>
            </ul>
        </div>
      </ul>
    </nav>
