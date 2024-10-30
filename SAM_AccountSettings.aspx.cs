using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text.Json;
using System.Text;
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
    public partial class SAM_AccountSettings : System.Web.UI.Page
    {
        // Database Connection String
        private readonly string con = "Server=localhost;Port=5432;User Id=postgres;Password=123456;Database=trashtrack";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //AccountManList();
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

        //protected void AccountManList()
        //{
        //    using (var db = new NpgsqlConnection(con))
        //    {
        //        db.Open();
        //        using (var cmd = db.CreateCommand())
        //        {
        //            cmd.CommandType = CommandType.Text;
        //            // Modified the query to match the column names in the account_manager table
        //            cmd.CommandText = "SELECT * FROM account_manager WHERE acc_status != 'Deleted' AND acc_id != @id ORDER BY acc_id, acc_status";
        //            cmd.Parameters.AddWithValue("@id", Convert.ToInt32(Session["id"]));

        //            DataTable admin_datatable = new DataTable();
        //            NpgsqlDataAdapter admin_sda = new NpgsqlDataAdapter(cmd);
        //            admin_sda.Fill(admin_datatable);

        //            gridViewAccountMan.DataSource = admin_datatable; ;
        //            gridViewAccountMan.DataBind();
        //        }

        //        db.Close();
        //    }
        //}


        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] hashedBytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));

                // Convert the hashed bytes to a hexadecimal string
                StringBuilder stringBuilder = new StringBuilder();
                for (int i = 0; i < hashedBytes.Length; i++)
                {
                    stringBuilder.Append(hashedBytes[i].ToString("x2"));
                }

                return stringBuilder.ToString();
            }
        }

        protected void changepassword_Click(object sender, EventArgs e)
        {
            // Get admin ID from session
            int samId = (int)Session["sam_id"];


            //// Store necessary session data
            //Session["sam_email"] = loginEmail;
            //Session["sam_password"] = storedHashedPassword;
            //Session["sam_id"] = userId;  // Store the user ID in the session


            string currentPass = currentpassword.Text.Trim();
            string newPass = changetxt.Text.Trim();

            // Hash the entered current password
            string hashedCurrentPassword = HashPassword(currentPass);

            using (var db = new NpgsqlConnection(con))
            {
                db.Open();

                // Query to get the current password for the user
                string selectQuery = "SELECT acc_password FROM account_manager WHERE acc_id = @adminId";
                using (var cmdSelect = new NpgsqlCommand(selectQuery, db))
                {
                    cmdSelect.Parameters.AddWithValue("@adminId", samId);

                    var storedPassword = cmdSelect.ExecuteScalar()?.ToString();

                    // Check if the current password matches the stored password
                    if (storedPassword == hashedCurrentPassword)
                    {
                        // Passwords match, update the password
                        string hashedNewPassword = HashPassword(newPass);

                        // Query to update the password
                        string updateQuery = "UPDATE account_manager SET acc_password = @newPassword WHERE acc_id = @adminId";
                        using (var cmdUpdate = new NpgsqlCommand(updateQuery, db))
                        {
                            cmdUpdate.Parameters.AddWithValue("@newPassword", hashedNewPassword);
                            cmdUpdate.Parameters.AddWithValue("@adminId", samId);

                            int rowsAffected = cmdUpdate.ExecuteNonQuery();

                            if (rowsAffected > 0)
                            {
                                // Password updated successfully
                                Response.Write("<script>alert('Password changed successfully!')</script>");
                            }
                            else
                            {
                                // Error updating the password
                                Response.Write("<script>alert('Error: Unable to update password!')</script>");
                            }
                        }
                    }
                    else
                    {
                        // Current password does not match the stored password
                        Response.Write("<script>alert('Error: Incorrect current password!')</script>");
                    }
                }
            }
        }

    }
}