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
              <% if session("M1") = true then %>
              <li>
                <a href="<%= url %>views/Barang/">Master Barang</a>
              </li>
              <% end if %>
              <% if session("M12") = true then %>
              <li>
                <a href="<%= url %>views/b_biaya/">Master Beban Biaya</a>
              </li>
              <% end if %>
              <% if session("M2") = true then %>
              <li>
                <a href="<%= url %>views/customer/">Master Customer</a>
              </li>
              <% end if %>
              <% if session("M3") = true then %>
              <li>
                <a href="<%= url %>views/jenis/">Master jenis</a>
              </li>
              <% end if %>
              <% if session("M4") = true then %>
              <li>
                <a href="<%= url %>views/kategori/">Master Kategori</a>
              </li>
              <% end if %>
              <% if session("M10") = true then %>
              <li>
                <a href="<%= url %>views/kebutuhan/">Master Kebutuhan</a>
              </li>
              <% end if %>
              <% if session("M5") = true then %>
              <li>
                <a href="<%= url %>views/Rak/">Master Rak</a>
              </li>
              <% end if %>
              <% if session("M6") = true then %>
              <li>
                <a href="<%= url %>views/satbarang/">Master Satuan Barang</a>
              </li>
              <% end if %>
              <% if session("M11") = true then %>
              <li>
                <a href="<%= url %>views/satpanjang/">Master Satuan Panjang</a>
              </li>
              <% end if %>
              <% if session("M7") = true then %>
              <li>
                <a href="<%= url %>views/type/">Master Type Barang</a>
              </li>
              <% end if %>
              <% if session("M8") = true then %>
              <li>
                <a href="<%= url %>views/vendor/">Master Vandor</a>
              </li>
              <% end if %>
            </ul>
          <!-- inventory -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-inventory')"><i class="bi bi-box-seam"></i> Inventory</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-inventory">
              <% if session("INV1") = true then %>  
              <li>
                <a class="link-name" href="<%= url %>views/inventory/reqAnggaran.asp">Anggaran Permintaan</a>
              </li>
              <% end if %>
              <% if session("INV9") = true then %>  
              <li>
                <a class="link-name" href="<%= url %>views/invtryrepair/">Anggaran B.O.M Repair</a>
              </li>
              <% end if %>
              <% if session("INV10") = true then %>  
              <li>
                <a class="link-name" href="<%= url %>views/inventory/bomproject.asp">Anggaran B.O.M Project</a>
              </li>
              <% end if %>
              <% if session("INV2") = true then %>
              <li>
                <a class="link-name" href="<%= url %>views/incoming/index.asp">Incomming</a>
              </li>
              <% end if %>
              <% if session("INV3") = true then %>
              <li>
                <a class="link-name" href="<%= url %>views/klaim/index.asp">Klaim Barang</a>
              </li>
              <% end if %>
              <% if session("INV4") = true then %>
              <li>
                <a class="link-name" href="<%= url %>views/outgoing/index.asp">Outgoing</a>
              </li>
              <% end if %>
              <% if session("INV6") = true then %>
              <li>
                <a class="link-name" href="<%= url %>views/inventory/POMin.asp">Permintaan Kurang</a>
              </li>
              <% end if %>
              <% if session("INV7") = true then %>
              <li>
                <a class="link-name" href="<%= url %>views/inventory/mutasiStok.asp">Mutasi Stok Barang</a>
              </li>
              <% end if %>
              <% if session("INV8") = true then %>
              <li>
                <a class="link-name" href="<%= url %>views/inventory/">Stok Barang</a>
              </li>
              <% end if %>
            </ul>
          <!-- marketing -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-marketing')"><i class="bi bi-activity"></i> Marketing</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-marketing">
              <% if session("MK1") = true then %>
              <li>
                <a class="link-name" href="<%= url %>views/so/">Sales Order New</a>
              </li>
              <% end if %>
              <% if session("MK2") = true then %>
              <li>
                <a class="link-name" href="<%= url %>views/salesrep/">Sales Order Repair</a>
              </li>
              <% end if %>
              <% if session("MK3") = true then %>
              <li>
                <a class="link-name" href="<%= url %>views/invnew/">Invoice New</a>
              </li>
              <% end if %>
              <% if session("MK4") = true then %>
              <li>
                <a class="link-name" href="<%= url %>views/invrepair/">Invoice Repair</a>
              </li>
              <% end if %>
            </ul>
          <!-- qc -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-qc')"><i class="bi bi-activity"></i> QR/QC</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
             <ul class="sub-menu" id="sublist-qc">
              <% if session("MQ1") = true then %>
              <li>
                <a class="link-name" href="<%= url %>views/unit/">Item Penunjang Unit</a>
              </li>
              <% end if %>
              <% if session("MQ2") = true then %>
              <li>
                <a class="link-name" href="<%= url %>views/serteruni/">Serah Terima Unit</a>
              </li>
              <% end if %>
              <% if session("MQ3") = true then %>
              <li>
                <a class="link-name" href="<%= url %>views/pdi/">PDI Project</a>
              </li>
              <% end if %>
              <% if session("MQ4") = true then %>
              <li>
                <a class="link-name" href="<%= url %>views/incunit/">Incomming Unit</a>
              </li>
              <% end if %>
            </ul>
          <!-- engineering -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-engineering')"><i class="bi bi-easel3"></i> Engineering</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-engineering">
              <li>
                <a class="link-name" href="<%= url %>views/engineering/">Engineering</a>
              </li>
              <% if session("ENG6") = true then %>
              <li>
                <a class="link-name" href="<%= url %>views/produksi/report.asp">Report Proses Produksi</a>
              </li>
              <% end if %>
              <% if session("ENG7") = true then %>
              <li>
                <a class="link-name" href="<%= url %>views/engineering/predBom.asp">Report Prediksi Harga</a>
              </li>
              <% end if %>
              <% if session("ENG8") = true then %>
              <li>
                <a class="link-name" href="<%= url %>views/suratjalan/">Surat Jalan</a>
              </li>
              <% end if %>
            </ul>
          <!-- Model -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-model')"><i class="bi bi-easel2"></i> model</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-model">
              <% if session("MDL1") = true then%>
              <li>
                <a class="link-name" href="<%= url %>views/model/">Master Model</a>
              </li>
              <% end if%>
              <% if session("ENG2") = true then %>
              <li>
                <a class="link-name" href="<%= url %>views/bom/">Master B.O.M</a>
              </li>
              <% end if %>
              <% if session("ENG4") = true then %>
              <li>
                <a class="link-name" href="<%= url %>views/brand/">Master Brand</a>
              </li>
              <% end if %>
              <% if session("ENG3") = true then %>
              <li>
                <a class="link-name" href="<%= url %>views/class/">Master Class</a>
              </li>
              <% end if %>
              <% if session("ENG5") = true then %>
              <li>
                <a class="link-name" href="<%= url %>views/sasis/">Standart Product</a>
              </li>
              <% end if %>
            </ul>
          <!-- djtf -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-djtf')"><i class="bi bi-tools"></i> DJTF</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-djtf">
              <% if session("DJTF1") = true then%>
              <li>
                <a class="link-name" href="<%= url %>views/alatfacility/">Master Alat & facility</a>
              </li>
              <% end if%>
              
            </ul>
          <!-- ppic / produksi-->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-ppic')"><i class="bi bi-layers"></i> PPIC/Prod Dev</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-ppic">
              <% if session("ENG1") = true then %>
              <li>
                <a class="link-name" href="<%= url %>views/produksi/">Produksi</a>
              </li>
              <% end if %>
              <% if session("PP1") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/rc/">Produksi Received</a>
              </li>
              <% end if %>
              <% if session("PP2") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/manpower/">Man Power</a>
              </li>
              <% end if %>
              <% if session("PP4") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/bbtp/">Beban Biaya Proses</a>
              </li>
              <% end if%>
              <% if session("PP3") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/ReturnMaterial/">Return Material</a>
              </li>
              <% end if %>
              <% if session("PP5") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/prodrepair/">Produksi Repair</a>
              </li>
              <% end if %>
              <% if session("PP6") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/bomrepair/">B.O.M Repair</a>
              </li>
              <%end if%>
              <% if session("PP7") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/bomrepair/anggaran.asp">Anggaran B.O.M Repair</a>
              </li>
              <%end if%>
              <% if session("PP8") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/anggaranbomproject/">Anggaran B.O.M Project</a>
              </li>
              <%end if%>
            </ul>
          <!-- purchase -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-purces')"><i class="bi bi-cash-stack"></i> Purchase</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-purces">
              <% if session("PR1") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/purces/">Purchase</a>
              </li>
              <% end if %>
              <% if session("PR2") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/purces/purcesDetail.asp">Purchase Detail</a>
              </li>
              <% end if %>
              <% if session("PR3") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/purces/uprice.asp">Update Harga Memo</a>
              </li>
              <% end if %>
              <% if session("PR4") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/faktur/">Faktur Terhutang</a>
              </li>
              <% end if %>
              <% if session("PR5") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/returnBarang/">Return Barang</a>
              </li>
              <% end if %>
              <% if session("PR6") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/purces/invPOmin.asp">Barang Kurang</a>
              </li>
              <% end if %>
            </ul>
          <!-- general ladger -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-gl')"><i class="bi bi-currency-dollar"></i> General Ledger</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-gl">
              <% if session("GL1") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/gl/item.asp">Daftar Kas Masuk/Keluar</a>
              </li>
              <% end if %>
              <% if session("GL2") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/gl/catitem.asp">Kategori Item</a>
              </li>
              <% end if %>
              <% if session("GL3") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/gl/kelompok.asp">Kelompok Perkiraan</a>
              </li>
              <% end if %>
              <% if session("GL4") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/gl/perkiraan.asp">Kode Perkiraan</a>
              </li>
              <% end if %>
            </ul>
          <!-- finance -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-finance')"><i class="bi bi-bag-plus-fill"></i> Finc/Accounting</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-finance">
              <li>
                <a class="link-name" href="<%= url %>views/finance/index.asp">Finance</a>
              </li>
              <% if session("FN1") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/finance/appmemo.asp">Approve Memo</a>
              </li>
              <% end if %>
              <% if session("FN2") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/Bank/">Master Bank</a>
              </li>
              <% end if %>
            </ul>
          <!-- hr/ga -->
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-hr')"><i class="bi bi-globe2"></i> HR/GA</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-hr">
              <% if session("HR1") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/aset/">Aset</a>
              </li>
              <% end if %>
              <% if session("HR2") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/divisi/">Divisi</a>
              </li>
              <% end if %>
              <% if session("HR3") =  true then %>
              <li>
                <a href="<%= url %>views/departement/">Departement</a>
              </li>
              <% end if %>
              <% if session("HR6") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/jabatan/">Jabatan</a>
              </li>
              <% end if %>
              <% if session("HR7") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/jenjang/">Jenjang</a>
              </li>
              <% end if %>
              <% if session("HR5") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/jnsusaha/">Jenis Usaha</a>
              </li>
              <% end if %>
              <% if session("HR5") =  true then %>
              <li>
                <a class="link-name" href="<%= url %>views/karyawan/">Karyawan</a>
              </li>
              <% end if %>
            </ul>
        </div>
        <hr />
        <div class="nav-section">
          <% if session("HR4") =  true then %>
          <li class="nav-text">
            <a href="#" onclick="toggle('sublist-cabang')"><i class="bi bi-house-door"></i> Cabang</a>
            <i class="bi bi-chevron-compact-down" id="iconDown"></i>
          </li>
            <ul class="sub-menu" id="sublist-cabang">
              <li>
                <a class="link-name" href="<%= url %>views/cabang/">Cabang</a>
              </li>
            </ul>
          <% end if %>
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
