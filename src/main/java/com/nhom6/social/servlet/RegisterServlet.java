 package com.nhom6.social.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.nhom6.social.util.DBUtil;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        System.out.println("[DEBUG] Username nhận được: " + username);
        System.out.println("[DEBUG] Password nhận được: " + password);
        try (Connection conn = DBUtil.getConnection()) {
            // Kiểm tra username đã tồn tại chưa
            String checkSql = "SELECT id FROM users WHERE username = ?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setString(1, username);
            boolean exists = checkPs.executeQuery().next();
            System.out.println("[DEBUG] Username đã tồn tại? " + exists);
            if (exists) {
                response.sendRedirect("register.jsp?err=username_exists");
                return;
            }
            // Nếu chưa tồn tại thì insert
            String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, "user");
            int result = ps.executeUpdate();
            System.out.println("[DEBUG] Kết quả insert: " + result);
            if (result > 0) {
                response.sendRedirect("login.jsp?msg=register_success");
            } else {
                response.sendRedirect("register.jsp?err=register_fail");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?err=system_error");
        }
    }
}
