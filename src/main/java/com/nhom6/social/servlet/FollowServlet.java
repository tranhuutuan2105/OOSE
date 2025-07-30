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
import javax.servlet.http.HttpSession;

import com.nhom6.social.util.DBUtil;

@WebServlet("/follow")
public class FollowServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        int followingUserId = (int) session.getAttribute("userId");
        int followedUserId = Integer.parseInt(request.getParameter("followedUserId"));
        String action = request.getParameter("action"); // Lấy action
        try (Connection conn = DBUtil.getConnection()) {
            if ("unfollow".equals(action)) {
                String sql = "DELETE FROM follows WHERE following_user_id = ? AND followed_user_id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, followingUserId);
                ps.setInt(2, followedUserId);
                ps.executeUpdate();
                response.sendRedirect("home?msg=unfollow_success");
            } else {
                String sql = "INSERT IGNORE INTO follows (following_user_id, followed_user_id) VALUES (?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, followingUserId);
                ps.setInt(2, followedUserId);
                ps.executeUpdate();
                response.sendRedirect("home?msg=follow_success");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("home?err=follow_fail");
        }
    }
}