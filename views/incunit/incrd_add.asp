<!--#include file="../../init.asp"-->
<!--#include file="../../functions/func_incomingunitrepair.asp"-->
<% 
  if (session("MQ4A") = false  OR session("MQ4A") = "") AND (session("MQ4B") = false OR session("MQ4B") = "") then
    Response.Redirect("./")
  end if

  id = trim(Request.QueryString("id"))
  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string
  ' header
  data_cmd.commandText = "SELECT DLK_T_IncRepairH.*, GLB_M_Agen.AgenName, DLK_M_Customer.custnama FROM DLK_T_IncRepairH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_IncRepairH.IRH_AgenID = GLB_M_Agen.Agenid LEFT OUTER JOIN DLK_M_Customer ON LEFT(DLK_T_IncRepairH.IRH_TFKID,11) = DLK_M_Customer.custid WHERE DLK_T_IncRepairH.IRH_aktifYN = 'Y' AND IRH_ID = '"& id &"'"
  set data = data_cmd.execute

  ' detail
  data_cmd.commandTExt = "SELECT DLK_T_IncRepairD.*, DLK_M_Weblogin.username FROM DLK_T_IncRepairD LEFT OUTER JOIN DLK_M_Weblogin ON DLK_T_IncRepairD.IRD_Updateid = DLK_M_Weblogin.userid WHERE LEFT(IRD_IRHID,13) = '"& data("IRH_ID") &"' ORDER BY IRD_IRHID"
  set ddata = data_cmd.execute

  call header("Form Incomming Unit") 
%>
<style>
  .generaPictured{
    background: radial-gradient(circle at 10% 20%, rgba(216, 241, 230, 0.46) 0.1%, rgba(233, 226, 226, 0.28) 90.1%);
    border-radius:10px;
    height:11rem;
    overflow :hidden;
  }

  .generaPictured img{
    max-width:250px;
   
  }

  .generaPictured .uploadUlangIncrd{
    z-index:1000;
  }

  .generaPictureIncrd .generaPictured span{
    font-size:14px;
    cursor:pointer;
  }
  .btnUploadIncrd{
    position:relative;
    font-size:12px;
    border-radius:3px;
    color:#fff;
    overflow:hidden;
    border:0;
    padding:8px;
    line-height:1.5;

  }
  .btnUploadIncrd i{
    font-size:14px;
  }
  .btnUploadIncrd input[type="file"]{
    cursor:pointer;
    position:absolute;
    transform:scale(1.5);
    top: 15%;
    left: 50%;
    opacity:0;
  }
  .btnsubmitincrd{
    position:absolute
    bottom:0%;
  }

  .btnUploadUlangIncrd{
    position:relative;
    font-size:12px;
    border-radius:3px;
    overflow:hidden;
    border:0;
    padding:8px;
    line-height:1.5;
    background:transparent;
    transition: box-shadow 0.6s linear;
    mix-blend-mode: difference;
  }

  .btnUploadUlangIncrd:hover{
    box-shadow: 0px 0px 0px 2px black;
    mix-blend-mode: difference;
  }
  .btnUploadUlangIncrd i{
    font-size:14px;
  }
  .btnUploadUlangIncrd input[type="file"]{
    cursor:pointer;
    position:absolute;
    transform:scale(1.5);
    top: 15%;
    left: 50%;
    opacity:0;
  }
  .tblIncrd tbody tr td{
    height:8rem;
    vertical-align:middle;
  }
  .tblIncrd tbody tr td input[type="file"]{
    width:4.5rem;
    position:absolute;
    opacity:0;
    cursor:pointer;
  }
