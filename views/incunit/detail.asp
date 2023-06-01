<!--#include file="../../init.asp"-->
<% 
  id = trim(Request.QueryString("id"))
  set data_cmd =  Server.CreateObject ("ADODB.Command")
  data_cmd.ActiveConnection = mm_delima_string
  ' header
  data_cmd.commandText = "SELECT DLK_T_IncRepairH.*, GLB_M_Agen.AgenName, DLK_M_Customer.custnama FROM DLK_T_IncRepairH LEFT OUTER JOIN GLB_M_Agen ON DLK_T_IncRepairH.IRH_AgenID = GLB_M_Agen.Agenid LEFT OUTER JOIN DLK_M_Customer ON LEFT(DLK_T_IncRepairH.IRH_TFKID,11) = DLK_M_Customer.custid WHERE DLK_T_IncRepairH.IRH_aktifYN = 'Y' AND IRH_ID = '"& id &"'"
  set data = data_cmd.execute

  ' detail
  data_cmd.commandTExt = "SELECT DLK_T_IncRepairD.*, DLK_M_Weblogin.username FROM DLK_T_IncRepairD LEFT OUTER JOIN DLK_M_Weblogin ON DLK_T_IncRepairD.IRD_Updateid = DLK_M_Weblogin.userid WHERE LEFT(IRD_IRHID,13) = '"& data("IRH_ID") &"' ORDER BY IRD_IRHID"
  set ddata = data_cmd.execute

  call header("Detail Incomming Unit") 
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
      <h3>DETAIL INCOMMING UNIT INSPECTION</h3>
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
      <input type="text" id="" name="tfkid" class="form-control" value="<%= LEFT(data("IRH_TFKID"),11) &"/"& MID(data("IRH_TFKID"),12,4) &"/"& MID(data("IRH_TFKID"),16,2) &"/"& right(data("IRH_TFKID"),3) %>" onclick="window.open('<%=url%>views/serteruni/detailD1.asp?id=<%= data("IRH_TFKID")%>&tfk_u')" style="cursor:pointer" readonly>
    </div>
    <div class="col-lg-2 mb-2">
      <label for="customer" class="col-form-label">Customer</label>
    </div>
    <div class="col-lg-4 mb-2">
      <input type="text" id="" name="customer" class="form-control" value="<%= data("custnama") %>" readonly>
    </div>
  </div>
  <div class="row align-items-center">
    <div class="col-lg-2 mb-2">
      <label for="startdate" class="col-form-label">Start Date</label>
    </div>
    <div class="col-lg-4 mb-2">
      <input type="text" id="startdate" name="startdate" class="form-control" value="<%= Cdate(data("IRH_Startdate")) %>" readonly>
    </div>
    <div class="col-lg-2 mb-2">
      <label for="enddate" class="col-form-label">End Date</label>
    </div>
    <div class="col-lg-4 mb-2">
      <input type="text" id="enddate" name="enddate" class="form-control" value="<%= Cdate(data("IRH_Enddate")) %>" readonly>
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
      <%if data("IRH_Img1") <> "" then%>
        <div class="position-absolute top-50 start-50 translate-middle">
          <img src="<%= url %>views/incunit/img/<%= data("IRH_IMG1") %>.jpg" class="rounded" alt="<%= data("IRH_Img1") %>">
        </div>
      <%end if%>
    </div>
    <div class="col-md mx-1 mb-3 position-relative generaPictured">
      <%if data("IRH_Img2") <> "" then%>
        <div class="position-absolute top-50 start-50 translate-middle">
          <img src="<%= url %>views/incunit/img/<%= data("IRH_IMG2") %>.jpg" class="rounded" alt="<%= data("IRH_Img1") %>">
        </div>
      <%end if%>
    </div>
    <div class="col-md mx-1 mb-3 position-relative generaPictured">
      <%if data("IRH_Img3") <> "" then%>
        <div class="position-absolute top-50 start-50 translate-middle">
          <img src="<%= url %>views/incunit/img/<%= data("IRH_IMG3") %>.jpg" class="rounded" alt="<%= data("IRH_Img1") %>">
        </div>
      <%end if%>
    </div>
    <div class="col-md mx-1 mb-3 position-relative generaPictured">
      <%if data("IRH_Img4") <> "" then%>
        <div class="position-absolute top-50 start-50 translate-middle">
          <img src="<%= url %>views/incunit/img/<%= data("IRH_IMG4") %>.jpg" class="rounded" alt="<%= data("IRH_Img1") %>">
        </div>
      <%end if%>
    </div>
    <div class="col-md mx-1 mb-3 position-relative generaPictured">
      <%if data("IRH_Img5") <> "" then%>
        <div class="position-absolute top-50 start-50 translate-middle">
          <img src="<%= url %>views/incunit/img/<%= data("IRH_IMG5") %>.jpg" class="rounded" alt="<%= data("IRH_Img1") %>">
        </div>
      <%end if%>
    </div>
  </div>
  <div class="row">
    <div class="col-lg-12 mb-3 mt-3 text-center d-flex justify-content-between">
      <%if session("MQ4D") = true then%>
      <button type="button" class="btn btn-secondary" onclick="window.open('export-xlsincunit.asp?id=<%=data("IRH_ID")%>', '_self')">Export</button>
      <%end if%>
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
                <div class="position-relative" style="heigth:5rem">
                  <% if ddata("IRD_Img") <> "" then %>
                    <div class="z-n1 position-absolute top-50 start-50 translate-middle">
                      <img src="<%= url %>/views/incunit/img/<%= ddata("IRD_Img") %>.jpg" width="80" height="100">
                    </div>
                  <%end if%>
                </div>
              </td>
              <td>
                <%= ddata("IRD_Description") %>
              </td>
              <td>
                <%= ddata("IRD_Remarks")%>
              </td>
              <td>
                <%= ddata("username")%>
              </td>
            </tr>
          <% 
          response.flush
          ddata.movenext
          loop
          %>
        </tbody>
      </table>
    </div>    
  </div>   
</div>
<% call footer() %>