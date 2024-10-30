using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Text.RegularExpressions;
using Npgsql;
using System.Security.Cryptography;
using System.Text;
using System.Data;
using System.Text.Json;
using System.IO;
using System.Diagnostics;
using System.Net.Mail;
using System.Net;
using System.Xml.Linq;



namespace Capstone
{
    public partial class Trial : System.Web.UI.Page
    {
        private readonly string con = "Server=localhost;Port=5432;User Id=postgres;Password=123456;Database=trashtrack";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadRoles();
                AccountManList();
            }
        }

        protected void ClearForm_Click(object sender, EventArgs e)
        {
            emp_firstname.Text = "";
            emp_lastname.Text = "";
            emp_email.Text = "";
            emp_pass.Text = "";
            emp_contact.Text = "";
            emp_role.SelectedIndex = 0;
            //lblErrorMessage.Text = ""; // Clear any error messages
        }


        protected void AccountManList()
        {
            using (var db = new NpgsqlConnection(con))
            {
                db.Open();
                using (var cmd = db.CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;
                    // Modified the query to match the column names in the account_manager table
                    cmd.CommandText = "SELECT * FROM employee WHERE emp_status != 'Deleted' AND emp_id != @id ORDER BY emp_id, emp_status";
                    cmd.Parameters.AddWithValue("@id", Convert.ToInt32(Session["id"]));

                    DataTable admin_datatable = new DataTable();
                    NpgsqlDataAdapter admin_sda = new NpgsqlDataAdapter(cmd);
                    admin_sda.Fill(admin_datatable);

                    gridViewAccountMan.DataSource = admin_datatable; ;
                    gridViewAccountMan.DataBind();
                }
                db.Close();
            }
        }

        private void LoadRoles()
            {
                using (NpgsqlConnection conn = new NpgsqlConnection(con))
                {
                    string query = "SELECT role_id, role_name FROM roles ORDER BY role_id";
                    NpgsqlCommand cmd = new NpgsqlCommand(query, conn);

                    try
                    {
                        conn.Open();
                        NpgsqlDataAdapter da = new NpgsqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        emp_role.DataSource = dt;
                        emp_role.DataTextField = "role_name";
                        emp_role.DataValueField = "role_id";
                        emp_role.DataBind();

                        // Clear existing items and add the default "Select Role" option at the top
                        emp_role.Items.Clear();
                        ListItem selectRoleItem = new ListItem("--Select Role--", "0");
                        selectRoleItem.Attributes.Add("disabled", "true"); // Disable the item
                        selectRoleItem.Attributes.Add("selected", "true"); // Set as selected
                        emp_role.Items.Add(selectRoleItem);
                        emp_role.Items.AddRange(dt.AsEnumerable().Select(row => new ListItem(row["role_name"].ToString(), row["role_id"].ToString())).ToArray());
                    }
                    catch (Exception ex)
                    {
                        // Handle exception (logging, showing a message, etc.)
                    }
                }
            }



            protected void UpdateAdminInfo(object sender, EventArgs e)
            {
                int id;
                if (!int.TryParse(txtbxID.Text, out id))
                {
                    Response.Write("<script>alert('Invalid ID format.')</script>");
                    return;
                }

                string firstname = txtbfirstname.Text;
                string mi = txtmi.Text;
                string lastname = txtLastname.Text;
                string contact = txtContact.Text;
                string email = txtEmail.Text;
                string pass = TextBox1.Text;

                byte[] uploadedImageData = null;
                if (FileUpload1.HasFile)
                {
                    try
                    {
                        string fileExtension = Path.GetExtension(FileUpload1.PostedFile.FileName).ToLower();
                        string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif" };
                        if (allowedExtensions.Contains(fileExtension))
                        {
                            uploadedImageData = FileUpload1.FileBytes;
                        }
                        else
                        {
                            Response.Write("<script>alert('Only image files are allowed (jpg, jpeg, png, gif).')</script>");
                            return;
                        }
                    }
                    catch (Exception ex)
                    {
                        Response.Write("<script>alert('Error uploading image: " + ex.Message + "')</script>");
                        return;
                    }
                }

                using (var db = new NpgsqlConnection(con))
                {
                    db.Open();

                    // Check if the email already exists (excluding the current admin's email)
                    string emailCheckQuery = "SELECT COUNT(*) FROM employee WHERE emp_email = @newEmail AND emp_id <> @id";
                    using (var cmdCheckEmail = new NpgsqlCommand(emailCheckQuery, db))
                    {
                        cmdCheckEmail.Parameters.AddWithValue("@newEmail", email);
                        cmdCheckEmail.Parameters.AddWithValue("@id", id);

                        int emailExists = Convert.ToInt32(cmdCheckEmail.ExecuteScalar());
                        if (emailExists > 0)
                        {
                            Response.Write("<script>alert('Email is already taken. Please use a different email.')</script>");
                            return;
                        }
                    }

                    // Get current data for the admin based on the ID
                    string selectQuery = "SELECT emp_fname, emp_mname, emp_lname, emp_contact, emp_email, emp_password, emp_profile FROM employee WHERE emp_id = @id";
                    using (var cmdSelect = new NpgsqlCommand(selectQuery, db))
                    {
                        cmdSelect.Parameters.AddWithValue("@id", id);

                        string originalFirstname = null;
                        string originalMi = null;
                        string originalLastname = null;
                        string originalContact = null;
                        string originalEmail = null;
                        string originalPassword = null;
                        byte[] originalProfileImage = null;

                        using (var reader = cmdSelect.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                originalFirstname = reader["emp_fname"].ToString();
                                originalMi = reader["emp_mname"].ToString();
                                originalLastname = reader["emp_lname"].ToString();
                                originalContact = reader["emp_contact"].ToString();
                                originalEmail = reader["emp_email"].ToString();
                                originalPassword = reader["emp_password"].ToString();
                                originalProfileImage = reader["emp_profile"] as byte[];
                            }
                            else
                            {
                                Response.Write("<script>alert('No data found for the specified ID.')</script>");
                                return;
                            }
                        }

                        var updateFields = new List<string>();
                        var updateParams = new List<NpgsqlParameter>();
                        var changes = new List<string>();

                        // Check and update each field
                        if (!string.IsNullOrEmpty(firstname) && firstname != originalFirstname)
                        {
                            updateFields.Add("emp_fname = @firstname");
                            updateParams.Add(new NpgsqlParameter("@firstname", firstname));
                            changes.Add($"First Name: {originalFirstname} → {firstname}");
                        }
                        if (!string.IsNullOrEmpty(mi) && mi != originalMi)
                        {
                            updateFields.Add("emp_mname = @mi");
                            updateParams.Add(new NpgsqlParameter("@mi", mi));
                            changes.Add($"Middle Initial: {originalMi} → {mi}");
                        }
                        if (!string.IsNullOrEmpty(lastname) && lastname != originalLastname)
                        {
                            updateFields.Add("emp_lname = @lastname");
                            updateParams.Add(new NpgsqlParameter("@lastname", lastname));
                            changes.Add($"Last Name: {originalLastname} → {lastname}");
                        }
                        if (!string.IsNullOrEmpty(contact) && contact != originalContact)
                        {
                            updateFields.Add("emp_contact = @contact");
                            updateParams.Add(new NpgsqlParameter("@contact", contact));
                            changes.Add($"Contact: {originalContact} → {contact}");
                        }
                        if (!string.IsNullOrEmpty(email) && email != originalEmail)
                        {
                            updateFields.Add("emp_email = @email");
                            updateParams.Add(new NpgsqlParameter("@email", email));
                            changes.Add($"Email: {originalEmail} → {email}");
                        }
                        if (!string.IsNullOrEmpty(pass) && pass != originalPassword)
                        {
                            string hashedPassword = HashPassword(pass);
                            updateFields.Add("emp_password = @password");
                            updateParams.Add(new NpgsqlParameter("@password", hashedPassword));
                            changes.Add("Password: (Updated)");
                        }

                        if (uploadedImageData != null)
                        {
                            updateFields.Add("emp_profile = @profile");
                            updateParams.Add(new NpgsqlParameter("@profile", uploadedImageData));
                            changes.Add("Profile Picture: Updated");
                        }

                        if (updateFields.Count > 0)
                        {
                            string updateQuery = $"UPDATE employee SET {string.Join(", ", updateFields)} WHERE emp_id = @id";
                            using (var cmdUpdate = new NpgsqlCommand(updateQuery, db))
                            {
                                cmdUpdate.Parameters.AddWithValue("@id", id);
                                cmdUpdate.Parameters.AddRange(updateParams.ToArray());

                                int updatedRows = cmdUpdate.ExecuteNonQuery();
                                if (updatedRows > 0)
                                {
                                    // Notify changes via email
                                    string changeDetails = string.Join("\n", changes);
                                    string subject = "Account Information Update Notification";
                                    string body = $"Dear Admin,\n\nYour account information has been updated. Below are the details of the changes:\n\n{changeDetails}\n\nIf you did not request these changes, please contact support immediately.\n\nBest regards,\nThe Account Manager Team";

                                    if (!string.IsNullOrEmpty(email) && email != originalEmail)
                                    {
                                        Send_Email(originalEmail, subject, body);
                                        Send_Email(email, subject, body);
                                    }
                                    else
                                    {
                                        Send_Email(originalEmail, subject, body);
                                    }

                                    Response.Write("<script>alert('Admin information updated successfully!')</script>");
                                }
                                else
                                {
                                    Response.Write("<script>alert('Failed to update admin information.')</script>");
                                }
                            }
                        }
                        else
                        {
                            Response.Write("<script>alert('No changes detected.')</script>");
                        }
                    }
                }
            }



        //            protected void submitBtn_Click(object sender, EventArgs e)
        //            {
        //                //Response.Write("<script>alert('Submit Button Clicked!')</script>");

        //                // Extracting user input
        //                string role = emp_role.Text;
        //                string hashedPassword = HashPassword(emp_pass.Text);  // Hashing the password
        //                byte[] defaultImageData = File.ReadAllBytes(Server.MapPath("Pictures\\blank_prof.png"));  // Default profile image
        //                byte[] imageData = formFile.HasFile ? formFile.FileBytes : defaultImageData;  // Use uploaded image or default image
        //                string email = emp_email.Text;

        //                bool emailExists = false;
        //                bool isEmailSuspendedOrInactive = false;

        //                // Email Message
        //                string toAddress = email;
        //                string subject = "Important: Your Login Credentials for Completing Registration";
        //                string body = $"Dear Staff and Good Day!,\n\n" +
        //                    $"As a part of our onboarding process, we have generated your initial login credentials. Please use the following information to access the designated registration website and complete your profile:\n\n" +
        //                    $"Email: {email}\n" +
        //                    $"Password: {emp_pass.Text}\n\n" +
        //                    $"Visit the registration page on our main login page.\n\n" +
        //                    $"Once you log in, kindly fill out the remaining information required to complete your registration. After completing this step, these credentials will serve as your permanent login information for daily use in our system.\n\n" +
        //                    $"If you encounter any issues or have any questions, please do not hesitate to contact our support team.\n\n" +
        //                    $"Best regards,\n" +
        //                    $"The Account Manager Team\n" +
        //                    $"[Company Name]";

        //                // Validation: Ensure all required fields are filled
        //                if (!string.IsNullOrEmpty(emp_firstname.Text) &&
        //                    !string.IsNullOrEmpty(emp_lastname.Text) &&
        //                    !string.IsNullOrEmpty(emp_email.Text) &&
        //                    !string.IsNullOrEmpty(emp_pass.Text) &&
        //                    !string.IsNullOrEmpty(emp_address.Text) &&
        //                    !string.IsNullOrEmpty(emp_contact.Text) &&
        //                    (role == "1" || role == "2" || role == "3" || role == "4" || role == "5"))
        //                {
        //                    // Connect to PostgreSQL
        //                    using (var db = new NpgsqlConnection(con))
        //                    {
        //                        db.Open();

        //                        // SQL query to check if the email exists in any relevant table and retrieve status
        //                        string emailCheckQuery = @"
        //SELECT cus_email AS email, cus_status AS status FROM customer WHERE cus_email = @emp_email
        //UNION ALL
        //SELECT emp_email AS email, emp_status AS status FROM employee WHERE emp_email = @emp_email";

        //                        using (var cmd = new NpgsqlCommand(emailCheckQuery, db))
        //                        {
        //                            cmd.Parameters.AddWithValue("@emp_email", email);

        //                            using (var reader = cmd.ExecuteReader())
        //                            {
        //                                // Check if the email exists in any table and check its status
        //                                while (reader.Read())
        //                                {
        //                                    emailExists = true;  // Email exists
        //                                    string status = reader["status"].ToString().ToLower();

        //                                    // Email is inactive or suspended
        //                                    if (status == "inactive" || status == "suspend")
        //                                    {
        //                                        isEmailSuspendedOrInactive = true;
        //                                        break;
        //                                    }
        //                                }
        //                            }
        //                        }

        //                        // If email exists and is suspended/inactive, prevent the addition of a new account manager
        //                        if (emailExists)
        //                        {
        //                            if (isEmailSuspendedOrInactive)
        //                            {
        //                                Response.Write("<script>alert('The email is associated with an inactive or suspended account. Please use a different email.')</script>");
        //                            }
        //                            else
        //                            {
        //                                Response.Write("<script>alert('The email already exists. Please use a different email.')</script>");
        //                            }
        //                            return;  // Exit the function if the email is invalid or already exists
        //                        }

        //                        // Fetch role_id from the roles table based on the role name
        //                        int roleId = 0;
        //                        using (var roleCmd = new NpgsqlCommand("SELECT role_id FROM roles WHERE role_name = @role_name", db))
        //                        {
        //                            roleCmd.Parameters.AddWithValue("@role_name", role);
        //                            roleId = (int)roleCmd.ExecuteScalar();  // Get role_id corresponding to the role
        //                        }

        //                        // Optional: Assign acc_id and emp_otp if required by your application logic
        //                        int? accId = null; // Replace with actual logic if needed
        //                        string empOtp = null; // If you want to generate a one-time password

        //                        // Proceed to insert the new Account Manager
        //                        using (var cmd = new NpgsqlCommand(
        //                            @"INSERT INTO employee 
        //                  (emp_fname, emp_mname, emp_lname, emp_contact, emp_address, emp_email, emp_password, emp_profile, role_id, acc_id, emp_created_at, emp_updated_at, emp_otp) 
        //                  VALUES (@emp_fname, @emp_mname, @emp_lname, @emp_contact, @emp_address, @emp_email, @emp_password, @emp_profile, @role_id, @acc_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, @emp_otp)", db))
        //                        {
        //                            // Adding parameters to prevent SQL injection
        //                            cmd.Parameters.AddWithValue("@emp_fname", emp_firstname.Text);
        //                            cmd.Parameters.AddWithValue("@emp_mname", emp_mi.Text);
        //                            cmd.Parameters.AddWithValue("@emp_lname", emp_lastname.Text);
        //                            cmd.Parameters.AddWithValue("@emp_contact", emp_contact.Text);
        //                            cmd.Parameters.AddWithValue("@emp_address", emp_address.Text);  // Include employee address
        //                            cmd.Parameters.AddWithValue("@emp_email", email);
        //                            cmd.Parameters.AddWithValue("@emp_password", hashedPassword);
        //                            cmd.Parameters.AddWithValue("@emp_profile", imageData);  // Profile image as byte array
        //                            cmd.Parameters.AddWithValue("@role_id", roleId);  // Insert role_id
        //                            cmd.Parameters.AddWithValue("@acc_id", (object)accId ?? DBNull.Value);  // Handle nullable acc_id
        //                            cmd.Parameters.AddWithValue("@emp_otp", (object)empOtp ?? DBNull.Value);  // Handle nullable emp_otp

        //                            // Execute the query and check how many rows were affected
        //                            int ctr = cmd.ExecuteNonQuery();
        //                            if (ctr >= 1)
        //                            {
        //                                // Success: Account Manager added
        //                                Response.Write("<script>alert('Account Manager Added!')</script>");
        //                                AccountManList();  // Reload or update the list of Account Managers
        //                                Send_Email(toAddress, subject, body);  // Optionally send a welcome email
        //                            }
        //                            else
        //                            {
        //                                // Failure: Account Manager registration failed
        //                                Response.Write("<script>alert('Account Manager failed to Register!')</script>");
        //                                AccountManList();  // Reload or update the list of Account Managers
        //                            }
        //                        }

        //                        db.Close();
        //                    }
        //                }
        //                else
        //                {
        //                    // Validation error: Required fields are not filled
        //                    Response.Write("<script>alert('Please fill up all the required fields!')</script>");
        //                }
        //            }

        protected void submitBtn_Click(object sender, EventArgs e)
        {
            // Extracting user input
            string roleIdString = emp_role.SelectedValue; // Get selected role_id
            Response.Write($"<script>alert('Submit Button Clicked! Role ID: {roleIdString}')</script>");
            string hashedPassword = HashPassword(emp_pass.Text);  // Hashing the password
            byte[] defaultImageData = File.ReadAllBytes(Server.MapPath("Pictures\\blank_prof.png"));  // Default profile image
            byte[] imageData = formFile.HasFile ? formFile.FileBytes : defaultImageData;  // Use uploaded image or default image
            string email = emp_email.Text;

            bool emailExists = false;
            bool isEmailSuspendedOrInactive = false;

            // Email Message
            string toAddress = email;
            string subject = "Important: Your Login Credentials for Completing Registration";
            string body = $"Dear Staff and Good Day!,\n\n" +
                $"As a part of our onboarding process, we have generated your initial login credentials. Please use the following information to access the designated registration website and complete your profile:\n\n" +
                $"Email: {email}\n" +
                $"Password: {emp_pass.Text}\n\n" +
                $"Visit the registration page on our main login page.\n\n" +
                $"Once you log in, kindly fill out the remaining information required to complete your registration. After completing this step, these credentials will serve as your permanent login information for daily use in our system.\n\n" +
                $"If you encounter any issues or have any questions, please do not hesitate to contact our support team.\n\n" +
                $"Best regards,\n" +
                $"The Account Manager Team\n" +
                $"[Company Name]";

            // Validation: Ensure all required fields are filled
            if (!string.IsNullOrEmpty(emp_firstname.Text) &&
                !string.IsNullOrEmpty(emp_lastname.Text) &&
                !string.IsNullOrEmpty(emp_email.Text) &&
                !string.IsNullOrEmpty(emp_pass.Text) &&
                !string.IsNullOrEmpty(emp_address.Text) &&
                !string.IsNullOrEmpty(emp_contact.Text) &&
                !string.IsNullOrEmpty(roleIdString) && // Validate that a role is selected
                roleIdString != "0") // Check if a valid role is selected
            {
                // Connect to PostgreSQL
                using (var db = new NpgsqlConnection(con))
                {
                    db.Open();

                    // SQL query to check if the email exists in any relevant table and retrieve status
                    string emailCheckQuery = @"
SELECT cus_email AS email, cus_status AS status FROM customer WHERE cus_email = @emp_email
UNION ALL
SELECT emp_email AS email, emp_status AS status FROM employee WHERE emp_email = @emp_email";

                    using (var cmd = new NpgsqlCommand(emailCheckQuery, db))
                    {
                        cmd.Parameters.AddWithValue("@emp_email", email);

                        using (var reader = cmd.ExecuteReader())
                        {
                            // Check if the email exists in any table and check its status
                            while (reader.Read())
                            {
                                emailExists = true;  // Email exists
                                string status = reader["status"].ToString().ToLower();

                                // Email is inactive or suspended
                                if (status == "inactive" || status == "suspend")
                                {
                                    isEmailSuspendedOrInactive = true;
                                    break;
                                }
                            }
                        }
                    }

                    // If email exists and is suspended/inactive, prevent the addition of a new account manager
                    if (emailExists)
                    {
                        if (isEmailSuspendedOrInactive)
                        {
                            Response.Write("<script>alert('The email is associated with an inactive or suspended account. Please use a different email.')</script>");
                        }
                        else
                        {
                            Response.Write("<script>alert('The email already exists. Please use a different email.')</script>");
                        }
                        return;  // Exit the function if the email is invalid or already exists
                    }

                    // Validate roleId and proceed
                    int roleId = int.Parse(roleIdString); // Convert the selected value to an integer

                    // Optional: Assign acc_id and emp_otp if required by your application logic
                    int? accId = null; // Replace with actual logic if needed
                    string empOtp = null; // If you want to generate a one-time password

                    // Proceed to insert the new Account Manager
                    using (var cmd = new NpgsqlCommand(
                        @"INSERT INTO employee 
                (emp_fname, emp_mname, emp_lname, emp_contact, emp_address, emp_email, emp_password, emp_profile, role_id, acc_id, emp_created_at, emp_updated_at, emp_otp) 
                VALUES (@emp_fname, @emp_mname, @emp_lname, @emp_contact, @emp_address, @emp_email, @emp_password, @emp_profile, @role_id, @acc_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, @emp_otp)", db))
                    {
                        // Adding parameters to prevent SQL injection
                        cmd.Parameters.AddWithValue("@emp_fname", emp_firstname.Text);
                        cmd.Parameters.AddWithValue("@emp_mname", emp_mi.Text);
                        cmd.Parameters.AddWithValue("@emp_lname", emp_lastname.Text);
                        cmd.Parameters.AddWithValue("@emp_contact", emp_contact.Text);
                        cmd.Parameters.AddWithValue("@emp_address", emp_address.Text);  // Include employee address
                        cmd.Parameters.AddWithValue("@emp_email", email);
                        cmd.Parameters.AddWithValue("@emp_password", hashedPassword);
                        cmd.Parameters.AddWithValue("@emp_profile", imageData);  // Profile image as byte array
                        cmd.Parameters.AddWithValue("@role_id", roleId);  // Insert role_id
                        cmd.Parameters.AddWithValue("@acc_id", (object)accId ?? DBNull.Value);  // Handle nullable acc_id
                        cmd.Parameters.AddWithValue("@emp_otp", (object)empOtp ?? DBNull.Value);  // Handle nullable emp_otp

                        // Execute the query and check how many rows were affected
                        int ctr = cmd.ExecuteNonQuery();
                        if (ctr >= 1)
                        {
                            // Success: Account Manager added
                            Response.Write("<script>alert('Account Manager Added!')</script>");
                            AccountManList();  // Reload or update the list of Account Managers
                            Send_Email(toAddress, subject, body);  // Optionally send a welcome email
                        }
                        else
                        {
                            // Failure: Account Manager registration failed
                            Response.Write("<script>alert('Account Manager failed to Register!')</script>");
                            AccountManList();  // Reload or update the list of Account Managers
                        }
                    }

                    db.Close();
                }
            }
            else
            {
                // Validation error: Required fields are not filled
                Response.Write("<script>alert('Please fill up all the required fields!')</script>");
            }
        }




        public static void Send_Email(string toAddress, string subject, string body)
            {
                //SmtpClient smtpClient = new SmtpClient("smtp.gmail.com");
                //smtpClient.UseDefaultCredentials = false;
                //smtpClient.Credentials = new NetworkCredential("fjunevincent369@gmail.com", "lgkw alyq ntyv mefw");
                //smtpClient.EnableSsl = true;
                //smtpClient.Port = 587;

                //MailMessage mailMessage = new MailMessage();
                //mailMessage.From = new MailAddress("fjunevincent369@gmail.com");
                //mailMessage.To.Add(toAddress);
                //mailMessage.Subject = subject;
                //mailMessage.Body = body;
                //mailMessage.IsBodyHtml = false;

                //smtpClient.Send(mailMessage);
                SmtpClient smtpClient = new SmtpClient("smtp.gmail.com");
                smtpClient.UseDefaultCredentials = false;
                smtpClient.Credentials = new NetworkCredential("fjunevincent369@gmail.com", "lgkw alyq ntyv mefw");
                smtpClient.EnableSsl = true;
                smtpClient.Port = 587;

                MailMessage mailMessage = new MailMessage();
                mailMessage.From = new MailAddress("fjunevincent369@gmail.com");
                mailMessage.To.Add(toAddress);
                mailMessage.Subject = subject;
                mailMessage.Body = body;
                mailMessage.IsBodyHtml = false;

                smtpClient.Send(mailMessage);
            }

            private string HashPassword(string password)
            {
                using (SHA256 sha256 = SHA256.Create())
                {
                    var saltedPassword = password;
                    byte[] hashedBytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(saltedPassword));

                    // Convert the hashed bytes to a hexadecimal string
                    StringBuilder stringBuilder = new StringBuilder();
                    foreach (byte b in hashedBytes)
                    {
                        stringBuilder.Append(b.ToString("x2"));
                    }

                    return stringBuilder.ToString();
                }
            }

        protected void Update_Click(object sender, EventArgs e)
        {
            LinkButton btn = sender as LinkButton;
            int id = Convert.ToInt32(btn.CommandArgument);  // Get the admin ID from the button's CommandArgument
            //byte[] imageData = null;  // To hold the profile image data

            try
            {
                // Connect to PostgreSQL
                using (var db = new NpgsqlConnection(con))
                {
                    db.Open();

                    // Define the SQL query to get the admin details based on the admin ID (acc_id)
                    string query = @"
                SELECT emp_fname, emp_mname, emp_lname, emp_contact, emp_email, emp_profile 
                FROM employee 
                WHERE emp_id = @acc_id";

                    using (var cmd = new NpgsqlCommand(query, db))
                    {
                        cmd.Parameters.AddWithValue("@acc_id", id);

                        // Execute the query
                        using (var reader = cmd.ExecuteReader())
                        {
                            if (reader.Read()) // Check if data is available for the given admin ID
                            {
                                // Assign the data to the respective textboxes
                                txtbfirstname.Text = reader["emp_fname"].ToString();
                                txtmi.Text = reader["emp_mname"].ToString();
                                txtLastname.Text = reader["emp_lname"].ToString();
                                txtContact.Text = reader["emp_contact"].ToString();
                                txtEmail.Text = reader["emp_email"].ToString();
                                byte[] imageData = reader["emp_profile"] as byte[];  // Retrieve profile image data (byte array)

                                // Display profile image in the preview control
                                if (imagePreviewUpdate != null)
                                {
                                    if (imageData != null && imageData.Length > 0)
                                    {
                                        try
                                        {
                                            string base64String = Convert.ToBase64String(imageData);
                                            imagePreviewUpdate.ImageUrl = "data:image/jpeg;base64," + base64String;  // Set image as base64 string
                                        }
                                        catch (Exception ex)
                                        {
                                            Response.Write("<script>alert('Error converting image to Base64: " + ex.Message + "')</script>");
                                        }
                                    }
                                    else
                                    {
                                        imagePreviewUpdate.ImageUrl = "~/Pictures/blank_prof.png";  // Default image if no profile picture found
                                    }
                                }
                                else
                                {
                                    Response.Write("<script>alert('Image preview control is not found');</script>");
                                }
                            }
                            else
                            {
                                // Handle case when no data is found for the given admin ID
                                ClientScript.RegisterClientScriptBlock(this.GetType(), "alert",
                                    "swal('Unsuccessful!', 'Admin not found.', 'error')", true);
                                return; // Exit if no data is found
                            }
                        }
                    }

                    db.Close();
                }
            }
            catch (Exception ex)
            {
                // Handle any errors
                ClientScript.RegisterClientScriptBlock(this.GetType(), "alert",
                    "swal('Unsuccessful!', '" + ex.Message + "', 'error')", true);
                return; // Exit if there was an error
            }

            // Set the ID textbox and show the modal popup
            txtbxID.Text = id.ToString();
            this.ModalPopupExtender2.Show();  // Show the modal popup

            // Optionally refresh the account manager list after the modal popup
            AccountManList();
        }

        protected void Suspend_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int managerId = Convert.ToInt32(btn.CommandArgument);

            try
            {
                using (var db = new NpgsqlConnection(con))
                {
                    db.Open();
                    using (var cmd = db.CreateCommand())
                    {
                        cmd.CommandType = CommandType.Text;
                        cmd.CommandText = "UPDATE employee SET emp_status = 'Suspend' WHERE emp_id = @id";
                        cmd.Parameters.AddWithValue("@id", managerId);

                        var ctr = cmd.ExecuteNonQuery();
                        if (ctr >= 1)
                        {
                            ClientScript.RegisterClientScriptBlock(this.GetType(), "alert",
                                "swal('Suspended!', 'Account Manager Suspended Successfully!', 'success')", true);
                            AccountManList();
                        }
                    }
                    db.Close();
                }
            }
            catch (Exception ex)
            {
                ClientScript.RegisterClientScriptBlock(this.GetType(), "alert",
                    "swal('Unsuccessful!', '" + ex.Message + "', 'error')", true);
            }
        }



        // Unsuspension of the admin Action
        protected void Unsuspend_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int managerId = Convert.ToInt32(btn.CommandArgument);

            try
            {
                using (var db = new NpgsqlConnection(con))
                {
                    db.Open();
                    using (var cmd = db.CreateCommand())
                    {
                        cmd.CommandType = CommandType.Text;
                        cmd.CommandText = "UPDATE employee SET emp_status = 'Active' WHERE emp_id = @id";
                        cmd.Parameters.AddWithValue("@id", managerId);

                        var ctr = cmd.ExecuteNonQuery();
                        if (ctr >= 1)
                        {
                            ClientScript.RegisterClientScriptBlock(this.GetType(), "alert",
                                "swal('Unsuspended!', 'Account Manager Unsuspended Successfully!', 'success')", true);
                            AccountManList();
                        }
                    }
                    db.Close();
                }
            }
            catch (Exception ex)
            {
                ClientScript.RegisterClientScriptBlock(this.GetType(), "alert",
                    "swal('Unsuccessful!', '" + ex.Message + "', 'error')", true);
            }
        }


        // validate if the admin status is Suspend
        protected Boolean IsSuspended(string status)
        {
            return status == "Suspend";
        }

        // validate if the admin status is Unsuspend
        protected Boolean IsActive(string status)
        {
            return status == "Active";
        }

        // Deletion of the admin or update the status to Inactive if the admin is inactive anymore
        protected void Remove_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;

            int adminId = Convert.ToInt32(btn.CommandArgument);

            try
            {
                using (var db = new NpgsqlConnection(con))
                {
                    db.Open();
                    using (var cmd = db.CreateCommand())
                    {
                        cmd.CommandType = CommandType.Text;
                        cmd.CommandText = "UPDATE EMPLOYEE SET EMP_STATUS = 'Deleted' WHERE EMP_ID = @id";
                        cmd.Parameters.AddWithValue("@id", adminId);

                        var ctr = cmd.ExecuteNonQuery();
                        if (ctr >= 1)
                        {
                            ClientScript.RegisterClientScriptBlock(this.GetType(), "alert",
                                "swal('Account Removed!', 'Account Manager Account Removed Successfully!', 'success')", true);
                            AccountManList();
                        }
                    }

                    db.Close();
                }
            }
            catch (Exception ex)
            {
                ClientScript.RegisterClientScriptBlock(this.GetType(), "alert",
                        "swal('Unsuccessfull!', '" + ex.Message + "', 'error')", true);
            }
        }


    }
}