<!--#include file="../../init.asp"-->
<%
' if session("HA1") = false then
'     Response.Redirect("../dashboard.asp")
' end if
  set nip = Request.QueryString("nip")

  Set karyawan_cmd = Server.CreateObject ("ADODB.Command")
  karyawan_cmd.ActiveConnection = MM_delima_STRING

  karyawan_cmd.commandText = "SELECT dbo.GLB_M_Agen.AgenName, dbo.HRD_M_Divisi.DivNama, dbo.HRD_M_Departement.DepNama, dbo.HRD_M_Jabatan.Jab_Nama, dbo.HRD_M_Agama.Agama_Nama, dbo.HRD_M_JenjangDidik.JDdk_Nama, dbo.HRD_M_Jenjang.JJ_Nama, dbo.HRD_M_Sim.Sim_Nama, dbo.HRD_M_Karyawan.*, GL_M_Bank.Bank_Name FROM dbo.HRD_M_Karyawan LEFT OUTER JOIN dbo.HRD_M_Sim ON dbo.HRD_M_Karyawan.Kry_JnsSIM = dbo.HRD_M_Sim.Sim_ID LEFT OUTER JOIN dbo.HRD_M_JenjangDidik ON dbo.HRD_M_Karyawan.Kry_JDdkID = dbo.HRD_M_JenjangDidik.JDdk_ID LEFT OUTER JOIN dbo.HRD_M_Agama ON dbo.HRD_M_Karyawan.Kry_AgamaID = dbo.HRD_M_Agama.Agama_ID LEFT OUTER JOIN dbo.HRD_M_Jenjang ON dbo.HRD_M_Karyawan.Kry_JJID = dbo.HRD_M_Jenjang.JJ_ID LEFT OUTER JOIN dbo.HRD_M_Jabatan ON dbo.HRD_M_Karyawan.Kry_JabCode = dbo.HRD_M_Jabatan.Jab_code LEFT OUTER JOIN dbo.HRD_M_Departement ON dbo.HRD_M_Karyawan.Kry_DepID = dbo.HRD_M_Departement.DepID LEFT OUTER JOIN dbo.HRD_M_Divisi ON dbo.HRD_M_Karyawan.Kry_DivID = dbo.HRD_M_Divisi.DivId LEFT OUTER JOIN dbo.GLB_M_Agen ON dbo.HRD_M_Karyawan.Kry_AgenID = dbo.GLB_M_Agen.AgenID LEFT OUTER JOIN GL_M_Bank ON HRD_M_Karyawan.Kry_BankID = GL_M_Bank.Bank_ID WHERE (dbo.HRD_M_Karyawan.Kry_AktifYN = 'Y')AND HRD_M_Karyawan.Kry_Nip = '"& nip &"' "
  'response.write karyawan_cmd.commandText & "<BR>"
  set karyawan = karyawan_cmd.execute

  call header("Detail Karyawan")
