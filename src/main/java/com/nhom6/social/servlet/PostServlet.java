package com.nhom6.social.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.nhom6.social.util.DBUtil;

@WebServlet("/post")
public class PostServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String action = request.getParameter("action");

        try (Connection conn = DBUtil.getConnection()) {
            if ("edit".equals(action)) {
                // Xử lý sửa bài viết
                int postId = Integer.parseInt(request.getParameter("postId"));

                // Kiểm tra xem bài viết có thuộc về user này không
                String checkSql = "SELECT user_id FROM posts WHERE id = ?";
                PreparedStatement checkPs = conn.prepareStatement(checkSql);
                checkPs.setInt(1, postId);
                ResultSet rs = checkPs.executeQuery();

                if (rs.next() && rs.getInt("user_id") == userId) {
                    // Lấy thông tin bài viết để hiển thị form sửa
                    String getPostSql = "SELECT * FROM posts WHERE id = ?";
                    PreparedStatement getPostPs = conn.prepareStatement(getPostSql);
                    getPostPs.setInt(1, postId);
                    ResultSet postRs = getPostPs.executeQuery();

                    if (postRs.next()) {
                        com.nhom6.social.model.Post post = new com.nhom6.social.model.Post();
                        post.setId(postRs.getInt("id"));
                        post.setTitle(postRs.getString("title"));
                        post.setBody(postRs.getString("body"));
                        post.setUserId(postRs.getInt("user_id"));
                        post.setStatus(postRs.getString("status"));
                        post.setCreatedAt(postRs.getString("created_at"));
                        post.setUsername((String) session.getAttribute("username"));

                        // Lưu thông tin bài viết vào session để chuyển trang
                        session.setAttribute("editPost", post);
                        response.sendRedirect("edit-user-post.jsp");
                        return;
                    }
                }
                response.sendRedirect("home?msg=not_authorized");

            } else if ("delete".equals(action)) {
                // Xử lý xóa bài viết
                int postId = Integer.parseInt(request.getParameter("postId"));

                // Kiểm tra xem bài viết có thuộc về user này không
                String checkSql = "SELECT user_id FROM posts WHERE id = ?";
                PreparedStatement checkPs = conn.prepareStatement(checkSql);
                checkPs.setInt(1, postId);
                ResultSet rs = checkPs.executeQuery();

                if (rs.next() && rs.getInt("user_id") == userId) {
                    String deleteSql = "DELETE FROM posts WHERE id = ?";
                    PreparedStatement deletePs = conn.prepareStatement(deleteSql);
                    deletePs.setInt(1, postId);
                    int result = deletePs.executeUpdate();

                    if (result > 0) {
                        response.sendRedirect("home?msg=delete_success");
                    } else {
                        response.sendRedirect("home?msg=delete_failed");
                    }
                } else {
                    response.sendRedirect("home?msg=not_authorized");
                }

            } else if ("update".equals(action)) {
                // Xử lý cập nhật bài viết
                int postId = Integer.parseInt(request.getParameter("postId"));
                String title = request.getParameter("title");
                String body = request.getParameter("body");

                // Kiểm tra xem bài viết có thuộc về user này không
                String checkSql = "SELECT user_id FROM posts WHERE id = ?";
                PreparedStatement checkPs = conn.prepareStatement(checkSql);
                checkPs.setInt(1, postId);
                ResultSet rs = checkPs.executeQuery();

                if (rs.next() && rs.getInt("user_id") == userId) {
                    String updateSql = "UPDATE posts SET title = ?, body = ? WHERE id = ?";
                    PreparedStatement updatePs = conn.prepareStatement(updateSql);
                    updatePs.setString(1, title);
                    updatePs.setString(2, body);
                    updatePs.setInt(3, postId);
                    int result = updatePs.executeUpdate();

                    if (result > 0) {
                        response.sendRedirect("home?msg=update_success");
                    } else {
                        response.sendRedirect("home?msg=update_failed");
                    }
                } else {
                    response.sendRedirect("home?msg=not_authorized");
                }

            } else {
                // Xử lý đăng bài viết mới
                String title = request.getParameter("title");
                String body = request.getParameter("body");

                String sql = "INSERT INTO posts (title, body, user_id, status) VALUES (?, ?, ?, 'public')";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, title);
                ps.setString(2, body);
                ps.setInt(3, userId);
                int result = ps.executeUpdate();

                if (result > 0) {
                    response.sendRedirect("home?msg=post_success");
                } else {
                    response.sendRedirect("home?msg=post_failed");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("home?msg=error");
        }
    }
}