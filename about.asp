<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delima Karoseri Indonesia</title>
  <link href='public/img/delimalogo.png' rel='website icon' type='png' />
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;300;400;700&display=swap" rel="stylesheet">
  <link href="assets/js/aos-master/dist/aos.css" rel="stylesheet">
  <link href="public/css/bootstrap.min.css" rel="stylesheet" />
  <script src="public/js/bootstrap.bundle.min.js"></script>
  <link rel="stylesheet" href="assets/css/style.css">
  <style>
    .hero-about{
      background-image: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url("assets/img/heroabout.png");
      height: 70vh;
      background-position: center;
      background-attachment: fixed;
      background-repeat: no-repeat;
      background-size: cover;
      position: relative;
      color:#fff;
    }
    .txt-about-history{
      color: #fff;
      font-size: 30px;
      background: linear-gradient(225deg, transparent 0, transparent 50px, #32554A 0, #565453 100%);
      padding: 10px 10px 10px 10px;
      text-align: center;
      display: inline-block;
      letter-spacing: 10px
    }
    .history-desc .list-group .list-group-item{
      color:#fff;
      border:none;
      background:transparent;
      padding-left:0;
      padding-top:0;
    }
    .title-visimisi{
      padding:10px;
      background: linear-gradient(30deg,rgb(0, 0, 0) 2%,rgba(255, 255, 255, 0) 30%);
      height:10em;
      border-radius:10px;
    }
    .title-visimisi-right{
      padding:10px;
      background: linear-gradient(40deg,rgba(255, 255, 255, 0) 45%,rgb(0, 0, 0) 100%);
      height:10em;
      border-radius:10px
    }
    .text-visimisi{
      font-weight:600;
      font-size:21px;
      mix-blend-mode: hard-light;
    }
    .title-visimisi {
      color:#ff5e14;
    }
    .title-visimisi-right {
      color:#ff5e14;
    } 
    .title-visimisi-right .list-group-item {
      color:#CFBE00;
    } 
    .our-tools-about{
      background-image: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url("assets/img/settingzig.jpeg");
      height: 45vh;
      background-position: center;
      background-attachment: fixed;
      background-repeat: no-repeat;
      background-size: cover;
      position: relative;
      color:#fff;
      position:relative;
    }
    .our-tools-about h3{
      padding-top:2em;
    }
    .our-tools-about h3::before{
      content: "";
      position: absolute;
      top:3.5em;
      height: 2px;
      width: 5.7em;
      background: #ff5e14;
    }
    .list-tools-about {
      width: 15rem;
      height: 12rem;
      box-shadow: 0 0 1rem 0 rgba(0, 0, 0, .2); 
      border-radius: 5px;
      position: relative;
      z-index: 1;
      background: inherit;
      overflow: hidden;
      margin:auto;
    }

    .list-tools-about:before {
      content: "";
      position: absolute;
      background: inherit;
      z-index: -1;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      box-shadow: inset 0 0 2000px rgba(255, 255, 255, .5);
      filter: blur(10px);
      margin: -20px;
    }
    @media only screen and (max-width: 768px) {
      /* For mobile phones: */
      .hero-about {
        height: 90vh;
        background-size: cover;
      }
      .history-desc p{
        font-size:12px;
        line-height: 20px;
      }
      .history-desc .list-group{
        font-size:12px;
        line-height: 10px;
      }
    }
    /* For Tablet View */
    @media screen and (min-device-width: 768px)
        and (max-device-width: 1024px) {
        .hero-about {
          height: 90.5vh;
        }
        .history-desc p{
          font-size:16px;
          line-height: 1cm;
        }
        .history-desc .list-group{
          font-size:16px;
          line-height: 1cm;
        }
    }
  </style>
</head>
<body>
  <div class='header'>
    <nav class="navbar navbar-expand-lg bg-body p-0">
      <div class="container-fluid p-3">
        <a class="navbar-brand mx-3" href="./">
          <img src="assets/img/delimalogo.png" alt="delimalogo" width="55">
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
          <ul class="navbar-nav me-auto mb-2 mb-lg-0">
            <li class="nav-item">
              <a class="nav-link fw-bold" aria-current="page" href="./">Home</a>
            </li>
            <li class="nav-item">
              <a class="nav-link fw-bold" aria-current="page" href="./about.asp">About</a>
            </li>
            <li class="nav-item">
              <a class="nav-link fw-bold" aria-current="page" href="./product.asp">Product</a>
            </li>
            <li class="nav-item">
              <a class="nav-link fw-bold" aria-current="page" href="./news.asp">News</a>
            </li>
          </ul>
        </div>
      </div>
    </nav>
  </div>

  <div class='hero-about'>
    <div class='col-md-2 mx-4 txt-about-history' data-aos="fade-right">
      <h2 class="fw-bold">HISTORY</h2>
    </div>
    <div class='container'>
      <div data-aos="fade-down" class='row history-desc mt-4'>
        <div class='col-md-1'>
          <h5 class="fw-bold">1990</h5>
        </div>
        <div class='col-md-11 mb-3'>
          <p>16 years before DKI established, Mr. Deni Ariijanto, later becomes the Founder & President Director of DKI, starts Logistics Cargo (PT. Dakota Buana Semesta) for local market.</p>
        </div>
      </div>
      <div data-aos="fade-down" class='row history-desc'>
        <div class='col-md-1'>
          <h5 class="fw-bold">2012</h5>
        </div>
        <div class='col-md-11 mb-3'>
          <p>Start Repair Body and Painting Logistic Vehicle (Box Truck) for Dakota 2012 Company.</p>
        </div>
      </div>
      <div data-aos="fade-down" class='row history-desc'>
        <div class='col-md-1'>
          <h5 class="fw-bold">2016</h5>
        </div>
        <div class='col-md-11 mb-3'>
          <ul class="list-group">
            <li class="list-group-item">Acuitition CV. Delima</li>
            <li class="list-group-item">Building Box Small Vehicle</li>
            <li class="list-group-item">Building Box For Motorcycle</li>
            <li class="list-group-item">Building Box Trucks for Dakota Company</li>
          </ul>
        </div>
      </div>
      <div data-aos="fade-down" class='row history-desc'>
        <div class='col-md-1'>
          <h5 class="fw-bold">2017</h5>
        </div>
        <div class='col-md-11 mb-3'>
          <ul class="list-group">
            <li class="list-group-item">Estabilsh PT. Delima Karoseri Indonesia</li>
            <li class="list-group-item">Building Bus Goverment</li>
            <li class="list-group-item">Building Ambulance (Hilux, Triton, Hino)</li>
            <li class="list-group-item">Building Incenerator Trucks (BNN)</li>
            <li class="list-group-item">Building Infrastuktur Plant</li>
            <li class="list-group-item">Bought New Machine Shearing & Bending</li>
            <li class="list-group-item">Building Wing Box Trucks for Dakota Company</li>
            <li class="list-group-item"> Show Up at GIICOMVEC 2018 (JCC – Jakarta)</li>
          </ul>
        </div>
      </div>
    </div>
  </div>

  <div class='container'>
    <div class='row' data-aos="fade-right">
      <div class='col-md-12 title-visimisi mb-3 mt-5 '>
        <h2 class="fw-bold text-light ">Vision</h2>
        <p class="text-visimisi">Becomes the Company's first choice customer's Caroserrie</p>
      </div>
    </div>
    <div class='row'>
      <div class='col-md-12 title-visimisi-right mb-3 text-end' data-aos="fade-left">
        <h2 class="fw-bold text-light">Mission</h2>
        <p class="text-visimisi">We are Continuously improving & developing</p>
        <ul class="list-group">
          <li class="list-group-item border-0 p-0 transparent">
            Our Capabilities In Providing proper Quality Vihicle Body To Our Customers
          </li>
          <li class="list-group-item border-0 p-0 transparent">
            Mutual Relationship To Our Customers, Employees, Vendors, Business Partners, Community & Other Stake Holders
          </li>
        </ul>
      </div>
    </div>
    <div class='row'>
      <div class='col-md-12 title-visimisi mb-3' data-aos="fade-right">
        <h2 class="fw-bold text-light">Filosofy</h2>
        <p class="text-visimisi">Continues improvement of product's</p>
      </div>
    </div>
    <div class='row'>
      <div class='col-md-12 title-visimisi-right mb-3 text-end' data-aos="fade-left">
        <h2 class="fw-bold text-light">Policy</h2>
        <p class="text-visimisi">People & technology working together</p>
      </div>
    </div>
       
  </div>

  <div class='col-md-12 mb-3 mt-3 our-tools-about'>
    <h3 class="text-center fw-bold">OUR TOOLS</h3>
    <div class='listpartner mt-5'>
      <ul class="list-group list-group-horizontal">
        <li class="list-group-item list-tools-about my-auto" data-aos-duration="800" data-aos="fade-left"><img src="assets/img/tools/stbdurma.png" class="img-fluid" alt="stbdurma" style="width: 100%;height: 11vw;"></li>
        <li class="list-group-item list-tools-about" data-aos-duration="800" data-aos="fade-left"><img src="assets/img/tools/hugong_cnc.png" class="img-fluid" alt="hugong_cnc" style="width: 100%;height: 11vw;"></li>
        <li class="list-group-item list-tools-about" data-aos-duration="800" data-aos="fade-left"><img src="assets/img/tools/adrdurma.png" class="img-fluid" alt="adrdurma" style="width: 100%;height: 11vw;"></li>
        <li class="list-group-item list-tools-about" data-aos-duration="800" data-aos="flip-up"><img src="assets/img/tools/robotwelding.png" class="img-fluid" alt="robotwelding" style="width: 100%;height: 11vw;"></li>
        <li class="list-group-item list-tools-about" data-aos-duration="800" data-aos="fade-right"><img src="assets/img/tools/otsadm.png" class="img-fluid" alt="otsadm" style="width: 100%;height: 11vw;"></li>
        <li class="list-group-item list-tools-about" data-aos-duration="800" data-aos="fade-right"><img src="assets/img/tools/milling.png" class="img-fluid" alt="milling" style="width: 100%;height: 11vw;"></li>
        <li class="list-group-item list-tools-about" data-aos-duration="800" data-aos="fade-right"><img src="assets/img/tools/lathebubut.png" class="img-fluid" alt="lathebubut" style="width: 100%;height: 11vw;"></li>
      </ul>
    </div>
  </div>

  <div class='container mb-5'>
    <div class='row'>
      <div class='col-md-12 mb-5 mt-5' data-aos="zoom-in">
        <img src="assets/img/strukturorganisasi.png" class="img-fluid border border-dark border-top-0 border-start-0" alt="strukturorganisasi" style="width: 100%">
      </div>
    </div>
    <div class='row'>
      <div class='col-md-12 mb-3 text-center'>
        <h3 class="fw-bold">BUSINESS DEVELOPMENT PLANT</h3>
      </div>
      <div class='col-md-12'>
        <div class="card mb-3 shadow-lg p-3 mb-3 bg-body rounded"  data-aos="zoom-in-up">
          <div class="row">
            <div class="col-md-2 text-center d-flex justify-content-center align-self-center">
              <h3 class="fw-bold">2020</h3>
            </div>
            <div class="col-md-10">
              <div class="card-body">
                <ul>
                  <li>
                    Implementation Manufacturing System
                  </li>
                  <li>
                    New Machine Robot Welding
                  </li>
                  <li>
                    Start Building Press Machinary
                  </li>
                  <li>
                     Expanse More Product Under 6K
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class='row'>
      <div class='col-md-12'>
        <div class="card mb-3 shadow-lg p-3 mb-3 bg-body rounded"  data-aos="zoom-in-up">
          <div class="row">
            <div class="col-md-2 text-center d-flex justify-content-center align-self-center">
              <h3 class="fw-bold">2021</h3>
            </div>
            <div class="col-md-10">
              <div class="card-body">
                <ul>
                  <li>
                    New Production Area
                  </li>
                  <li>
                    Building Tools Upper 6K
                  </li>
                  <li>
                    Expanse More Product Upper 6K
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class='row'>
      <div class='col-md-12'>
        <div class="card mb-3 shadow-lg p-3 mb-3 bg-body rounded"  data-aos="zoom-in-up">
          <div class="row">
            <div class="col-md-2 text-center d-flex justify-content-center align-self-center">
              <h3 class="fw-bold">2022</h3>
            </div>
            <div class="col-md-10">
              <div class="card-body">
                <ul>
                  <li>
                    Make Workshop
                  </li>
                  <li>
                    Bought New Machine For Workshop
                  </li>
                  <li>
                    Making Subpart/ Accessories Carroserie
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class='row'>
      <div class='col-md-12'>
        <div class="card mb-3 shadow-lg p-3 mb-3 bg-body rounded"  data-aos="zoom-in-up">
          <div class="row">
            <div class="col-md-2 text-center d-flex justify-content-center align-self-center">
              <h3 class="fw-bold">2023</h3>
            </div>
            <div class="col-md-10">
              <div class="card-body">
                <ul>
                  <li>
                    Additional Robot For Process
                  </li>
                  <li>
                    Additional CNC Machine For Workshop
                  </li>
                  <li>
                    New Area For Assembling Line
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class='row'>
      <div class='col-md-12'>
        <div class="card mb-3 shadow-lg p-3 mb-3 bg-body rounded"  data-aos="zoom-in-up">
          <div class="row">
            <div class="col-md-2 text-center d-flex justify-content-center align-self-center">
              <h3 class="fw-bold">2024</h3>
            </div>
            <div class="col-md-10">
              <div class="card-body">
                <ul>
                  <li>
                    Additional Robot Welding For Process
                  </li>
                  <li>
                    Additional Tools For Jig & Dies Process
                  </li>
                  <li>
                    Additional New Product & Area
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!--#include file="tempfooter.asp"-->
</body>
<script src="public/js/bootstrap.min.js"></script>
<script src="assets/js/aos-master/dist/aos.js"></script>
<script>
  AOS.init({
    once: true,
  });
</script>

</html>