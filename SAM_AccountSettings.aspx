<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SAM_AccountSettings.aspx.cs" Inherits="Capstone.SAM_AccountSettings" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">

  <title>PBC - Dashboard</title>
  <meta content="" name="description">
  <meta content="" name="keywords">
  <%--hide unhide eye--%>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
  <!-- Favicons -->
  <link href="assets/img/favicon.png" rel="icon">
  <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">

  <!-- Google Fonts -->
  <link href="https://fonts.gstatic.com" rel="preconnect">
  <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i" rel="stylesheet">

  <!-- Vendor CSS Files -->
  <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
  <link href="assets/vendor/boxicons/css/boxicons.min.css" rel="stylesheet">
  <link href="assets/vendor/quill/quill.snow.css" rel="stylesheet">
  <link href="assets/vendor/quill/quill.bubble.css" rel="stylesheet">
  <link href="assets/vendor/remixicon/remixicon.css" rel="stylesheet">
  <link href="assets/vendor/simple-datatables/style.css" rel="stylesheet
      <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

  <!-- Template Main CSS File -->
  <link href="assets/css/style.css" rel="stylesheet">

</head>
    
    <div>
<body style="background-color: #041d06 " >

  <!-- ======= Header ======= -->    <%--#9ee2a0, #9ee2a0, #9ee2a0--%>
