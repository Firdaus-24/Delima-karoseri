<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_karyawan.asp"-->
<% 
  if session("HR5B") = false then
    Response.Redirect("index.asp")
  end if

  nip = trim(Request.QueryString("nip"))

  set data_cmd = Server.CreateObject("ADODB.Command")
  data_cmd.ActiveConnection = MM_delima_STRING
  ' agama
  data_cmd.commandText = "SELECT Agama_ID, Agama_Nama FROM HRD_M_Agama WHERE Agama_aktifYN = 'Y' ORDER BY AGama_Nama"
  set agama = data_cmd.execute
  ' cabang
  data_cmd.commandText = "SELECT agenID, AgenName FROM GLB_M_Agen WHERE agenAktifYN = 'Y' ORDER BY AgenName"
  set cabang = data_cmd.execute
  ' divisi
  data_cmd.commandText = "select DivID, DivNama from HRD_M_Divisi WHERE DivAktifYN = 'Y' ORDER BY DivNama ASC"
  set divisi = data_cmd.execute
  ' jabatan
  data_cmd.commandText = "select jab_code, Jab_Nama from HRD_M_Jabatan WHERE jab_aktifYN = 'Y' ORDER BY Jab_nama ASC"
  set jabatan = data_cmd.execute
  ' jenjang 
  data_cmd.commandText = "select JJ_ID, JJ_Nama from HRD_M_Jenjang WHERE jJ_aktifYN = 'Y' ORDER BY JJ_nama ASC"
  set jenjang = data_cmd.execute
  ' pendidikan
  data_cmd.commandText = "SELECT JDdk_Nama, JDdk_ID FROM HRD_M_JenjangDidik WHERE JDDK_aktifYN = 'Y'"
  set pendidikan = data_cmd.execute
  ' departement
  data_cmd.commandText = "select DepID, DepNama from HRD_M_Departement WHERE DepaktifYN = 'Y' ORDER BY Depnama ASC"
  set departement = data_cmd.execute
  ' bank
  data_cmd.commandText = "SELECT Bank_ID, Bank_Name FROM GL_M_Bank WHERE Bank_AktifYN = 'Y' ORDER BY Bank_Name ASC"
  set bank = data_cmd.execute
  ' sim
  data_cmd.commandText = "SELECT sim_ID, sim_Nama FROM HRD_M_sim WHERE sim_AktifYN = 'Y' ORDER BY sim_id ASC"
  set sim = data_cmd.execute

  data_cmd.commandText = "SELECT dbo.GLB_M_Agen.AgenName, dbo.HRD_M_Divisi.DivNama, dbo.HRD_M_Departement.DepNama, dbo.HRD_M_Jabatan.Jab_Nama, dbo.HRD_M_Agama.Agama_Nama, dbo.HRD_M_JenjangDidik.JDdk_Nama, dbo.HRD_M_Jenjang.JJ_Nama, dbo.HRD_M_Sim.Sim_Nama, dbo.HRD_M_Karyawan.*, GL_M_Bank.Bank_Name FROM dbo.HRD_M_Karyawan LEFT OUTER JOIN dbo.HRD_M_Sim ON dbo.HRD_M_Karyawan.Kry_JnsSIM = dbo.HRD_M_Sim.Sim_ID LEFT OUTER JOIN dbo.HRD_M_JenjangDidik ON dbo.HRD_M_Karyawan.Kry_JDdkID = dbo.HRD_M_JenjangDidik.JDdk_ID LEFT OUTER JOIN dbo.HRD_M_Agama ON dbo.HRD_M_Karyawan.Kry_AgamaID = dbo.HRD_M_Agama.Agama_ID LEFT OUTER JOIN dbo.HRD_M_Jenjang ON dbo.HRD_M_Karyawan.Kry_JJID = dbo.HRD_M_Jenjang.JJ_ID LEFT OUTER JOIN dbo.HRD_M_Jabatan ON dbo.HRD_M_Karyawan.Kry_JabCode = dbo.HRD_M_Jabatan.Jab_code LEFT OUTER JOIN dbo.HRD_M_Departement ON dbo.HRD_M_Karyawan.Kry_DepID = dbo.HRD_M_Departement.DepID LEFT OUTER JOIN dbo.HRD_M_Divisi ON dbo.HRD_M_Karyawan.Kry_DivID = dbo.HRD_M_Divisi.DivId LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.HRD_M_Karyawan.Kry_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN GL_M_Bank ON HRD_M_Karyawan.Kry_BankID = GL_M_Bank.Bank_ID WHERE (dbo.HRD_M_Karyawan.Kry_AktifYN = 'Y')AND HRD_M_Karyawan.Kry_Nip = '"& nip &"'"

  set data = data_cmd.execute

  call header("Update Karyawan")
