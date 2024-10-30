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
    public partial class SAM_BO : System.Web.UI.Page
    {
        private readonly string con = "Server=localhost;Port=5432;User Id=postgres;Password=123456;Database=trashtrack";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                AccountManList();
                //profile_image.DataBind();
                LoadProfile();
            }
        }



        private void LoadProfile()
        {
            //imagePreview.

            try
            {
                if (Session["sam_id"] == null)
                {
                    // Session expired or not set, redirect to login
                    Response.Redirect("LoginPage.aspx");
                    return;
                }

                int adminId = (int)Session["sam_id"];  // Retrieve admin ID from session

                byte[] imageData = null;  // Initialize imageData

                // Define the PostgreSQL connection
                using (var db = new NpgsqlConnection(con))
                {
                    db.Open();

                    // PostgreSQL query to get profile image
                    string query = "SELECT acc_profile FROM account_manager WHERE acc_id = @id";
                    using (var cmd = new NpgsqlCommand(query, db))
                    {
                        // Set the parameter for admin ID
                        cmd.Parameters.AddWithValue("@id", NpgsqlTypes.NpgsqlDbType.Integer, adminId);

                        // Execute the query and retrieve the image data
                        var result = cmd.ExecuteScalar();

                        if (result != null && result != DBNull.Value)
                        {
                            imageData = (byte[])result;  // Cast the result to byte array
                        }
                    }
                }

                // Check if the profile_image control exists and is not null
                if (profile_image != null)
                {
                    if (imageData != null && imageData.Length > 0)
                    {
                        string base64String = Convert.ToBase64String(imageData);
                        profile_image.ImageUrl = "data:image/jpeg;base64," + base64String;  // Set image as base64 string
                        //imagePreviewUpdate.ImageUrl = "data:image/jpeg;base64," + base64String;
                    }
                    else
                    {
                        profile_image.ImageUrl = "~/Pictures/blank_prof.png";  // Default image if no profile picture found
                    }
                }
                else
                {
                    Response.Write("<script>alert('Profile image control is not found');</script>");
                }
            }
            catch (Exception ex)
            {
                // Log the exception or handle it
                Response.Write("<script>alert('Error loading profile image: " + ex.Message + "');</script>");
                profile_image.ImageUrl = "~/Pictures/blank_prof.png";  // Fallback in case of an error
            }
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
                    cmd.CommandText = "SELECT * FROM account_manager WHERE acc_status != 'Deleted' AND acc_id != @id ORDER BY acc_id, acc_status";
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
                string emailCheckQuery = "SELECT COUNT(*) FROM account_manager WHERE acc_email = @newEmail AND acc_id <> @id";
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
                string selectQuery = "SELECT acc_fname, acc_mname, acc_lname, acc_contact, acc_email, acc_password, acc_profile FROM account_manager WHERE acc_id = @id";
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
                            originalFirstname = reader["acc_fname"].ToString();
                            originalMi = reader["acc_mname"].ToString();
                            originalLastname = reader["acc_lname"].ToString();
                            originalContact = reader["acc_contact"].ToString();
                            originalEmail = reader["acc_email"].ToString();
                            originalPassword = reader["acc_password"].ToString();
                            originalProfileImage = reader["acc_profile"] as byte[];
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
                        updateFields.Add("acc_fname = @firstname");
                        updateParams.Add(new NpgsqlParameter("@firstname", firstname));
                        changes.Add($"First Name: {originalFirstname} → {firstname}");
                    }
                    if (!string.IsNullOrEmpty(mi) && mi != originalMi)
                    {
                        updateFields.Add("acc_mname = @mi");
                        updateParams.Add(new NpgsqlParameter("@mi", mi));
                        changes.Add($"Middle Initial: {originalMi} → {mi}");
                    }
                    if (!string.IsNullOrEmpty(lastname) && lastname != originalLastname)
                    {
                        updateFields.Add("acc_lname = @lastname");
                        updateParams.Add(new NpgsqlParameter("@lastname", lastname));
                        changes.Add($"Last Name: {originalLastname} → {lastname}");
                    }
                    if (!string.IsNullOrEmpty(contact) && contact != originalContact)
                    {
                        updateFields.Add("acc_contact = @contact");
                        updateParams.Add(new NpgsqlParameter("@contact", contact));
                        changes.Add($"Contact: {originalContact} → {contact}");
                    }
                    if (!string.IsNullOrEmpty(email) && email != originalEmail)
                    {
                        updateFields.Add("acc_email = @email");
                        updateParams.Add(new NpgsqlParameter("@email", email));
                        changes.Add($"Email: {originalEmail} → {email}");
                    }
                    if (!string.IsNullOrEmpty(pass) && pass != originalPassword)
                    {
                        string hashedPassword = HashPassword(pass);
                        updateFields.Add("acc_password = @password");
                        updateParams.Add(new NpgsqlParameter("@password", hashedPassword));
                        changes.Add("Password: (Updated)");
                    }

                    if (uploadedImageData != null)
                    {
                        updateFields.Add("acc_profile = @profile");
                        updateParams.Add(new NpgsqlParameter("@profile", uploadedImageData));
                        changes.Add("Profile Picture: Updated");
                    }

                    if (updateFields.Count > 0)
                    {
                        string updateQuery = $"UPDATE account_manager SET {string.Join(", ", updateFields)} WHERE acc_id = @id";
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





        protected void submitBtn_Click(object sender, EventArgs e)
        {
            string role = emp_role.Text;
            string hashedPassword = HashPassword(emp_pass.Text);
            byte[] defaultImageData = File.ReadAllBytes(Server.MapPath("Pictures\\blank_prof.png"));
            byte[] imageData = formFile.HasFile ? formFile.FileBytes : defaultImageData;
            string email = emp_email.Text;
            bool emailExists = false;
            bool isEmailSuspendedOrInactive = false;

            //// Ensure valid email format if necessary
            //if (!IsValidEmail(email))
            //{
            //    Response.Write("<script>alert('Invalid email format.')</script>");
            //    return;
            //}

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

            // Proceed with form submission if all fields are filled
            if (!string.IsNullOrEmpty(emp_firstname.Text) &&
                !string.IsNullOrEmpty(emp_email.Text) &&
                !string.IsNullOrEmpty(emp_pass.Text) &&
                (role == "Super Account Manager" || role == "Account Manager"))
            {
                // Connect to PostgreSQL
                using (var db = new NpgsqlConnection(con))
                {
                    db.Open();

                    // Query to check if the email exists and its status across all tables
                    string emailCheckQuery = @"
                SELECT cus_email AS email, cus_status AS status FROM customer WHERE cus_email = @emp_email
                UNION ALL
                SELECT haul_email AS email, haul_role AS status FROM hauler WHERE haul_email = @emp_email
                UNION ALL
                SELECT bo_email AS email, bo_status AS status FROM billing_officer WHERE bo_email = @emp_email
                UNION ALL
                SELECT op_email AS email, op_status AS status FROM operational_dispatcher WHERE op_email = @emp_email
                UNION ALL
                SELECT acc_email AS email, acc_status AS status FROM account_manager WHERE acc_email = @emp_email";

                    using (var cmd = new NpgsqlCommand(emailCheckQuery, db))
                    {
                        cmd.Parameters.AddWithValue("@emp_email", email);

                        using (var reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                emailExists = true;  // Email found in one of the tables
                                string status = reader["status"].ToString().ToLower();

                                // Check if the status is inactive or suspended
                                if (status == "inactive" || status == "suspend")
                                {
                                    isEmailSuspendedOrInactive = true;
                                    break;
                                }
                            }
                        }
                    }

                    // If email already exists or is inactive/suspended, prevent insertion
                    if (emailExists)
                    {
                        if (isEmailSuspendedOrInactive)
                        {
                            // Display alert for inactive or suspended email
                            Response.Write("<script>alert('The email is associated with an inactive or suspended account. Please use a different email.')</script>");
                        }
                        else
                        {
                            // Display alert for email already existing
                            Response.Write("<script>alert('The email already exists. Please use a different email.')</script>");
                        }
                        return; // Exit function without inserting the account manager
                    }

                    // If no email issues, proceed to insert the new account manager
                    using (var cmd = new NpgsqlCommand("INSERT INTO account_manager (acc_fname, acc_mname, acc_lname, acc_password, acc_contact, acc_email, acc_role, acc_profile) " +
                                                       "VALUES (@acc_fname, @acc_mname, @acc_lname, @acc_password, @acc_contact, @acc_email, @acc_role, @acc_profile)", db))
                    {
                        cmd.Parameters.AddWithValue("@acc_fname", emp_firstname.Text);
                        cmd.Parameters.AddWithValue("@acc_mname", emp_mi.Text);
                        cmd.Parameters.AddWithValue("@acc_lname", emp_lastname.Text);
                        cmd.Parameters.AddWithValue("@acc_password", hashedPassword);
                        cmd.Parameters.AddWithValue("@acc_contact", emp_contact.Text);
                        cmd.Parameters.AddWithValue("@acc_email", email);
                        cmd.Parameters.AddWithValue("@acc_role", role);
                        cmd.Parameters.AddWithValue("@acc_profile", imageData);  // Profile image as byte array

                        int ctr = cmd.ExecuteNonQuery();
                        if (ctr >= 1)
                        {
                            Response.Write("<script>alert('Account Manager Added!')</script>");
                            AccountManList(); // Reload or update the list of Account Managers
                            Send_Email(toAddress, subject, body);
                        }
                        else
                        {
                            Response.Write("<script>alert('Account Manager failed to Register!')</script>");
                            AccountManList(); // Reload or update the list of Account Managers
                        }
                    }

                    db.Close();
                }
            }
            else
            {
                Response.Write("<script>alert('Fill up all the fields!')</script>");
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


        // Generate Salt for password security
        protected string GenerateSalt()
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            var random = new Random();
            var saltChars = new char[16];
            for (int i = 0; i < saltChars.Length; i++)
            {
                saltChars[i] = chars[random.Next(chars.Length)];
            }
            return new string(saltChars);
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



        //IMODIFY PALANG
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
                SELECT acc_fname, acc_mname, acc_lname, acc_contact, acc_email, acc_profile 
                FROM account_manager 
                WHERE acc_id = @acc_id";

                    using (var cmd = new NpgsqlCommand(query, db))
                    {
                        cmd.Parameters.AddWithValue("@acc_id", id);

                        // Execute the query
                        using (var reader = cmd.ExecuteReader())
                        {
                            if (reader.Read()) // Check if data is available for the given admin ID
                            {
                                // Assign the data to the respective textboxes
                                txtbfirstname.Text = reader["acc_fname"].ToString();
                                txtmi.Text = reader["acc_mname"].ToString();
                                txtLastname.Text = reader["acc_lname"].ToString();
                                txtContact.Text = reader["acc_contact"].ToString();
                                txtEmail.Text = reader["acc_email"].ToString();
                                byte[] imageData = reader["acc_profile"] as byte[];  // Retrieve profile image data (byte array)

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




        public void GetAdminInfo(int admID)
        {
            try
            {
                // Connect to PostgreSQL
                using (var db = new NpgsqlConnection(con))
                {
                    db.Open();

                    // Define the SQL query to get the admin details based on the admin ID (acc_id)
                    string query = "SELECT acc_fname, acc_mname, acc_lname, acc_username, acc_contact, acc_email FROM account_manager WHERE acc_id = @acc_id";

                    using (var cmd = new NpgsqlCommand(query, db))
                    {
                        cmd.Parameters.AddWithValue("@acc_id", admID);

                        // Execute the query
                        using (var reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // Assign the data to the respective textboxes
                                txtbfirstname.Text = reader["acc_fname"].ToString();
                                txtmi.Text = reader["acc_mname"].ToString();
                                txtLastname.Text = reader["acc_lname"].ToString();
                                //txtUsername.Text = reader["acc_username"].ToString();
                                txtContact.Text = reader["acc_contact"].ToString();
                                txtEmail.Text = reader["acc_email"].ToString();

                                AccountManList();
                            }
                            else
                            {
                                // Handle case when no data is found for the given admin ID
                                ClientScript.RegisterClientScriptBlock(this.GetType(), "alert",
                                    "swal('Unsuccessful!', 'Admin not found.', 'error')", true);
                            }
                        }
                    }

                    db.Close();
                }
                AccountManList();
            }
            catch (Exception ex)
            {
                // Handle any errors
                ClientScript.RegisterClientScriptBlock(this.GetType(), "alert",
                    "swal('Unsuccessful!', '" + ex.Message + "', 'error')", true);
            }
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
                        cmd.CommandText = "UPDATE account_manager SET acc_status = 'Suspend' WHERE acc_id = @id";
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
                        cmd.CommandText = "UPDATE account_manager SET acc_status = 'Active' WHERE acc_id = @id";
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
                        cmd.CommandText = "UPDATE ACCOUNT_MANAGER SET ACC_STATUS = 'Deleted' WHERE ACC_ID = @id";
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