<%--  <header style="background-image: linear-gradient(to right, #000000, #061f0d, #000000); height: 80px" id="header" class="header fixed-top d-flex align-items-center">--%>
<header style="background-color: black; height: 80px" id="header" class="header fixed-top d-flex align-items-center">

    <div class="d-flex align-items-center justify-content-between">
      <a href="Customer_Dashboard.aspx" class="logo d-flex align-items-center">
        <img style="border-radius: 1px" src="Pictures/logo2.png" alt=""/>
        <span style="color: aqua; font-weight: 900; font-family: 'Agency FB'"  class="d-none d-lg-block">PBC</span>
      </a>
      <i style="color:aqua" class="bi bi-list toggle-sidebar-btn"></i>
    </div><!-- End Logo -->

    <nav class="header-nav ms-auto">
      <ul class="d-flex align-items-center">

        <li class="nav-item dropdown">

          <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow notifications">
            <li>
              <hr class="dropdown-divider">
            </li>

            <li>
              <hr class="dropdown-divider">
            </li>

            <li>
              <hr class="dropdown-divider">
            </li>

            <li>
              <hr class="dropdown-divider">
            </li>
          </ul><!-- End Notification Dropdown Items -->

        </li><!-- End Notification Nav -->

        <li class="nav-item dropdown pe-3">

          <a class="nav-link nav-profile d-flex align-items-center pe-0" href="#" data-bs-toggle="dropdown" style="color:aqua">
              <asp:ImageMap ID="profile_image" runat="server" alt="Profile" class="rounded-circle"></asp:ImageMap>
                <span style="color:aqua" class="d-none d-md-block dropdown-toggle ps-2">
                    <asp:Label ID="Label2" runat="server" Text=""></asp:Label></span>
          </a><!-- End Profile Image Icon -->

          <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow profile">
            <li class="dropdown-header">
              <h6>
                  <asp:Label ID="Label1" runat="server" Text=""></asp:Label></h6>
              <span>
                  <asp:Label ID="Label3" runat="server" Text="Customer"></asp:Label></span>
            </li>
            <li>
              <hr class="dropdown-divider">
            </li>
            <li>
              <hr class="dropdown-divider">
            </li>

            <li>
              <a class="dropdown-item d-flex align-items-center" href="Customer_Change_Pass.aspx">
                <i class="bi bi-gear"></i>
                <span>Account Settings</span>
              </a>
            </li>
            <li>
              <hr class="dropdown-divider">
            </li>

            <li>
              <hr class="dropdown-divider">
            </li>

            <li>
                <a class="dropdown-item d-flex align-items-center" href="#" onclick="confirmLogout()">
                    <i class="bi bi-box-arrow-right"></i>
                    <span>Sign Out</span>
                </a>
            </li>
              <script>
                  function confirmLogout() {
                      var isConfirmed = confirm("Are you sure you want to log out?");
                      if (isConfirmed) {
                          // If confirmed, redirect to the logout page
                          window.location.href = "LOGIN.aspx";
                      } else {
                          // If not confirmed, do nothing or handle as needed
                      }
                  }
              </script>
          </ul><!-- End Profile Dropdown Items -->
        </li><!-- End Profile Nav -->

      </ul>
    </nav><!-- End Icons Navigation -->

  </header><!-- End Header -->

   <!-- ======= Sidebar ======= --> <%--#052507--%>
  <aside style="padding-top: 50px" id="sidebar" class="sidebar">

    <ul class="sidebar-nav" id="sidebar-nav">

      <li class="nav-item">
        <a class="nav-link collapsed" href="SAM_Dashboard.aspx">
          <i class="bi bi-grid"></i>
          <span>Dashboard</span>
        </a>

      </li><!-- End Employee Nav -->


        <li class="nav-item">
        <a class="nav-link collapsed" data-bs-target="#forms-nav" data-bs-toggle="collapse" href="#">
                  <i class="bi bi-people"></i><span>Manage Account</span><i class="bi bi-chevron-down ms-auto"></i>

        </a>
        <ul id="forms-nav" class="nav-content collapse" data-bs-parent="#sidebar-nav">
            <li>
                <a href="SAM_AccountMan.aspx">
                    <i class="bi bi-circle"></i><span>Employees</span>
                </a>
            </li>
            <li>
                <a href="SAM_AccountManCustomers.aspx">
                    <i class="bi bi-circle"></i><span>Customers</span>
                </a>
            </li>

        </ul>
        </li>

        <li class="nav-item">
            <a class="nav-link collapsed" data-bs-target="#tables-nav" data-bs-toggle="collapse" href="#">
                <i class="ri-bill-line"></i><span>Reports</span><i class="bi bi-chevron-down ms-auto"></i>
            </a>
            <ul id="tables-nav" class="nav-content collapse" data-bs-parent="#sidebar-nav">
                <li>
                    <a href="Admin_Billing_GenerateBill.aspx">
                        <i class="bi bi-circle"></i><span>Generate Bill</span>
                    </a>
                </li>

                <li>
                    <a href="Admin_Billing_Controls.aspx">
                        <i class="bi bi-circle"></i><span>Controls</span>
                    </a>
                </li>
            </ul>
        </li>
    </ul>
  </aside><!-- End Sidebar-->

  <main id="main" class="main">


    <section class="section dashboard">
      <div class="row">

        <!-- Left side columns -->
        <div class="col-lg-8">
          <div class="row">


          </div>
        </div><!-- End Left side columns -->

        <!-- Right side columns -->
        <div class="col-lg-4">
        </div><!-- End Right side columns -->
      </div>
    </section>

      
    <div class="pagetitle">
      <h1 style="padding-top: 20px; color:chartreuse">Profile</h1>
      <nav>
        <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="index.html">Home</a></li>
          <li class="breadcrumb-item">Users</li>
          <li class="breadcrumb-item active">Profile</li>
        </ol>
      </nav>
    </div><!-- End Page Title -->

    <section class="section profile">
      <div class="row">
        <div class="col-xl-4">

          <div class="card">
            <div class="card-body profile-card pt-4 d-flex flex-column align-items-center">

              <img src="assets/img/profile-img.jpg" alt="Profile" class="rounded-circle">
              <h2>Kevin Anderson</h2>
              <h3>Web Designer</h3>
              <div class="social-links mt-2">
                <a href="#" class="twitter"><i class="bi bi-twitter"></i></a>
                <a href="#" class="facebook"><i class="bi bi-facebook"></i></a>
                <a href="#" class="instagram"><i class="bi bi-instagram"></i></a>
                <a href="#" class="linkedin"><i class="bi bi-linkedin"></i></a>
              </div>
            </div>
          </div>

        </div>

        <div class="col-xl-8">

          <div class="card">
            <div class="card-body pt-3">
              <!-- Bordered Tabs -->
              <ul class="nav nav-tabs nav-tabs-bordered">

                <li class="nav-item">
                  <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#profile-overview">Overview</button>
                </li>

                <li class="nav-item">
                  <button class="nav-link" data-bs-toggle="tab" data-bs-target="#profile-edit">Edit Profile</button>
                </li>

                <li class="nav-item">
                  <button class="nav-link" data-bs-toggle="tab" data-bs-target="#profile-settings">Settings</button>
                </li>

                <li class="nav-item">
                  <button class="nav-link" data-bs-toggle="tab" data-bs-target="#profile-change-password">Change Password</button>
                </li>

              </ul>
              <div class="tab-content pt-2">

                <div class="tab-pane fade show active profile-overview" id="profile-overview">
                  <h5 class="card-title">About</h5>
                  <p class="small fst-italic">Sunt est soluta temporibus accusantium neque nam maiores cumque temporibus. Tempora libero non est unde veniam est qui dolor. Ut sunt iure rerum quae quisquam autem eveniet perspiciatis odit. Fuga sequi sed ea saepe at unde.</p>

                  <h5 class="card-title">Profile Details</h5>

                  <div class="row">
                    <div class="col-lg-3 col-md-4 label ">Full Name</div>
                    <div class="col-lg-9 col-md-8"></div>
                  </div>

                  <div class="row">
                    <div class="col-lg-3 col-md-4 label">Company</div>
                    <div class="col-lg-9 col-md-8"></div>
                  </div>

                  <div class="row">
                    <div class="col-lg-3 col-md-4 label">Job</div>
                    <div class="col-lg-9 col-md-8"></div>
                  </div>

                  <div class="row">
                    <div class="col-lg-3 col-md-4 label">Country</div>
                    <div class="col-lg-9 col-md-8">USA</div>
                  </div>

                  <div class="row">
                    <div class="col-lg-3 col-md-4 label">Address</div>
                    <div class="col-lg-9 col-md-8">A108 Adam Street, New York, NY 535022</div>
                  </div>

                  <div class="row">
                    <div class="col-lg-3 col-md-4 label">Phone</div>
                    <div class="col-lg-9 col-md-8">(436) 486-3538 x29071</div>
                  </div>

                  <div class="row">
                    <div class="col-lg-3 col-md-4 label">Email</div>
                    <div class="col-lg-9 col-md-8">k.anderson@example.com</div>
                  </div>

                </div>

                <div class="tab-pane fade profile-edit pt-3" id="profile-edit">

                  <!-- Profile Edit Form -->
               

                </div>

                <div class="tab-pane fade pt-3" id="profile-settings">

                  <!-- Settings Form -->
              

                </div>