%>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-sm-12 text-center mt-3 mb-3">
      <h3>UPDATE DATA KARYAWAN</h3>
    </div>
  </div>
  <form action="kry_u.asp?nip=<%= nip %>" method="post" class="bg-light p-4" id="formuKry" onsubmit="validasiForm(this,event,'UPDATE MASTER KARYAWAN','warning')">
    <div class="row">
      <div class="col-sm-6">
        <label>Nip</label>
        <input type="text" name="nip" class="form-control" id="nip" value="<%= data("Kry_Nip") %>" readonly>
        <label>Nama</label>
        <input type="text" name="nama" class="form-control" id="nama" autocomplete="off" value="<%= data("Kry_Nama") %>" required>
        <label>Alamat</label>
        <input type="text" name="alamat"  class="form-control" id="alamat" value="<%= data("Kry_addr1") %>" autocomplete="off" required>
        <label>Kelurahan</label>
        <input type="text" name="kelurahan" value="<%= data("Kry_addr2") %>"  class="form-control" id="kelurahan" autocomplete="off" required>
      </div>
      <div class="col-sm-6">
        <div class="form-check form-check-inline">
          <label class="mt-2 mb-1 d-flex flex-row">BPJS KES</label>
          <div class="form-check form-check-inline">
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" id="bpjsY" name="bpjskes" <% if data("Kry_BPJSKesYN") = "Y" then %> checked <% end if %> value="Y">
              <label class="form-check-label" for="bpjsY">Yes</label>
            </div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" id="bpjsN" name="bpjskes" value="N" <% if data("Kry_BPJSKesYN") = "N" then %> checked <% end if %>>
              <label class="form-check-label" for="bpjsN">No</label>
            </div>
          </div>
        </div>
        <div class="form-check form-check-inline">
          <label class="mt-2 mb-1 d-flex flex-row">BPJS KET</label>
          <div class="form-check form-check-inline">
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" id="bpjsKetY" <% if data("Kry_BPJSKetYN") = "Y" then %> checked <% end if %> name="bpjs" value="Y">
              <label class="form-check-label" for="bpjsKetY">Yes</label>
            </div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" id="bpjsKetN" name="bpjs" value="N" <% if data("Kry_BPJSKetYN") = "N" then %> checked <% end if %>>
              <label class="form-check-label" for="bpjsKetN">No</label>
            </div>
          </div>
        </div>
        <br/>
        <label>Telphone 1</label>
          <input type="text" class="form-control" name="tlp1" id="tlp1" maxlength="12" value="<%= data("Kry_Telp1") %>"  required>
        <label>Telphone 2</label>
          <input type="text" class="form-control" name="tlp2" id="tlp2" value="<%= data("Kry_Telp2") %>"  maxlength="12">
        <div class="row">
          <div class="col-6">
            <label>Kota</label>
              <input type="text" name="kota" class="form-control" id="kota" value="<%= data("Kry_Kota") %>" required>
          </div>
          <div class="col-6">
            <label>Pos</label>
              <input type="text" class="form-control" name="pos" id="pos" maxlength="5" value="<%= data("Kry_kdpos") %>" required>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-sm-4">
        <label>Tempat Lahir</label>
        <input type="text" name="tempat" class="form-control" id="tempat" value="<%= data("Kry_TmpLahir") %>" required>
      </div>
      <div class="col-sm-2">
        <label>Tanggal Lahir</label>
        <input type="text" name="tglL" class="form-control" id="tglL" value="<%= data("Kry_TglLahir") %>" onfocus="(this.type='date')" required>
      </div>
      <div class="col-sm-3">
        <label>Atasan 1</label>
        <input type="text" name="atasan1" class="form-control" id="atasan1" maxlength="11" value="<%= data("Kry_atasanNip1") %>"  autocomplete="off">
      </div>
      <div class="col-sm-3">
        <label>Atasan 2</label>
        <input type="text" class="form-control" name="atasan2" id="atasan2" maxlength="11"  value="<%= data("Kry_atasanNip2") %>" autocomplete="off">
      </div>
    </div>
    <div class="row">
      <div class="col-sm-4">
        <label>Email</label>
        <input type="email" name="email" class="form-control" id="email" value="<%= data("Kry_Email") %>" required>
      </div>
      <div class="col-sm-2">
        <label>Agama</label>
        <select class="form-select" aria-label="Default select example" name="agama" id="agama" required>
            <option value="<%= data("Kry_AgamaID") %>"><%= data("Agama_Nama") %></option>
            <% do until agama.eof %> 
            <option value="<%= agama("Agama_Id") %> "><%= agama("Agama_Nama") %> </option>
            <% agama.movenext 
            loop%> 
        </select>
      </div>
      <div class="col-sm">
        <label>Cabang</label>
        <select class="form-select" aria-label="Default select example" name="cabang"  id="cabang" required>
            <option value="<%= data("Kry_AgenID") %>"><%= data("AgenName") %></option>
            <% do until cabang.EOF %> 
              <option value="<%= cabang("agenID") %> "><%= cabang("agenName") %> </option>
            <% 
            cabang.movenext 
            loop
            %> 
        </select>
      </div>
    </div>
    <div class="row">
      <div class="col-sm-3">
        <label>Jenis Kelamin</label>
        <select class="form-select" aria-label="Default select example" name="jkelamin" id="jkelammin" required>
            <% if ucase(data("Kry_sex")) = "P" then  %> 
              <option value="P">Pria</option>
            <% else %>
              <option value="W">Wanita</option>
            <% end if %>
            <option value="P">Laki-Laki</option>
            <option value="W">Wanita</option>
        </select>
      </div>
      <div class="col-sm-3">
        <label>Status Sosial</label>
        <select class="form-select" aria-label="Default select example" name="ssosial" id="ssosial" required>
            <option value="<%=data("Kry_SttSosial")%>">
            <%
            if data("Kry_SttSosial") = 1 then 
              Response.Write "Belum Menikah"
            elseIf data("Kry_SttSosial") = 2 then
              Response.Write "Menikah"
            elseIf data("Kry_SttSosial") = 3 then
              Response.Write "Janda/Duda"
            end if
            %> </option>
            <option value="1">Belum Menikah</option>
            <option value="2">Menikah</option>
            <option value="3">Janda / Duda</option>
        </select>
      </div>
      <div class="col-sm-6">
        <label>Divisi</label>
        <select class="form-select" aria-label="Default select example" name="divisi" id="divisi" required> 
            <option value="<%= data("Kry_DivID") %>"><%= data("DivNama") %></option>
            <% do until divisi.EOF %> 
            <option value="<%= divisi("DivID") %> "><%= divisi("DivNama") %> </option>
            <% divisi.movenext 
            loop%> 
        </select>
      </div>  
    </div>
    <div class="row">
      <div class="col-sm-3">
        <label>Jumlah Anak</label>
        <input type="number" name="janak" class="form-control" id="janak" value="<%= data("Kry_JmlAnak") %>" required>
      </div>
      <div class="col-sm-3">
        <label>Tanggungan</label>
        <input type="number" name="tanggungan" class="form-control" id="tanggungan" value="<%= data("Kry_JmlTanggungan") %>"required>
      </div>
      <div class="col-sm-6">
        <label>Jabatan</label>
        <select class="form-select" aria-label="Default select example" name="jabatan" id="jabatan" required>
            <option value="<%= data("Kry_JabCOde") %>"><%= data("Jab_Nama") %></option>
            <% do until jabatan.eof %> 
            <option value="<%= jabatan("Jab_Code") %> "><%= jabatan("Jab_Nama") %></option>
            <% jabatan.movenext 
            loop%> 
        </select>
      </div>
    </div>  
    <div class="row">
      <div class="col-sm-3">
        <label>Pendidikan</label>
        <select class="form-select" aria-label="Default select example" name="pendidikan" id="pendidikan" required>
            <option value="<%= data("Kry_JDDKID") %>"><%= data("JDDK_Nama") %></option>
            <% do until pendidikan.eof %> 
            <option value="<%= pendidikan("JDdk_ID") %>"><%= pendidikan("JDdk_Nama") %> </option>
            <% pendidikan.movenext
            loop %> 
        </select>
      </div>
      <div class="col-sm-3">
        <label>Status Pegawai</label>
        <select class="form-select" aria-label="Default select example" name="spegawai" id="spegawai" required>
            <option value="<%= data("Kry_SttKerja") %>">
              <% 
              if data("Kry_SttKerja") = 1 then
                Response.Write "Borongan"
              elseIf  data("Kry_SttKerja") = 2 then
                Response.Write "Harian"
              elseIf data("Kry_SttKerja") = 3 then
                Response.Write "Kontrak"
              elseIf data("Kry_SttKerja") = 4 then 
                Response.Write "Magang"
              elseIf data("Kry_SttKerja") = 5 then 
                Response.Write "Tetap"
              else
                Response.Write "" 
              end if
              %>
            </option>
            <option value="1">Borongan</option>
            <option value="2">Harian</option>
            <option value="3">Kontrak</option>
            <option value="4">Magang</option>
            <option value="5">Tetap</option>
        </select>
      </div>
      <div class="col-sm-6">
        <label>Jenjang</label>
        <select class="form-select" aria-label="Default select example" name="jenjang" id="jenjang" required>
            <option value="<%= data("Kry_JJID") %>"><%= data("JJ_Nama") %></option>
            <% do until jenjang.EOF %> 
            <option value="<%= jenjang("JJ_ID") %> "><%= jenjang("JJ_Nama") %> </option>
            <% jenjang.movenext 
            loop%> 
        </select>
      </div>
    </div>
    <div class="row">
      <div class="col-sm-3">
        <label>Saudara</label>
        <input type="number" name="saudara" class="form-control" id="saudara"  value="<%= data("Kry_JmlSaudara") %>" required>
      </div>
      <div class="col-sm-3">
        <label>Anak Ke-</label>
        <input type="number" name="anakke" class="form-control" id="anakke"  value="<%= data("Kry_anakke") %>" required>
      </div>
      <div class="col-sm-6">
        <label>Departement</label>
        <select class="form-select" aria-label="Default select example" name="departement" id="departement" required>
            <option value="<%= data("Kry_DepID") %>"><%= data("DepNama") %></option>
            <% do until departement.EOF %> 
            <option value="<%= departement("DepID") %> "><%= departement("DepNama") %> </option>
            <% departement.movenext 
            loop%> 
        </select>
      </div>
    </div>
    <div class="row">
      <div class="col-sm-3">
        <label>Bank</label>
        <select class="form-select" aria-label="Default select example" name="bankID" id="bankID" required>
          <option value="<%= data("Kry_BankID") %>"><%= data("Bank_Name") %></option>
          <% do while not bank.eof %>
              <option value="<%= bank("Bank_ID") %>"><%= bank("Bank_Name") %></option>
          <% 
          bank.movenext
          loop
          %>
        </select>
      </div>
      <div class="col-sm-3">
        <label>No Rekening</label>
        <input type="number" name="norek" class="form-control" id="norek" value="<%= data("Kry_NoRekening") %>" required>
      </div>
      <div class="col-sm">
        <label>Jumlah Cuti</label>
        <input type="number" name="jcuti" class="form-control" id="jcuti" value="<%= data("Kry_jmlcuti") %>">
      </div>
    </div>
    <div class="row">
      <div class="col-sm-3">
        <label>BPJS Kesehatan</label>
        <input type="number" name="kesehatan" class="form-control" id="kesehatan" value="<%= data("Kry_NoBPJSKes") %>">
      </div>
      <div class="col-sm-3">
        <label>Ketenagakerjaan</label>
        <input type="number" name="tenagakerja" class="form-control" id="tenagakerja" value="<%= data("Kry_NoBPJSKet") %>">
      </div>
      <div class="col-sm-3">
        <label>No KTP</label>
        <input type="number" name="ktp" class="form-control" id="ktp" maxlength="16" value="<%= data("Kry_NoID") %>" required>
      </div>
      <div class="col-sm-3">
        <label>NPWP</label>
        <input type="text" name="npwp" class="form-control" id="npwp" value="<%= data("Kry_NPWP") %>" maxlength="16">
      </div>
    </div>    
    <div class="row">
      <div class="col-sm-2">
        <label>Tanggal Masuk</label>
        <input type="text" name="tglmasuk" class="form-control" id="tglmasuk" <% if data("Kry_tglMasuk") = "1/1/1900" then %> value="" <% else %> value="<%= data("Kry_TglMasuk") %>" <% end if %> onfocus="(this.type='date')" required>
      </div>
      <div class="col-sm-2">
        <label>Tanggal Keluar</label>
        <input type="text" name="tglkeluar" class="form-control" id="tglkeluar" <% if data("Kry_tglkeluar") = "1/1/1900" then %> value="" <% else %> value="<%= data("Kry_Tglkeluar") %>" <% end if %> onfocus="(this.type='date')">
      </div>
      <div class="col-sm-4">
        <label>No SIM</label>
        <input type="number" name="nsim" class="form-control" id="nsim" value="<%= data("Kry_NoSIM") %>">
      </div>
      <div class="col-sm-4">
        <label>Jenis Vaksin</label>
        <input type="text" name="vaksin" class="form-control" id="vaksin" maxlength="100" value="<%= data("Kry_JenisVaksin") %>">
      </div>
    </div>  
    <div class="row mb-3">
      <div class="col-sm-2">
        <label>Tanggal StartGaji</label>
        <input type="text" name="tglagaji" class="form-control" id="tglagaji" <% if data("Kry_TglStartGaji") = "1/1/1900" then %> value="" <% else %> value="<%= data("Kry_TglStartGaji") %>" <% end if %> onfocus="(this.type='date')">
      </div>
      <div class="col-sm-2">
        <label>Tanggal EndGaji</label>
        <input type="text" name="tglegaji" class="form-control" id="tglegaji" <% if data("Kry_TglendGaji") = "1/1/1900" then %> value="" <% else %> value="<%= data("Kry_TglendGaji") %>" <% end if %> onfocus="(this.type='date')">
      </div>
      <div class="col-sm-2">
        <label>Berlaku SIM</label>
        <input type="date" name="berlakuSIM" class="form-control" id="berlakuSIM" <% if data("Kry_SimValidDate") = "1/1/1900" then %> value="" <% else %> value="<%= data("Kry_SIMValidDate") %>" <% end if %> onfocus="(this.type='date')">
      </div>
      <div class="col-sm-2">
        <label>Jenis SIM</label>
        <select class="form-select" aria-label="Default select example" name="jsim" id="jsim">
          <option value="<%= data("Kry_JnsSIM") %>"><%= data("Sim_Nama") %></option>
          <%  do while not sim.eof %>
          <option value="<%= sim("sim_ID") %>"><%= sim("Sim_Nama") %></option>
          <% 
          response.flush
          sim.movenext
          loop
          %>
        </select>
      </div>
      <div class="col-sm">
        <label>Golongan Darah</label>
        <select class="form-select" aria-label="Default select example" name="goldarah" id="goldarah">
            <%if data("Kry_golDarah") = "" then %>
              <option value="">Pilih</option>
            <%else%>
              <option value="<%= data("Kry_golDarah") %>"><%=data("Kry_golDarah")%></option>
            <%end if%>
            <option value="A">A</option>
            <option value="B">B</option>
            <option value="AB">AB</option>
            <option value="O">O</option>
        </select>
      </div>
    </div>  
     <div class="row">  
        <div class="col-sm mt-3 text-center" >
            <button type="submit" class="btn btn-primary submit" >Update</button>
            <button type="button" onclick="window.location.href='index.asp'" class="btn btn-danger kembali">Kembali</button>
        </div>
      </div>
  </form>
</div>
<% 
  If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
    call karyawanupdate()
  end if 
  call footer() 
%>