</style>
<!--#include file="../../navbar.asp"-->
<div class="container">
  <div class="row">
    <div class="col-sm-12 mt-3 text-center">
      <h3>FORM INCOMMING UNIT INSPECTION</h3>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-12 mb-3 text-center labelId">
      <h3><%= LEFT(data("IRH_ID"),4) &"-"& mid(data("IRH_ID"),5,3) &"/"& mid(data("IRH_ID"),8,4) &"/"& right(data("IRH_ID"),2) %></h3>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-2">
      <label for="" class="col-form-label">Tanggal</label>
    </div>
    <div class="col-lg-4 mb-2">
      <input type="text" id="" name="" value="<%= data("IRH_Date") %>" class="form-control" readonly>
    </div>
    <div class="col-lg-2 mb-2">
      <label for="" class="col-form-label">Cabang</label>
    </div>
    <div class="col-lg-4 mb-2">
      <input type="text" id="" name="" value="<%= data("agenname") %>" class="form-control" readonly>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-2">
      <label for="tfkid" class="col-form-label">No.Penerimaan Unit</label>
    </div>
    <div class="col-lg-4 mb-2">
      <input type="text" id="" name="tfkid" class="form-control" value="<%= LEFT(data("IRH_TFKID"),11) &"/"& MID(data("IRH_TFKID"),12,4) &"/"& MID(data("IRH_TFKID"),16,2) &"/"& right(data("IRH_TFKID"),3) %>" onclick="window.open('<%=url%>views/serteruni/detailD1.asp?id=<%= data("IRH_TFKID")%>&p=tfkd_u')" style="cursor:pointer" readonly>
    </div>
    <div class="col-lg-2 mb-2">
      <label for="customer" class="col-form-label">Customer</label>
    </div>
    <div class="col-lg-4 mb-2">
      <input type="text" id="" name="customer" class="form-control" value="<%= data("custnama") %>" readonly>
    </div>
  </div>
 
  <div class="row">
    <div class="col-lg-2 mb-2">
      <label for="keterangan" class="col-form-label">Keterangan</label>
    </div>
    <div class="col-lg-10 mb-2">
      <input type="text" id="keterangan" name="keterangan" class="form-control" maxlength="50" autocomplete="off" value="<%= data("IRH_Keterangan") %>" readonly>
    </div>
  </div>
  <div class="row">
    <div class="col-sm-12 text-center mb-3 mt-3">
      <h5>GENERAL PICTURE</h5>
    </div>  
  </div>
  <div class="row d-flex justify-content-between generaPictureIncrd">
    <div class="col-md mx-1 mb-3 position-relative generaPictured">
      <form action="uploadGeneralpicture.asp?id=<%= data("IRH_ID")&"A" %>&pathidh=<%= data("IRH_ID")%>" method="post" onsubmit="validasiGPicture(this)" enctype="multipart/form-data">
        <%if data("IRH_Img1") = "" then%>
          <%if session("MQ4E") = true then%>
          <div class="position-absolute top-50 start-50 translate-middle">
            <button type="button" class="bg-warning btnUploadIncrd">
              <i class="bi bi-folder-plus"></i> Upload File
              <input type="file" accept="image/*;capture=camera" name="imgIncrd" id="imgIncrdA" onchange="getNameFileIncr(this.value,'imgIncrdA')">
            </button>
          </div>
          <div class="position-absolute bottom-0 start-50 translate-middle-x submitIncrdA" style="margin-bottom:10px;">
            <!-- konten button submit -->
          </div>
          <%end if%>
        <%else%>
          <%if session("MQ4E") = true then%>
          <div class="position-absolute top-50 start-50 translate-middle uploadUlangIncrd">
            <button type="button" class="btnUploadUlangIncrd">
              <i class="bi bi-folder-plus"></i> Upload File
              <input type="file" accept="image/*;capture=camera" name="imgIncrd" id="imgIncrdA" onchange="getNameFileIncr(this.value,'imgIncrdA')">
            </button>
          </div>
          <div class="position-absolute bottom-0 start-50 translate-middle-x submitIncrdA" style="margin-bottom:10px;z-index:1000;">
            <!-- konten button submit -->
          </div>
          <%end if%>
          <div class="position-absolute top-50 start-50 translate-middle">
            <img src="<%= getpathdoc %>/<%= data("IRH_ID") %>/<%= data("IRH_IMG1") %>.jpg" class="rounded" alt="<%= data("IRH_Img1") %>">
          </div>
        <%end if%>
      </form>
    </div>
    <div class="col-md mx-1 mb-3 position-relative generaPictured">
      <form action="uploadGeneralpicture.asp?id=<%= data("IRH_ID")&"B" %>&pathidh=<%= data("IRH_ID")%>" method="post" onsubmit="validasiGPicture(this)" enctype="multipart/form-data">
        <%if data("IRH_Img2") = "" then%>
          <%if session("MQ4E") = true then%>
          <div class="position-absolute top-50 start-50 translate-middle">
            <button type="button" class="bg-warning btnUploadIncrd">
              <i class="bi bi-folder-plus"></i> Upload File
              <input type="file" accept="image/*;capture=camera" name="imgIncrd" id="imgIncrdB" onchange="getNameFileIncr(this.value,'imgIncrdB')">
            </button>
          </div>
          <div class="position-absolute bottom-0 start-50 translate-middle-x submitIncrdB" style="margin-bottom:10px">
            <!-- konten button submit -->
          </div>
          <%end if%>
        <%else%>
          <%if session("MQ4E") = true then%>
          <div class="position-absolute top-50 start-50 translate-middle uploadUlangIncrd">
            <button type="button" class="btnUploadUlangIncrd">
              <i class="bi bi-folder-plus"></i> Upload File
              <input type="file" accept="image/*;capture=camera" name="imgIncrd" id="imgIncrdB" onchange="getNameFileIncr(this.value,'imgIncrdB')">
            </button>
          </div>
          <div class="position-absolute bottom-0 start-50 translate-middle-x submitIncrdB" style="margin-bottom:10px;z-index:1000;">
            <!-- konten button submit -->
          </div>
          <%end if%>
          <div class="position-absolute top-50 start-50 translate-middle">
            <img src="<%= getpathdoc %>/<%= data("IRH_ID") %>/<%= data("IRH_IMG2") %>.jpg" class="rounded" alt="<%= data("IRH_Img1") %>">
          </div>
        <%end if%>
      </form>
    </div>
    <div class="col-md mx-1 mb-3 position-relative generaPictured">
      <form action="uploadGeneralpicture.asp?id=<%= data("IRH_ID")&"C" %>&pathidh=<%= data("IRH_ID")%>" method="post" onsubmit="validasiGPicture(this)" enctype="multipart/form-data">
        <%if data("IRH_Img3") = "" then%>
          <%if session("MQ4E") = true then%>
          <div class="position-absolute top-50 start-50 translate-middle">
            <button type="button" class="bg-warning btnUploadIncrd">
              <i class="bi bi-folder-plus"></i> Upload File
              <input type="file" accept="image/*;capture=camera" name="imgIncrd" id="imgIncrdC" onchange="getNameFileIncr(this.value,'imgIncrdC')">
            </button>
          </div>
          <div class="position-absolute bottom-0 start-50 translate-middle-x submitIncrdC" style="margin-bottom:10px">
            <!-- konten button submit -->
          </div>
          <%end if%>
        <%else%>
          <%if session("MQ4E") = true then%>
          <div class="position-absolute top-50 start-50 translate-middle uploadUlangIncrd">
            <button type="button" class="btnUploadUlangIncrd">
              <i class="bi bi-folder-plus"></i> Upload File
              <input type="file" accept="image/*;capture=camera" name="imgIncrd" id="imgIncrdC" onchange="getNameFileIncr(this.value,'imgIncrdC')">
            </button>
          </div>
          <div class="position-absolute bottom-0 start-50 translate-middle-x submitIncrdC" style="margin-bottom:10px;z-index:1000;">
            <!-- konten button submit -->
          </div>
          <%end if%>
          <div class="position-absolute top-50 start-50 translate-middle">
            <img src="<%= getpathdoc %>/<%= data("IRH_ID") %>/<%= data("IRH_IMG3") %>.jpg" class="rounded" alt="<%= data("IRH_Img1") %>">
          </div>
        <%end if%>
      </form>
    </div>
    <div class="col-md mx-1 mb-3 position-relative generaPictured">
      <form action="uploadGeneralpicture.asp?id=<%= data("IRH_ID")&"D" %>&pathidh=<%= data("IRH_ID")%>" method="post" onsubmit="validasiGPicture(this)" enctype="multipart/form-data">
        <%if data("IRH_Img4") = "" then%>
          <%if session("MQ4E") = true then%>
          <div class="position-absolute top-50 start-50 translate-middle">
            <button type="button" class="bg-warning btnUploadIncrd">
              <i class="bi bi-folder-plus"></i> Upload File
              <input type="file" accept="image/*;capture=camera" name="imgIncrd" id="imgIncrdD" onchange="getNameFileIncr(this.value,'imgIncrdD')">
            </button>
          </div>
          <div class="position-absolute bottom-0 start-50 translate-middle-x submitIncrdD" style="margin-bottom:10px">
            <!-- konten button submit -->
          </div>
          <%end if%>
        <%else%>
          <%if session("MQ4E") = true then%>
          <div class="position-absolute top-50 start-50 translate-middle uploadUlangIncrd">
            <button type="button" class="btnUploadUlangIncrd">
              <i class="bi bi-folder-plus"></i> Upload File
              <input type="file" accept="image/*;capture=camera" name="imgIncrd" id="imgIncrdD" onchange="getNameFileIncr(this.value,'imgIncrdD')">
            </button>
          </div>
          <div class="position-absolute bottom-0 start-50 translate-middle-x submitIncrdD" style="margin-bottom:10px;z-index:1000;">
            <!-- konten button submit -->
          </div>
          <%end if%>
          <div class="position-absolute top-50 start-50 translate-middle">
            <img src="<%= getpathdoc %>/<%= data("IRH_ID") %>/<%= data("IRH_IMG4") %>.jpg" class="rounded" alt="<%= data("IRH_Img1") %>">
          </div>
        <%end if%>
      </form>
    </div>
    <div class="col-md mx-1 mb-3 position-relative generaPictured">
      <form action="uploadGeneralpicture.asp?id=<%= data("IRH_ID")&"E" %>&pathidh=<%= data("IRH_ID")%>" method="post" onsubmit="validasiGPicture(this)" enctype="multipart/form-data">
        <%if data("IRH_Img5") = "" then%>
          <%if session("MQ4E") = true then%>
          <div class="position-absolute top-50 start-50 translate-middle">
            <button type="button" class="bg-warning btnUploadIncrd">
              <i class="bi bi-folder-plus"></i> Upload File
              <input type="file" accept="image/*;capture=camera" name="imgIncrd" id="imgIncrdE" onchange="getNameFileIncr(this.value,'imgIncrdE')">
            </button>
          </div>
          <div class="position-absolute bottom-0 start-50 translate-middle-x submitIncrdE" style="margin-bottom:10px">
            <!-- konten button submit -->
          </div>
          <%end if%>
        <%else%>
          <%if session("MQ4E") = true then%>
          <div class="position-absolute top-50 start-50 translate-middle uploadUlangIncrd">
            <button type="button" class="btnUploadUlangIncrd">
              <i class="bi bi-folder-plus"></i> Upload File
              <input type="file" accept="image/*;capture=camera" name="imgIncrd" id="imgIncrdE" onchange="getNameFileIncr(this.value,'imgIncrdE')">
            </button>
          </div>
          <div class="position-absolute bottom-0 start-50 translate-middle-x submitIncrdE" style="margin-bottom:10px;z-index:1000;">
            <!-- konten button submit -->
          </div>
          <%end if%>
          <div class="position-absolute top-50 start-50 translate-middle">
            <img src="<%= getpathdoc %>/<%= data("IRH_ID") %>/<%= data("IRH_IMG5") %>.jpg" class="rounded" alt="<%= data("IRH_Img1") %>">
          </div>
        <%end if%>
      </form>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 mt-3 text-center d-flex justify-content-between">
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalincrd">Tambah Rincian</button>
      <a href="./" type="button" class="btn btn-danger">Kembali</a>
    </div>
  </div>

  <div class="row">
    <div class="col-lg-12">
      <table class="table table-hover tblIncrd" width="100">
        <thead class="bg-secondary text-light">
          <tr>
            <th scope="col" style="width:20px;">No</th>
            <th scope="col">Image</th>
            <th scope="col">Descripsi</th>
            <th scope="col">Remarks</th>
            <th scope="col">Update Name</th>
            <th scope="col" class="text-center">Aksi</th>
          </tr>
        </thead>
        <tbody>
          <% 
          no = 0
          do while not ddata.eof 
          no = no + 1
          %>
            <tr>
              <td class="p-0 m-0 text-center">
                <%= no  %>
              </td>
              <td>
              <form action="setdetailomg.asp?id=<%= ddata("IRD_IRHID") %>&pathidh=<%=data("IRH_ID")%>" method="post" onsubmit="validasiGPicture(this)" enctype="multipart/form-data">
                <div class="position-relative" style="heigth:5rem">
                  <% if ddata("IRD_Img") <> "" then %>
                    <div class="z-n1 position-absolute top-50 start-50 translate-middle">
                      <img src="<%= getpathdoc %>/<%= data("IRH_ID") %>/<%= ddata("IRD_Img") %>.jpg" id="imgDetailIncrd" width="80" height="100">
                    </div>
                    <%if session("MQ4E") = true then%>
                    <div class="position-absolute top-50 start-50 translate-middle">
                      <input type="file" name="dimgincrd" accept="image/*;capture=camera" id="dimgincrd<%=ddata("IRD_IRHID")%>" onchange="uploadDetailIncrd(this.value, 'dimgincrd<%=ddata("IRD_IRHID")%>', 'btnUploadDetailIncrd<%=ddata("IRD_IRHID")%>', 'btnPostingDetailIncrd<%=ddata("IRD_IRHID")%>')">
                      <!-- button upload -->
                      <button type="button" class="btn btn-outline-light btnUploadDetailIncrd<%=ddata("IRD_IRHID")%>" style="--bs-btn-font-size: .75rem;">
                       Upload
                      </button>
                    </div>
                    <%end if%>
                  <%else%>
                    <%if session("MQ4E") = true then%>
                    <div class="position-absolute top-50 start-50 translate-middle">
                      <input type="file" name="dimgincrd" accept="image/*;capture=camera" id="dimgincrd<%=ddata("IRD_IRHID")%>" onchange="uploadDetailIncrd(this.value, 'dimgincrd<%=ddata("IRD_IRHID")%>', 'btnUploadDetailIncrd<%=ddata("IRD_IRHID")%>', 'btnPostingDetailIncrd<%=ddata("IRD_IRHID")%>')">
                      <!-- button upload -->
                      <button type="button" class="btn btn-warning btnUploadDetailIncrd<%=ddata("IRD_IRHID")%>" style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;">
                        Upload
                      </button>
                    </div>
                    <%end if%>
                  <%end if%>
                  <%if session("MQ4E") = true then%>
                  <div class="position-absolute bottom-0 start-50 translate-middle-x">
                    <button type="submit" class="btn btn-light btnPostingDetailIncrd<%=ddata("IRD_IRHID")%>" style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;display:none">
                      Posting
                    </button>
                  </div>
                  <%end if%>
                </div>
                </form>
              </td>
              <td style="white-space: normal !important;padding-left:30px; ">
                <%= ddata("IRD_Description") %>
              </td>
              <td  style="white-space: normal !important; ">
                <%= ddata("IRD_Remarks")%>
              </td>
              <td>
                <%= ddata("username")%>
              </td>
              <td class="text-center">
                <% if session("MQ4C") = true then %>
                <div class="btn-group" role="group" aria-label="Basic example">
                <a href="aktifd.asp?id=<%= ddata("IRD_IRHID") %>" class="btn badge text-bg-danger" onclick="deleteItem(event,'Detail kerusakan')">Delete</a>
                <% end if %>
              </td>
            </tr>
          <% 
          Response.flush
          ddata.movenext
          loop
          %>
        </tbody>
      </table>
    </div>    
  </div>   
</div>


<!-- Modal -->
<div class="modal fade" id="modalincrd" tabindex="-1" aria-labelledby="modalincrdLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="modalincrdLabel">Detail Kondisi</h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form action="incrd_add.asp?id=<%= data("IRH_ID") %>" method="post" onsubmit="validasiForm(this,event,'DETAIL KERUSAKAN','warning')">
          <input type="hidden" name="id" value="<%= data("IRH_ID") %>">
          <div class="row">
            <div class="col-md-2 mb-3">
              <label for="descripsi" class="form-label">Descripsi</label>
            </div>
            <div class="col-md mb-3">
              <textarea class="form-control" id="descripsi" style="height: 50px" name="descripsi" maxlength="50" required></textarea>
            </div>
          </div>
          <div class="row">
            <div class="col-md-2 mb-3">
              <label for="remarks" class="form-label">Remarks</label>
            </div>
            <div class="col-md mb-3">
              <textarea class="form-control" id="remarks" style="height: 50px" name="remarks" maxlength="300" ></textarea>
            </div>
          </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary">Save</button>
      </div>
    </div>
        </form>
  </div>
</div>
<% 
  if Request.ServerVariables("REQUEST_METHOD") = "POST" then
    call detailTambah()
  end if
call footer() %>