<div class="tab-pane fade pt-3" id="profile-change-password">
        <!-- Change Password Form -->
        <form runat="server">

            <div class="row mb-3">
                <label for="currentPassword" class="col-md-4 col-lg-3 col-form-label">Current Password</label>
                <div class="col-md-8 col-lg-9">
                    <div class="input-group">
                        <asp:TextBox ID="currentpassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                        <span class="input-group-text" style="cursor: pointer;" onclick="togglePasswordVisibility('currentpassword', 'currentPasswordIcon')">
                            <i id="currentPasswordIcon" class="fas fa-eye-slash"></i>
                        </span>
                    </div>
                </div>
            </div>

            <div class="row mb-3">
                <label for="newPassword" class="col-md-4 col-lg-3 col-form-label">New Password</label>
                <div class="col-md-8 col-lg-9">
                    <div class="input-group">
                        <asp:TextBox ID="changetxt" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                        <span class="input-group-text" style="cursor: pointer;" onclick="togglePasswordVisibility('changetxt', 'newPasswordIcon')">
                            <i id="newPasswordIcon" class="fas fa-eye-slash"></i>
                        </span>
                    </div>
                </div>
            </div>

            <div class="row mb-3">
                <label for="renewPassword" class="col-md-4 col-lg-3 col-form-label">Re-enter New Password</label>
                <div class="col-md-8 col-lg-9">
                    <div class="input-group">
                        <asp:TextBox ID="confirmtxt" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                        <span class="input-group-text" style="cursor: pointer;" onclick="togglePasswordVisibility('confirmtxt', 'confirmPasswordIcon')">
                            <i id="confirmPasswordIcon" class="fas fa-eye-slash"></i>
                        </span>
                    </div>
                </div>
            </div>

            <div class="text-center">
                <asp:Button ID="changepassword" runat="server" OnClick="changepassword_Click" CssClass="btn btn-primary" Text="Change Password" />
            </div>
        </form>
        <!-- End Change Password Form -->
    </div>



              </div><!-- End Bordered Tabs -->

            </div>
          </div>

        </div>
      </div>
    </section>

  </main>
    <!-- End #main -->

    <!-- ======= Footer ======= -->
    <footer id="footer" class="footer" style="border-top-color: chartreuse">
        <div class="copyright" style="color: #d4f3cf">
            &copy; Copyright <strong><span style="color: #d4f3cf">Pinoy Basurero Corporation</span></strong>. All Rights Reserved
        </div>
    </footer>
    <!-- End Footer -->

    <a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

    <%--inside script--%>
    <script>
        function togglePasswordVisibility(textBoxId, iconId) {
            var passwordField = document.getElementById(textBoxId);
            var icon = document.getElementById(iconId);

            if (passwordField.type === "password") {
                passwordField.type = "text";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
            } else {
                passwordField.type = "password";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
            }
        }

    </script>


    <!-- Vendor JS Files -->
    <script src="assets/vendor/apexcharts/apexcharts.min.js"></script>
    <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="assets/vendor/chart.js/chart.umd.js"></script>
    <script src="assets/vendor/echarts/echarts.min.js"></script>
    <script src="assets/vendor/quill/quill.min.js"></script>
    <script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
    <script src="assets/vendor/tinymce/tinymce.min.js"></script>
    <script src="assets/vendor/php-email-form/validate.js"></script>

    <!-- Template Main JS File -->
    <script src="assets/js/main.js"></script>
    </body>
    </div>

</html>

