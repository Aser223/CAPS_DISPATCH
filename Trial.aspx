<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Trial.aspx.cs" Inherits="Capstone.Trial" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <%--hide unhide pass--%>
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
    <link href="assets/vendor/simple-datatables/style.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>

    <!-- Template Main CSS File -->
    <link href="assets/css/style.css" rel="stylesheet">
    <%--#052507--%>
</head>
<body>
    <form id="form1" runat="server" class="row g-3 needs-validation" novalidate>
        <div>
            <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <!-- Modal Header -->
                        <div class="modal-header">
                            <h1 class="modal-title fs-5" id="exampleModalLabel">Add Account Manager</h1>
                            <button type="button" class="btn-close custom-close-button" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>

                        <!-- Modal Body -->
                        <div class="modal-body">
                            <!-- Firstname -->
                            <div class="mb-3">
                                <asp:Label ID="Label13" runat="server" class="form-label" Text="Firstname" for="inputText"></asp:Label>
                                <asp:TextBox ID="emp_firstname" runat="server" class="form-control" onkeyup="validateFirstname()"></asp:TextBox>
                                <div class="valid-feedback">Looks good!</div>
                                <div class="invalid-feedback">Please provide a valid firstname.</div>
                            </div>

                            <!-- Middle Initial -->
                            <div class="mb-3">
                                <asp:Label ID="Label4" runat="server" Text="M.I" for="inputText"></asp:Label>
                                <asp:TextBox ID="emp_mi" class="form-control" runat="server"></asp:TextBox>
                                <div class="valid-feedback">Looks good!</div>
                                <div class="invalid-feedback">Please provide a valid middle initial (optional).</div>
                            </div>

                            <!-- Lastname -->
                            <div class="mb-3">
                                <asp:Label ID="Label5" runat="server" Text="Lastname" for="inputText"></asp:Label>
                                <asp:TextBox ID="emp_lastname" runat="server" class="form-control" onkeyup="validateLastname()"></asp:TextBox>
                                <div class="valid-feedback">Looks good!</div>
                                <div class="invalid-feedback">Please provide a valid lastname.</div>
                            </div>

                            <!-- Address -->
                            <div class="mb-3">
                                <asp:Label ID="Label11" runat="server" Text="Address" for="inputText"></asp:Label>
                                <asp:TextBox ID="emp_address" runat="server" class="form-control" onkeyup="validateAddress()"></asp:TextBox>
                                <div class="valid-feedback">Looks good!</div>
                                <div class="invalid-feedback">Please provide a valid address.</div>
                            </div>

                            <!-- Email -->
                            <div class="mb-3">
                                <asp:Label ID="Label10" runat="server" Text="Email" for="inputText"></asp:Label>
                                <asp:TextBox ID="emp_email" runat="server" class="form-control" onkeyup="validateEmail()"></asp:TextBox>
                                <div class="valid-feedback">Looks good!</div>
                                <div class="invalid-feedback">Please provide a valid email address.</div>
                            </div>

                            <!-- Password -->
                            <div class="col-12 mb-3">
                                <asp:Label ID="Label7" runat="server" Text="Password" for="inputText"></asp:Label>
                                <div class="input-group">
                                    <asp:TextBox ID="emp_pass" runat="server" class="form-control" type="password" onkeyup="validatePassword()"></asp:TextBox>
                                    <span class="input-group-text" style="cursor: pointer;" onclick="togglePasswords()">
                                        <i id="passIcon" class="fas fa-eye-slash"></i>
                                    </span>
                                </div>
                                <div class="invalid-feedback">Password must be at least 6 characters long and contain at least one uppercase letter, one number, and one special character.</div>
                            </div>


                            <!-- Contact No. -->
                            <div class="mb-3">
                                <asp:Label ID="Label8" runat="server" Text="Contact No." for="inputText"></asp:Label>
                                <asp:TextBox ID="emp_contact" runat="server" class="form-control" onkeyup="validateContact()"></asp:TextBox>
                                <div class="valid-feedback">Looks good!</div>
                                <div class="invalid-feedback">Please provide a valid Philippines contact number (e.g., 09XXXXXXXXX).</div>
                            </div>

                            <!-- Dropdown (Role) -->
                            <div class="mb-3">
                                <asp:Label ID="Label6" runat="server" Text="Role" for="inputText"></asp:Label>
                                <asp:DropDownList ID="emp_role" class="form-select" aria-label="Default select example" runat="server" onChange="validateRole()">
                                </asp:DropDownList>
                                <div class="invalid-feedback">Please select a role.</div>
                            </div>

                            <!-- File Upload (with Image Preview) -->
                            <div class="mb-3">
                                <asp:Label ID="Label12" runat="server" Text="Picture" for="inputText"></asp:Label>
                                <asp:FileUpload ID="formFile" accept="image/*" class="form-control" runat="server" OnChange="previewImage1()" />
                                <asp:ImageMap ID="imagePreview" src="Pictures/blank_prof.png" runat="server" alt="Image Preview" CssClass="img-thumbnail mt-2" Style="max-width: 150px;"></asp:ImageMap>
                                <span id="fileError" style="color: red; display: none;">File uploaded is not an image.</span>
                            </div>
                        </div>

                        <!-- Modal Footer -->
                        <div class="modal-footer">
                            <asp:Button ID="ClearForm" Text="Close" runat="server" class="btn btn-secondary" data-bs-dismiss="modal" OnClick="ClearForm_Click" />
                            <asp:Button class="btn btn-primary" ID="submitBtn" runat="server" Text="Submit Form" OnClick="submitBtn_Click" />
                        </div>
                    </div>
                </div>
            </div>







            <section style="background-color: #052507; padding: 25px; border-radius: 8px; box-shadow: 0 0 5px rgba(0, 0, 0, .2)">
                <div>
                    <asp:ImageMap ID="ImageMap1" runat="server" ImageUrl="Pictures//box_format.png" Style="float: right; margin-right: 0px; margin-top: 0px; width: 50px"></asp:ImageMap>
                </div>
                <div style="margin-top: 50px; margin-bottom: 30px">
                    <asp:TextBox Style="border-radius: 10px; padding-left: 10px; padding: 2px; margin-top: 7px; border-color: aquamarine; border-width: 3px" placeholder="Search" ID="txtSearch" runat="server" oninput="search();" AutoPostBack="false"></asp:TextBox>
                    <button type="button" class="btn btn-primary" style="margin: 10px; float: right; background-color: #052507; border-color: aquamarine; border-radius: 8px; border-width: 3px" data-bs-toggle="modal" data-bs-target="#exampleModal">
                        Add Account Manager +
                    </button>
                </div>


                <%--EDIT BUTTON--%>
                <div class="gridview-container">
                    <asp:GridView Style="width: 100%; word-break: break-all; table-layout: fixed" ID="gridViewAccountMan" runat="server" AutoGenerateColumns="False" ShowHeaderWhenEmpty="True"
                        DataKeyNames="emp_id" AllowPaging="False" CellPadding="20" GridLines="None">
                        <AlternatingRowStyle BackColor="#f9cfb4" ForeColor="Black" />

                        <Columns>
                            <asp:BoundField DataField="emp_id" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="emp_id" ItemStyle-Width="100px">
                                <ItemStyle Width="100px" Wrap="true" />
                            </asp:BoundField>
                            <asp:BoundField DataField="emp_fname" HeaderText="First Name" SortExpression="emp_fname" ItemStyle-Width="150px">
                                <ItemStyle Width="150px" Wrap="true" />
                            </asp:BoundField>
                            <asp:BoundField DataField="emp_mname" HeaderText="M.I" SortExpression="emp_mname" ItemStyle-Width="100px">
                                <ItemStyle Width="100px" Wrap="true" />
                            </asp:BoundField>
                            <asp:BoundField DataField="emp_lname" HeaderText="Last Name" SortExpression="emp_lname" ItemStyle-Width="150px">
                                <ItemStyle Width="150px" Wrap="true" />
                            </asp:BoundField>
                            <asp:BoundField DataField="emp_contact" HeaderText="Contact" SortExpression="emp_contact" ItemStyle-Width="100px">
                                <ItemStyle Width="100px" Wrap="true" />
                            </asp:BoundField>
                            <asp:BoundField DataField="emp_email" HeaderText="Email" SortExpression="emp_email" ItemStyle-Width="200px">
                                <ItemStyle Width="200px" Wrap="true" />
                            </asp:BoundField>
                            <asp:BoundField DataField="emp_created_at" HeaderText="Created At" SortExpression="emp_created_at" ItemStyle-Width="150px">
                                <ItemStyle Width="150px" Wrap="true" />
                            </asp:BoundField>
                            <asp:BoundField DataField="emp_updated_at" HeaderText="Updated At" SortExpression="emp_updated_at" ItemStyle-Width="150px">
                                <ItemStyle Width="150px" Wrap="true" />
                            </asp:BoundField>

                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <asp:Button Style="font-size: 10px; color: orangered; font-weight: bold;" ID="btnUnsuspend" runat="server" Text='<%# Eval("emp_status") + " ▼"%>'
                                        OnClick="Unsuspend_Click"
                                        OnClientClick="return confirm('Are you sure you want to Unsuspend this account manager?');"
                                        Visible='<%# Eval("emp_status").ToString() == "Suspend" %>' CommandArgument='<%# Eval("emp_id") %>' />
                                    <asp:Label ID="Label9" runat="server" Text='<%# Eval("emp_status")%>' Visible='<%# Eval("emp_status").ToString() == "Inactive" %>' />
                                    <asp:Button Style="font-size: 10px; color: lawngreen; font-weight: bold;" ID="btnSuspend" runat="server" Text='<%# Eval("emp_status") + " ▲"%>'
                                        OnClick="Suspend_Click"
                                        OnClientClick="return confirm('Are you sure you want to Suspend this account manager?');"
                                        Visible='<%# Eval("emp_status").ToString() == "Active" %>' CommandArgument='<%# Eval("emp_id") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <asp:LinkButton ID="update" runat="server" OnClick="Update_Click" CommandArgument='<%# Eval("emp_id") %>'>
                                        <asp:Image ID="imgEdit" runat="server" ImageUrl="~/Pictures/editlogo.png" Width="35%" Height="35%" Style="margin-right: 10px" AlternateText="Edit" />
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="Remove" runat="server" OnClick="Remove_Click" CommandArgument='<%# Eval("emp_id") %>' OnClientClick="return confirm('Are you sure you want to remove this account manager?');">
                                        <asp:Image ID="Image1" runat="server" ImageUrl="~/Pictures/removeBtn.png" Width="35%" Height="35%" AlternateText="Remove" />
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>

                        <RowStyle BackColor="White" ForeColor="Black" />
                        <EditRowStyle BackColor="#7C6F57" />
                        <FooterStyle BackColor="Black" Font-Bold="True" ForeColor="#f9cfb4" />
                        <HeaderStyle BackColor="#2c2c2c" Font-Bold="True" ForeColor="Chartreuse" BorderStyle="None" />
                        <PagerStyle BorderColor="#CC9900" Font-Size="20px" BackColor="White" ForeColor="#f9cfb4" HorizontalAlign="Center" />
                        <SelectedRowStyle BackColor="#C5BBAF" Font-Bold="True" ForeColor="White" />
                        <SortedAscendingCellStyle BackColor="Black" />
                        <SortedAscendingHeaderStyle BackColor="#246B61" />
                        <SortedDescendingCellStyle BackColor="Black" />
                        <SortedDescendingHeaderStyle BackColor="#15524A" />
                    </asp:GridView>
                </div>


            </section>



            <asp:LinkButton ID="LinkButton1" runat="server"></asp:LinkButton>
            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>



            <!-- Centering the panel and enhancing its look -->
            <div class="container" style="height: 100vh; display: flex; justify-content: center; align-items: center;">
                <!-- First Form (Update Info) -->
                <asp:Panel ID="updatePanel" CssClass="card shadow-lg scrollable-panel" runat="server" Style="max-width: 600px; background-color: #052507; border: 1px solid aquamarine; border-radius: 8px;">
                    <contenttemplate>
                        <div class="card bg-light" style="background-color: #052507;">
                            <!-- Header Section -->
                            <div class="card-header text-center" style="background-color: #052507; color: aquamarine;">
                                <h4 class="mb-0">Update Information</h4>
                            </div>

                            <!-- Body Section -->
                            <div class="card-body" style="background-color: #052507;">
                                <div class="row">
                                    <!-- ID (Disabled) -->
                                    <div class="col-12 mb-3">
                                        <div class="input-group input-group-sm">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text">ID</span>
                                            </div>
                                            <asp:TextBox ID="txtbxID" runat="server" CssClass="form-control" ClientIDMode="Static" Enabled="false"></asp:TextBox>
                                        </div>
                                    </div>

                                    <!-- Firstname -->
                                    <div class="col-6 mb-3">
                                        <asp:Label ID="Label17" runat="server" Text="Firstname" Style="color: chartreuse"></asp:Label>

                                        <asp:TextBox ID="txtbfirstname" runat="server" CssClass="form-control" ClientIDMode="Static" onkeyup="validateUpdateFirstname()"></asp:TextBox>
                                        <div class="valid-feedback">Looks good!</div>
                                        <div class="invalid-feedback">Please provide a valid firstname.</div>
                                    </div>

                                    <!-- Lastname -->
                                    <div class="col-6 mb-3">
                                        <asp:Label ID="Label16" runat="server" Text="Lastname" Style="color: chartreuse"></asp:Label>

                                        <asp:TextBox ID="txtLastname" runat="server" CssClass="form-control" ClientIDMode="Static" onkeyup="validateUpdateLastname()"></asp:TextBox>
                                        <div class="valid-feedback">Looks good!</div>
                                        <div class="invalid-feedback">Please provide a valid lastname.</div>
                                    </div>

                                    <!-- Middle Initial (Optional) -->
                                    <div class="col-6 mb-3">
                                        <asp:Label ID="Label3" runat="server" Text="Middle Initial" Style="color: chartreuse"></asp:Label>

                                        <asp:TextBox ID="txtmi" runat="server" CssClass="form-control" ClientIDMode="Static"></asp:TextBox>
                                        <div class="valid-feedback">Looks good!</div>
                                        <div class="invalid-feedback">Please provide a valid middle initial (optional).</div>

                                    </div>

                                    <!-- Contact -->
                                    <div class="col-6 mb-3">
                                        <asp:Label ID="Label2" runat="server" Text="Contact No." Style="color: chartreuse"></asp:Label>

                                        <asp:TextBox ID="txtContact" runat="server" CssClass="form-control" ClientIDMode="Static" TextMode="Number" onkeyup="validateUpdateContact()"></asp:TextBox>
                                        <div class="valid-feedback">Looks good!</div>
                                        <div class="invalid-feedback">Please provide a valid Philippines contact number (e.g., 09XXXXXXXXX).</div>
                                    </div>
                                </div>

                                <!-- Email -->
                                <div class="col-12 mb-3">
                                    <div class="mb-3">
                                        <%--<div class="input-group-prepend">
                                    <span class="input-group-text">Email</span>
                                </div>--%>
                                        <asp:Label ID="Label1" runat="server" Text="Email" Style="color: chartreuse"></asp:Label>

                                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" ClientIDMode="Static" onkeyup="validateUpdateEmail()"></asp:TextBox>
                                        <div class="valid-feedback">Looks good!</div>
                                        <div class="invalid-feedback">Please provide a valid email address.</div>
                                    </div>
                                </div>

                                <!-- Password -->
                                <div class="col-12 mb-3">

                                    <asp:Label ID="Label15" runat="server" Text="Password" Style="color: chartreuse"></asp:Label>
                                    <div class="input-group">
                                        <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control mt-2" type="password" onkeyup="validateUpdatePassword()"></asp:TextBox>
                                        <span class="input-group-text mt-2" style="cursor: pointer;" onclick="toggleUpdatePassword()">
                                            <i id="updatePasswordIcon" class="fas fa-eye-slash"></i>
                                        </span>
                                    </div>
                                    <div class="invalid-feedback">Password must be at least 6 characters long and contain at least one uppercase letter, one number, and one special character.</div>
                                </div>





                                <!-- Picture Upload -->
                                <div class="col-12 mb-3">
                                    <asp:Label ID="Label14" runat="server" Text="Picture" Style="color: chartreuse"></asp:Label>
                                    <asp:FileUpload ID="FileUpload1" accept="image/*" class="form-control" runat="server" OnChange="previewUpdateImage();" />
                                    <asp:Image ID="imagePreviewUpdate" runat="server" AlternateText="Image Preview" CssClass="img-thumbnail mt-2" Style="max-width: 150px;" />
                                    <span id="fileErrorUpdate" class="text-danger" style="display: none;">File uploaded is not an image.</span>
                                </div>
                            </div>
                        </div>

                        <!-- Footer Section -->
                        <div class="card-footer text-center" style="background-color: #052507; color: aquamarine;">
                            <asp:Button ID="btncancel" CssClass="btn btn-secondary" runat="server" Text="Cancel" />
                            <asp:Button ID="btnUpdate" CssClass="btn btn-primary" runat="server" Text="Update" OnClick="UpdateAdminInfo" OnClientClick="return confirm('Are you sure you want to update category?');" />
                        </div>
            </div>
            </contenttemplate>
    </asp:Panel>
        </div>





        <ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender2" runat="server" CancelControlID="btncancel" PopupControlID="updatePanel" TargetControlID="LinkButton1" BackgroundCssClass="Background" DropShadow="True"></ajaxToolkit:ModalPopupExtender>

        <a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

        <!-- Vendor JS Files -->
        <script src="assets/vendor/apexcharts/apexcharts.min.js"></script>
        <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
        fgen
            <script src="assets/vendor/chart.js/chart.umd.js"></script>
        <script src="assets/vendor/echarts/echarts.min.js"></script>
        <script src="assets/vendor/quill/quill.min.js"></script>
        <script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
        <script src="assets/vendor/tinymce/tinymce.min.js"></script>
        <script src="assets/vendor/php-email-form/validate.js"></script>

        <!-- Template Main JS File -->
        <script src="assets/js/main.js"></script>


        <%--<script>
                // Validation Functions
                function validateFirstname() {
                    const firstname = document.getElementById('<%= emp_firstname.ClientID %>');
                    if (!/^[A-Za-z]+$/.test(firstname.value)) {
                        firstname.classList.add('is-invalid');
                        firstname.classList.remove('is-valid');
                    } else {
                        firstname.classList.remove('is-invalid');
                        firstname.classList.add('is-valid');
                    }
                }

                function validateLastname() {
                    const lastname = document.getElementById('<%= emp_lastname.ClientID %>');
                    if (!/^[A-Za-z]+$/.test(lastname.value)) {
                        lastname.classList.add('is-invalid');
                        lastname.classList.remove('is-valid');
                    } else {
                        lastname.classList.remove('is-invalid');
                        lastname.classList.add('is-valid');
                    }
                }

                function validateEmail() {
                    const email = document.getElementById('<%= emp_email.ClientID %>');
                    const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$/;
                    if (!emailPattern.test(email.value)) {
                        email.classList.add('is-invalid');
                        email.classList.remove('is-valid');
                    } else {
                        email.classList.remove('is-invalid');
                        email.classList.add('is-valid');
                    }
                }

                function validateContact() {
                    const contact = document.getElementById('<%= emp_contact.ClientID %>');
                    const contactPattern = /^09\d{9}$/;
                    if (!contactPattern.test(contact.value)) {
                        contact.classList.add('is-invalid');
                        contact.classList.remove('is-valid');
                    } else {
                        contact.classList.remove('is-invalid');
                        contact.classList.add('is-valid');
                    }
                }

                function validateAddress() {
                    const address = document.getElementById('<%= emp_address.ClientID %>');
                    if (address.value.trim() === "") {
                        address.classList.add('is-invalid');
                        address.classList.remove('is-valid');
                    } else {
                        address.classList.remove('is-invalid');
                        address.classList.add('is-valid');
                    }
                }

                // Validate Password
                function validatePassword() {
                    const password = document.getElementById('<%= emp_pass.ClientID %>');
                    // Updated regex to require at least one lowercase, one uppercase, one number, and one special character
                    const passwordPattern = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}$/;

                    if (!passwordPattern.test(password.value)) {
                        password.classList.add('is-invalid');
                        password.classList.remove('is-valid');
                    } else {
                        password.classList.remove('is-invalid');
                        password.classList.add('is-valid');
                    }
                }



                function togglePasswords() {
                    const password = document.getElementById('<%= emp_pass.ClientID %>');
                    const passIcon = document.getElementById('passIcon');
                    if (password.type === "password") {
                        password.type = "text";
                        passIcon.classList.remove("fa-eye-slash");
                        passIcon.classList.add("fa-eye");
                    } else {
                        password.type = "password";
                        passIcon.classList.remove("fa-eye");
                        passIcon.classList.add("fa-eye-slash");
                    }
                }

                // Validate Dropdown List (Role)
                function validateRole() {
                    const role = document.getElementById('<%= emp_role.ClientID %>');
                    if (role.value === "") {
                        role.classList.add('is-invalid');
                        role.classList.remove('is-valid');
                    } else {
                        role.classList.remove('is-invalid');
                        role.classList.add('is-valid');
                    }
                }

                // Validate File Upload (Image Only)
                function previewImage1() {
                    const fileInput = document.getElementById('<%= formFile.ClientID %>');
    const imagePreview = document.getElementById('<%= imagePreview.ClientID %>');
                    const file = fileInput.files[0];
                    const allowedExtensions = ["image/jpeg", "image/jpg", "image/png", "image/gif"];
                    const fileError = document.getElementById('fileError');

                    if (file && allowedExtensions.includes(file.type)) {
                        const reader = new FileReader();
                        reader.onload = function (e) {
                            imagePreview.src = e.target.result;
                        };
                        reader.readAsDataURL(file);
                        fileError.style.display = "none";  // Hide error message
                    } else {
                        imagePreview.src = "Pictures/blank_prof.png";
                        fileError.style.display = "block";  // Show error message
                        alert("Invalid file. Please upload a valid image.");
                    }
                }

                // Validate the entire form
                function validateForm() {
                    let isValid = true;

                    validateFirstname();
                    validateLastname();
                    validateEmail();
                    validateContact();
                    validateAddress();
                    validatePassword();
                    validateRole();
                    previewImage1(); // This will trigger image validation too

                    // Check if all validations passed
                    if (document.querySelectorAll('.is-invalid').length > 0) {
                        isValid = false;
                        alert("Please fill in all required fields correctly!");
                    }

                    return isValid;
                }

                // Use it in your submit button click event
                submitBtn.onclick = function (event) {
                    if (!validateForm()) {
                        event.preventDefault(); // Prevent form submission
                    }
                };



            </script>--%>



        <script>
            // Validation Functions for Add Account Manager
            function validateFirstname() {
                const firstname = document.getElementById('<%= emp_firstname.ClientID %>');
                if (!/^[A-Za-z]+$/.test(firstname.value)) {
                    firstname.classList.add('is-invalid');
                    firstname.classList.remove('is-valid');
                } else {
                    firstname.classList.remove('is-invalid');
                    firstname.classList.add('is-valid');
                }
            }

            function validateLastname() {
                const lastname = document.getElementById('<%= emp_lastname.ClientID %>');
                if (!/^[A-Za-z]+$/.test(lastname.value)) {
                    lastname.classList.add('is-invalid');
                    lastname.classList.remove('is-valid');
                } else {
                    lastname.classList.remove('is-invalid');
                    lastname.classList.add('is-valid');
                }
            }

            function validateEmail() {
                const email = document.getElementById('<%= emp_email.ClientID %>');
                const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$/;
                if (!emailPattern.test(email.value)) {
                    email.classList.add('is-invalid');
                    email.classList.remove('is-valid');
                } else {
                    email.classList.remove('is-invalid');
                    email.classList.add('is-valid');
                }
            }

            function validateContact() {
                const contact = document.getElementById('<%= emp_contact.ClientID %>');
                const contactPattern = /^09\d{9}$/;
                if (!contactPattern.test(contact.value)) {
                    contact.classList.add('is-invalid');
                    contact.classList.remove('is-valid');
                } else {
                    contact.classList.remove('is-invalid');
                    contact.classList.add('is-valid');
                }
            }

            function validateAddress() {
                const address = document.getElementById('<%= emp_address.ClientID %>');
                if (address.value.trim() === "") {
                    address.classList.add('is-invalid');
                    address.classList.remove('is-valid');
                } else {
                    address.classList.remove('is-invalid');
                    address.classList.add('is-valid');
                }
            }

            function validatePassword() {
                const password = document.getElementById('<%= emp_pass.ClientID %>');
                const passwordPattern = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}$/;
                if (!passwordPattern.test(password.value)) {
                    password.classList.add('is-invalid');
                    password.classList.remove('is-valid');
                } else {
                    password.classList.remove('is-invalid');
                    password.classList.add('is-valid');
                }
            }
            function togglePasswords() {
                const password = document.getElementById('<%= emp_pass.ClientID %>');
                const passIcon = document.getElementById('passIcon');
                if (password.type === "password") {
                    password.type = "text";
                    passIcon.classList.remove("fa-eye-slash");
                    passIcon.classList.add("fa-eye");
                } else {
                    password.type = "password";
                    passIcon.classList.remove("fa-eye");
                    passIcon.classList.add("fa-eye-slash");
                }
            }

            function validateRole() {
                const role = document.getElementById('<%= emp_role.ClientID %>');
                if (role.value === "") {
                    role.classList.add('is-invalid');
                    role.classList.remove('is-valid');
                } else {
                    role.classList.remove('is-invalid');
                    role.classList.add('is-valid');
                }
            }

            function previewImage1() {
                const fileInput = document.getElementById('<%= formFile.ClientID %>');
                const imagePreview = document.getElementById('<%= imagePreview.ClientID %>');
                const file = fileInput.files[0];
                const allowedExtensions = ["image/jpeg", "image/jpg", "image/png", "image/gif"];
                const fileError = document.getElementById('fileError');

                if (file && allowedExtensions.includes(file.type)) {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        imagePreview.src = e.target.result;
                    };
                    reader.readAsDataURL(file);
                    fileError.style.display = "none";
                } else {
                    imagePreview.src = "Pictures/blank_prof.png";
                    fileError.style.display = "block";
                    alert("Invalid file. Please upload a valid image.");
                }
            }

            // Validation Functions for Update Information
            function validateUpdateFirstname() {
                const firstname = document.getElementById('<%=txtbfirstname.ClientID%>');
                if (!/^[A-Za-z]+$/.test(firstname.value)) {
                    firstname.classList.add('is-invalid');
                    firstname.classList.remove('is-valid');
                } else {
                    firstname.classList.remove('is-invalid');
                    firstname.classList.add('is-valid');
                }
            }

            function validateUpdateLastname() {
                const lastname = document.getElementById('<%=txtLastname.ClientID%>');
                if (!/^[A-Za-z]+$/.test(lastname.value)) {
                    lastname.classList.add('is-invalid');
                    lastname.classList.remove('is-valid');
                } else {
                    lastname.classList.remove('is-invalid');
                    lastname.classList.add('is-valid');
                }
            }

            function validateUpdateEmail() {
                const email = document.getElementById('<%=txtEmail.ClientID%>');
                const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$/;
                if (!emailPattern.test(email.value)) {
                    email.classList.add('is-invalid');
                    email.classList.remove('is-valid');
                } else {
                    email.classList.remove('is-invalid');
                    email.classList.add('is-valid');
                }
            }

            function validateUpdateContact() {
                const contact = document.getElementById('<%=txtContact.ClientID%>');
                const contactPattern = /^09\d{9}$/;
                if (!contactPattern.test(contact.value)) {
                    contact.classList.add('is-invalid');
                    contact.classList.remove('is-valid');
                } else {
                    contact.classList.remove('is-invalid');
                    contact.classList.add('is-valid');
                }
            }

            function validateUpdatePassword() {
                const password = document.getElementById('<%= TextBox1.ClientID %>');
                const passwordPattern = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}$/;
                if (!passwordPattern.test(password.value)) {
                    password.classList.add('is-invalid');
                    password.classList.remove('is-valid');
                } else {
                    password.classList.remove('is-invalid');
                    password.classList.add('is-valid');
                }
            }

            function toggleUpdatePassword() {
                const passwordField = document.getElementById('<%= TextBox1.ClientID %>');
                const icon = document.getElementById('updatePasswordIcon');

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








            function previewImageUpdate() {
                const fileInput = document.getElementById('<%=FileUpload1.ClientID%>');
                const imagePreview = document.getElementById('<%=imagePreviewUpdate.ClientID%>');
                const file = fileInput.files[0];
                const allowedExtensions = ["image/jpeg", "image/png", "image/gif"];
                const fileError = document.getElementById('fileErrorUpdate');

                if (file && allowedExtensions.includes(file.type)) {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        imagePreview.src = e.target.result;
                        fileError.style.display = 'none';
                    };
                    reader.readAsDataURL(file);
                } else {
                    imagePreview.src = "";
                    fileError.style.display = 'block';
                }
            }


            // Validate entire Update form
            function validateUpdateForm() {
                let isValid = true;

                validateUpdateFirstname();
                validateUpdateLastname();
                validateUpdateEmail();
                validateUpdateContact();
                validateUpdatePassword();
                previewImageUpdate();

                if (document.querySelectorAll('.is-invalid').length > 0) {
                    isValid = false;
                    alert("Please fill in all required fields correctly!");
                }

                return isValid;
            }


            // Form submission handlers
            document.getElementById('submitBtn').onclick = function (event) {
                if (!validateForm()) {
                    event.preventDefault();
                }
            };

            document.getElementById('btnUpdate').onclick = function (event) {
                if (!validateUpdateForm()) {
                    event.preventDefault();
                }
            };
        </script>





        </div>
    </form>
</body>
</html>
