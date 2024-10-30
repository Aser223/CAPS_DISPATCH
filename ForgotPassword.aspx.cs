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
    public partial class ForgotPassword : System.Web.UI.Page
    {
        private readonly string con = "Server=localhost;Port=5432;User Id=postgres;Password=123456;Database=trashtrack";

        protected void Page_Load(object sender, EventArgs e)
        {

        }
        public static string GenerateOTP(int length)
        {
            const string characters = "0123456789";
            byte[] data = new byte[length];

            using (var crypto = new RNGCryptoServiceProvider())
            {
                crypto.GetBytes(data);
            }

            var result = new StringBuilder(length);
            foreach (byte b in data)
            {
                result.Append(characters[b % characters.Length]);
            }

            return result.ToString();
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string otp = GenerateOTP(6);
            var client_email = emailtxt.Text.Trim();

            using (var conn = new NpgsqlConnection(con))
            {
                conn.Open();
                using (var cmd = new NpgsqlCommand("SELECT acc_email FROM account_manager WHERE acc_email = @Email", conn))
                {
                    cmd.Parameters.AddWithValue("Email", client_email);
                    var reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        reader.Close();
                        using (var updateCmd = new NpgsqlCommand("UPDATE account_manager SET acc_otp = @Otp WHERE acc_email = @Email", conn))
                        {
                            updateCmd.Parameters.AddWithValue("Otp", otp);
                            updateCmd.Parameters.AddWithValue("Email", client_email);
                            updateCmd.ExecuteNonQuery();
                            SendEmail(client_email, "Your OTP for Password Reset", $"Your OTP is: {otp}");
                            EnableOtpInputs(true);
                        }
                        Response.Write("<script>alert('OTP sent to your email.')</script>");
                    }
                    else
                    {
                        Response.Write("<script>alert('Email not found!')</script>");
                    }
                }
            }
        }

        protected void EnableOtpInputs(bool enable)
        {
            OTPtxt1.Enabled = OTPtxt2.Enabled = OTPtxt3.Enabled = OTPtxt4.Enabled = OTPtxt5.Enabled = OTPtxt6.Enabled = enable;
        }

        public static void SendEmail(string toAddress, string subject, string body)
        {
            SmtpClient smtpClient = new SmtpClient("smtp.gmail.com");
            smtpClient.UseDefaultCredentials = false;

            // Replace these credentials with your actual email and app password.
            smtpClient.Credentials = new NetworkCredential("fjunevincent369@gmail.com", "lgkw alyq ntyv mefw");
            smtpClient.EnableSsl = true;
            smtpClient.Port = 587;

            MailMessage mailMessage = new MailMessage();
            mailMessage.From = new MailAddress("fjunevincent369@gmail.com");
            mailMessage.To.Add(toAddress);
            mailMessage.Subject = subject;
            mailMessage.Body = body;
            mailMessage.IsBodyHtml = true;

            try
            {
                smtpClient.Send(mailMessage);
            }
            catch (Exception ex)
            {
                // Handle the exception in case the email fails to send
                Console.WriteLine($"Error sending email: {ex.Message}");
            }
        }


        //[System.Web.Services.WebMethod]
        //public static string VerifyOTP(string otpInput)
        //{
        //    string otp_input = otpInput; // directly use the input OTP
        //                                 // Assume you have access to the user's email from the session or another method
        //    var client_email = HttpContext.Current.Session["UserEmail"].ToString();

        //    using (var conn = new NpgsqlConnection(con))
        //    {
        //        conn.Open();
        //        using (var cmd = new NpgsqlCommand("SELECT acc_otp FROM account_manager WHERE acc_email = @Email", conn))
        //        {
        //            cmd.Parameters.AddWithValue("Email", client_email);
        //            var reader = cmd.ExecuteReader();
        //            if (reader.Read())
        //            {
        //                string stored_otp = reader.GetString(0);
        //                reader.Close();

        //                if (otp_input == stored_otp)
        //                {
        //                    // OTP verified successfully
        //                    return "OTP Verified. You can now change your password.";
        //                }
        //                else
        //                {
        //                    return "Invalid OTP.";
        //                }
        //            }
        //            else
        //            {
        //                return "Email not found.";
        //            }
        //        }
        //    }
        //}

        public void VerifyOTP()
        {
            string otp_input = OTPtxt1.Text + OTPtxt2.Text + OTPtxt3.Text + OTPtxt4.Text + OTPtxt5.Text + OTPtxt6.Text;
            var client_email = emailtxt.Text.Trim();

            using (var conn = new NpgsqlConnection(con))
            {
                conn.Open();
                using (var cmd = new NpgsqlCommand("SELECT acc_otp FROM account_manager WHERE acc_email = @Email", conn))
                {
                    cmd.Parameters.AddWithValue("Email", client_email);
                    var reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        string stored_otp = reader.GetString(0);
                        reader.Close();

                        if (otp_input == stored_otp)
                        {
                            EnablePasswordFields(true);
                            Response.Write("<script>alert('OTP Verified. You can now change your password.')</script>");
                        }
                        else
                        {
                            Response.Write("<script>alert('Invalid OTP.')</script>");
                        }
                    }
                }
            }
        }

        protected void EnablePasswordFields(bool enable)
        {
            changetxt.Enabled = confirmtxt.Enabled = changepassword.Enabled = enable;
        }

        private string HashPassword(string password)
        {
            using (var sha256 = SHA256.Create())
            {
                byte[] hashedBytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                var stringBuilder = new StringBuilder();
                foreach (byte b in hashedBytes)
                {
                    stringBuilder.Append(b.ToString("x2"));
                }
                return stringBuilder.ToString();
            }
        }


        protected void changepassword_Click(object sender, EventArgs e)
        {
            if (changetxt.Text == confirmtxt.Text)
            {
                string hashedPassword = HashPassword(changetxt.Text.Trim());
                var client_email = emailtxt.Text.Trim();

                using (var conn = new NpgsqlConnection(con))
                {
                    conn.Open();
                    using (var cmd = new NpgsqlCommand("UPDATE account_manager SET acc_password = @Password, acc_otp = NULL WHERE acc_email = @Email", conn))
                    {
                        cmd.Parameters.AddWithValue("Password", hashedPassword);
                        cmd.Parameters.AddWithValue("Email", client_email);
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            Response.Write("<script>alert('Password changed successfully!')</script>");
                        }
                        else
                        {
                            Response.Write("<script>alert('Error changing password.')</script>");
                        }
                    }
                }
            }
            else
            {
                lblResult.Text = "Passwords do not match!";
            }
        }


    }
}