%>
<!--#include file="../../navbar.asp"-->
<div class="container mt-2 mb-3 px-4 data-detail" style="border-radius:5px;">   
  <div class="row">
    <div class="col-sm-12 text-center mt-3 mb-3">
      <h3>DETAIL KARYAWAN</h3>
    </div>
  </div>
  <div class="row mt-3">
    <div class="col-md-2 image top-50"> 
      <a href="uploadfoto.asp?nip=<%= nip %>">
        <img  id="image" style="max-width:150px;" src="Foto/<%= trim(karyawan("Kry_NIP")) %>.JPG " onerror="this.onerror=null;this.src='Foto/NoPhoto.JPG';"> 
      </a>
    </div>
    <div class="col-md-10">
      <div class="row">
        <div class="col">
          <label>NIP</label>
            <input type=text name="nip" class="form-control" id="nip" value="<%= karyawan("Kry_NIP") %>" disabled>
          <label>Nama</label>
            <input type=text name="nama" class="form-control" id="nama" value="<%= karyawan("Kry_Nama") %>" readonly>
          <label>Alamat</label>
            <input type=text name="Alamat1"  class="form-control" id="Alamat1" value="<%= karyawan("Kry_Addr1") %>" readonly>
          <label>Kelurahan</label>
            <input type=text name="Alamat2"  class="form-control" id="Alamat2" value="<%= karyawan("Kry_Addr2") %>" readonly>
        </div>
        <div class="col">     
          <div class="row">
            <div class="col">
              <div class="form-check form-check-inline">
                <label class="mt-2 mb-1 d-flex flex-row">BPJS KES</label>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="checkbox" id="inlineCheckbox1" <% if karyawan("Kry_BPJSKesYN") = "Y" then %> checked <% end if %> disabled>
                    <label class="form-check-label" for="inlineCheckbox1">Yes</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="checkbox" id="inlineCheckbox2" <% if karyawan("Kry_BPJSKesYN") = "N" then %>checked <% end if %> disabled>           
                    <label class="form-check-label" for="inlineCheckbox2">No</label>
                </div>
              </div>
              <div class="form-check form-check-inline">
                <label class="mt-2 mb-1 d-flex flex-row">BPJS KET</label>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="checkbox" id="inlineCheckbox1" <% if karyawan("Kry_BPJSKetYN") = "Y" then %>   disabled checked <% else %> disabled <% end if %> >
                  <label class="form-check-label" for="inlineCheckbox1">Yes</label>
                </div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="checkbox" id="inlineCheckbox2" <% if karyawan("Kry_BPJSKetYN") = "N" then %>disabled checked <% else %> disabled <% end if %> >           
                  <label class="form-check-label" for="inlineCheckbox2">No</label>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col">
              <label>Telphone 1</label>
              <input type=text class="form-control" name="tlp1" id="tlp1" value="<%= karyawan("Kry_Telp1") %>" readonly>
            </div>
          </div>
          <div class="row">
            <div class="col">
              <label>Telphone 2</label>
              <input type=text class="form-control" name="tlp2" id="tlp2" value="<%= karyawan("Kry_Telp2") %>" readonly>
            </div>
          </div>
          <div class="row">
            <div class="col-6">
              <label>Kota</label>
              <input type=text name="Kota" class="form-control" id="Kota" value="<%= karyawan("Kry_Kota") %>" readonly>
            </div>
            <div class="col-6">
              <label>Pos</label>
              <input type=text class="form-control" name="Pos" id="Pos" value="<%= karyawan("Kry_KdPos") %>" readonly>
            </div>
          </div>
        </div>
      </div>
    </div>        
  </div> 
  <div class="row">
    <div class="col-md-6">
      <div class="row">
        <div class="col-md-8">
          <label>Tempat Lahir</label>
          <input type=text name="tmpl" class="form-control" id="tmpl" value="<%= karyawan("Kry_TmpLahir") %>" readonly>
        </div>
        <div class="col-md-4">
          <label>Tanggal Lahir</label>
          <input type=text name="tglL" class="form-control" id="tglL" value="<%= karyawan("Kry_TglLahir") %>" readonly>
        </div>
      </div>
      <div class="row">
        <div class="col-md-8">
          <label>Email</label>
          <input type=text class="form-control" name="email" id="email" value="<%= karyawan("Kry_Email") %>" readonly>    
        </div>
        <div class="col-md-4">
          <label>Agama</label>
          <% if karyawan("Agama_Nama") = "" then %>
            <input type=text class="form-control" name="Agama" id="Agama" value="" disabled>
          <% else %>
            <input type=text class="form-control" name="Agama" id="Agama" value="<%= karyawan("Agama_Nama") %>" disabled>
          <% end if %>
        </div>
      </div>
      <div class="row">
        <div class="col-md-8">
          <label>Jenis Kelamin</label>
          <% if UCASE(karyawan("Kry_Sex")) = "P" then %>
              <input type=text name="jk" class="form-control" id="jk" value="Pria" disabled>
          <%else %>
              <input type=text name="jk" class="form-control" id="jk" value="Wanita" disabled>
          <%end if %> 
        </div>
        <div class="col-md-4">
          <label>Status Sosial</label>
          <% if karyawan("Kry_SttSosial") = 1 then %> 
            <input type=text name="ssos" class="form-control" id="ssos" value="Belum Menikah" disabled>
          <% elseIf  karyawan("Kry_SttSosial") = 2 then %> 
            <input type=text name="ssos" class="form-control" id="ssos" value="Menikah" disabled>
          <% else %>
            <input type=text name="ssos" class="form-control" id="ssos" value="Janda / Duda" disabled>
          <% end if %>  
        </div>
      </div>
      <div class="row">
          <div class="col-md-6">
              <label>Jumlah Anak</label>
              <input type=text name="janak" class="form-control" id="janak" value="<%= karyawan("Kry_JmlAnak") %>" readonly>
          </div>
          <div class="col-md-6">
              <label>Tanggungan</label>
              <input type=text name="tanggungan" class="form-control" id="tanggungan" value="<%= karyawan("Kry_JmlTanggungan") %>" readonly>
          </div>
      </div>
      <div class="row">
          <div class="col-md-6">
              <label>Pendidikan</label>
              <input type=text name="pendidikan" class="form-control" id="pendidikan" value="<%= karyawan("JDdk_Nama") %>" readonly>
          </div>
          <div class="col-md-6">
              <label>Status Pegawai</label>
              <input type=text name="spegawai" class="form-control" id="spegawai" <% if karyawan("Kry_SttKerja") = 1 then %> value="Borongan" <% elseif karyawan("Kry_SttKerja") = 2 then %> value="Harian" <% elseif karyawan("Kry_SttKerja") = 3 then %> value="Kontrak" <% elseif karyawan("Kry_SttKerja") = 4 then %> value="Magang" <% elseIf karyawan("Kry_SttKerja") = 5 then %> value="Tetap" <% end if %> readonly> 
          </div>
      </div>
      <div class="row">
          <div class="col-md-6">
              <label>Saudara</label>
              <input type=text name="saudara" class="form-control" id="saudara" value="<%= karyawan("Kry_JmlSaudara") %>" readonly>
          </div>
          <div class="col-md-6">
              <label>Anak Ke-</label>
              <input type=text name="anakke" class="form-control" id="anakke" value="<%= karyawan("Kry_AnakKe") %>" readonly>
          </div>
      </div>
      <div class="row">
          <div class="col">
              <label>Bank</label>
              <input type=text name="Bank Id" class="form-control" id="Bank Id" value="<%=karyawan("Bank_name")%>" readonly> 
          </div>
          <div class="col">
              <label>No Rekening</label>
              <input type=text name="Norek" class="form-control" id="Norek" value="<%= karyawan("Kry_NoRekening") %>" readonly>
          </div>
      </div>   
      <div class="row">
          <div class="col">
              <label>BPJS Kesehatan</label>
              <input type=text name="bpjs" class="form-control" id="bpjs" value="<%= karyawan("Kry_NoBPJSKes") %> " readonly>
          </div>
          <div class="col">
              <label>Ketenagakerjaan</label>
              <input type=text name="jamsostek" class="form-control" id="jamsostek" value="<%= karyawan("Kry_NoBPJSKet") %>" readonly>
          </div>
      </div>             
  </div>
  <div class="col-md-6">
    <div class="row">
      <div class="col-6">
        <label>Atasan 1</label>
        <input type="text" name="atasan1" class="form-control" id="atasan1" value="<%= karyawan("Kry_atasanNip1") %>" readonly>
      </div>
      <div class="col-6">
        <label>Atasan 2</label>
        <input type="text" class="form-control" name="atasan2" id="atasan2" value="<%= karyawan("Kry_atasanNip2") %>" readonly>
      </div>
    </div>
    <label>Cabang</label>
      <input type=text name="ActiveId" class="form-control" id="ActiveId" value="<%= karyawan("AgenName") %>" readonly>
    <label>Divisi</label> 
      <input type=text name="Divisi" class="form-control" id="Divisi" value="<%= karyawan("DivNama") %>" readonly>
    <label>Jabatan</label>
      <input type=text name="Jabatan" class="form-control" id="Jabatan" value="<%=karyawan("Jab_Nama")%>" readonly>
    <label>Jenjang</label>
      <input type=text name="Jenjang" class="form-control" id="Jenjang" value="<%= karyawan("JJ_Nama") %>" readonly>
    <label>Departement</label>
      <input type=text name="dep" class="form-control" id="dep" value="<%= karyawan("DepNama") %>" readonly>
    <div class="row">
      <div class="col">
        <label>Jumlah Cuti</label>
        <input type=text name="jcuti" class="form-control" id="jcuti" value="<%= karyawan("Kry_JmlCuti") %>" readonly> 
      </div>
    </div>
    <div class="row">
      <div class="col">
        <label>No KTP</label>
        <input type=text name="nKTP" class="form-control" id="nKTP" value="<%= karyawan("Kry_NoID") %>" readonly>
      </div>
      <div class="col">
        <label>NPWP</label>
        <input type=text name="npwp" class="form-control" id="npwp" value="<%= karyawan("Kry_NPWP") %>" readonly>
        </div>
    </div>
  </div>
  </div>    
  <div class="row">
    <div class="col-lg-4">
      <div class="row">
        <div class="col">
          <label>Tanggal Masuk</label>
          <input type=text name="tglmasuk" class="form-control" id="tglmasuk" value="<%= karyawan("Kry_TglMasuk") %>" readonly>
        </div>
        <div class="col">
          <label>Tanggal Keluar</label>
          <input type= "text" name="tglkeluar" class="form-control" id="tglkeluar" <% if karyawan("Kry_TglKeluar") = "1/1/1900" then %> value="" <% else %> value="<%=karyawan("Kry_TglKeluar")%>" <% end if %> readonly>
        </div>
      </div>
      <div class="row">
        <div class="col">
          <label>Tanggal StartGaji</label>
          <input type="text" name="tglsgaji" class="form-control" id="tglsgaji" <% if karyawan("Kry_TglStartGaji") = "1/1/1900" then %> value="" <% else %> value="<%= karyawan("Kry_TglStartGaji") %>" <% end if %> readonly>
        </div>
        <div class="col">
          <label>Tanggal EndGaji</label>
          <input type="text" name="tglendgaji" class="form-control" id="tglendgaji" <% if karyawan("Kry_TglEndGaji") = "1/1/1900" then %>  value="" <% else %> value="<%= karyawan("Kry_TglEndGaji") %>" <% end if %> readonly>
        </div>
      </div>
    </div>
    <div class="col-lg-4">
      <div class="row">
        <div class="col">
          <label>No SIM</label>
          <input type="text" name="nsim" class="form-control" id="nsim" value="<%= karyawan("Kry_NoSIM") %>" readonly>
        </div>
      </div>
  <div class="row">
    <div class="col">
      <label>Berlaku SIM</label>
      <input type="text" name="berlalkusim" class="form-control" id="berlalkusim" <% if  karyawan("Kry_SIMValidDate") = "1/1/1900" then %> value="" <% else %> value="<%= karyawan("Kry_SIMValidDate") %>" <% end if %> readonly>
    </div>
      <div class="col">
        <label>Jenis SIM</label>    
        <% if karyawan("Kry_JnsSIM") = "0" then%> 
          <input type="text" name="jsim" class="form-control" id="jsim" value="A" readonly>
        <% elseIf karyawan("Kry_JnsSIM") = "1" then %> 
          <input type="text" name="jsim" class="form-control" id="jsim" value="B1"readonly>
        <% elseIf karyawan("Kry_JnsSIM") = "2" then %> 
          <input type="text" name="jsim" class="form-control" id="jsim" value="B1 UMUM" readonly>
        <% elseIf karyawan("Kry_JnsSIM") = "3" then %> 
          <input type="text" name="jsim" class="form-control" id="jsim" value="A UMUM" readonly>
        <% elseIf karyawan("Kry_JnsSIM") = "4" then %> 
          <input type="text" name="jsim" class="form-control" id="jsim" value="B2 UMUM" readonly>	
        <% elseIf karyawan("Kry_JnsSIM") = "5" then %> 
          <input type="text" name="jsim" class="form-control" id="jsim" value="C" readonly>	
        <% else %>
          <input type="text" name="jsim" class="form-control" id="jsim" value="" readonly>
        <% end if %> 
      </div>
    </div>
  </div>
  <div class="col">
    <div class="row">
      <div class="col">
        <label>Jenis Vaksin</label>
        <input type="text" name="vaksin" class="form-control" id="vaksin" <%if not karyawan.eof then%> value="<%= karyawan("Kry_JenisVaksin") %>" <%else%> value="" <%end if%> readonly>
      </div>
    </div>
    <div class="row">
      <div class="col-6">
        <label>Golongan Darah</label>
        <input type="text" name="goldarah" class="form-control" id="goldarah" <%if not karyawan.eof then%> value="<%= karyawan("Kry_golDarah") %>" <%else%> value="" <%end if%> readonly>
      </div>
    </div>
  </div>
  </div>  
  <div class="row mt-3 p-2 ">  
    <div class="col-lg-3 mt-3 " >
      <a href="index.asp" name="kembali" id="kembali"><button type="button" class="btn btn-danger kembali">Kembali</button></a>
      <% if session("HR5B") = true then %>
        <button type="button" class="btn btn-warning update-krywn" name="update-krywn" id="update-krywn" onclick="window.location='kry_u.asp?nip=<%=nip%>'">Update</button>
      <% end if %>
    </div>
  </div>
<% call footer() %>