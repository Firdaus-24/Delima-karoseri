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
                <a href="<%= url %>veiws/Barang/">Master Barang</a>
              </li>
              <li>
                <a href="<%= url %>veiws/kategori/">Master Kategori</a>
              </li>
              <li>
                <a href="<%= url %>veiws/jenis/">Master jenis</a>
              </li>
              <li>
                <a href="<%= url %>veiws/Rak/">Master Rak</a>
              </li>
              <li>
                <a href="<%= url %>veiws/satbarang/">Master Satuan Barang</a>
              </li>
              <li>
                <a href="<%= url %>veiws/kebutuhan/">Kebutuhan Permintaan</a>
              </li>
              <li>
                <a href="<%= url %>veiws/vendor/">Master Vandor</a>
              </li>
            </ul>
          <!-- inventory -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-inventory')"><i class="bi bi-box-seam"></i> Inventory</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-inventory">
              <li>
                <a class="link-name" href="<%= url %>veiws/inventory/">Inventory</a>
              </li>
            </ul>
          <!-- repair -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-repair')"><i class="bi bi-activity"></i> Repair</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-repair">
              <li>
                <a class="link-name" href="<%= url %>veiws/inventory/">Inventory</a>
              </li>
              <li>
                <a href="<%= url %>veiws/Rak/">Master Rak</a>
              </li>
              <li>
                <a href="<%= url %>veiws/satbarang/">Master Satuan Barang</a>
              </li>
              <li>
                <a href="<%= url %>veiws/kodeBarang/">Master Kode Barang</a>
              </li>
              <li>
                <a href="<%= url %>veiws/vendor/">Master Vandor</a>
              </li>
            </ul>
          <!-- qc -->
          <li class="nav-text">
            <a href="#"><i class="bi bi-check2-all"></i> QR/QC</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
          <!-- engenering -->
          <li class="nav-text">
            <a href="#"><i class="bi bi-easel3"></i> Enginering</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
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
                <a class="link-name" href="<%= url %>veiws/purces/">Purchase</a>
              </li>
            </ul>
          <!-- finance -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-finance')"><i class="bi bi-bag-plus-fill"></i> Finc/Acc Dev</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-finance">
              <li>
                <a class="link-name" href="<%= url %>veiws/finance/index.asp">Finance</a>
              </li>
            </ul>
          <!-- hr/ga -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-hr')"><i class="bi bi-globe2"></i> HR/GA</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-hr">
              <li>
                <a class="link-name" href="<%= url %>veiws/hr/">HR/GA</a>
              </li>
              <li>
                <a class="link-name" href="<%= url %>veiws/divisi/">Divisi</a>
              </li>
            </ul>
          <!-- permintaan barang -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-permintaanb')"><i class="bi bi-folder2-open"></i> Permintaan Barang</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-permintaanb">
              <li>
                <a class="link-name" href="<%= url %>veiws/permintaanBarang/p_barang.asp">Permintaan Barang</a>
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
                <a class="link-name" href="<%= url %>veiws/cabang/">Cabang</a>
              </li>
            </ul>
          <li class="nav-text">
            <a href="#"><i class="bi bi-clock-history"></i> History</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
        </div>
      </ul>
    </nav>
