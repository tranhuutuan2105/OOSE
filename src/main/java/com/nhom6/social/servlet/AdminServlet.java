package com.nhom6.social.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.nhom6.social.model.Post;
import com.nhom6.social.model.User;
import com.nhom6.social.util.DBUtil;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("home.jsp");
            return;
        }
        List<User> users = new ArrayList<>();
        List<Post> posts = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            // Lấy danh sách user (không bao gồm admin)
            String userSql = "SELECT id, username, password, role, created_at FROM users WHERE role != 'admin' ORDER BY created_at DESC";
            PreparedStatement userPs = conn.prepareStatement(userSql);
            ResultSet userRs = userPs.executeQuery();
            while (userRs.next()) {
                users.add(new User(
                        userRs.getInt("id"),
                        userRs.getString("username"),
                        userRs.getString("password"),
                        userRs.getString("role"),
                        userRs.getString("created_at")
                ));
            }
            // Lấy danh sách bài viết của tất cả người dùng
            String postSql = "SELECT p.id, p.title, p.body, p.user_id, p.status, p.created_at, u.username FROM posts p JOIN users u ON p.user_id = u.id ORDER BY p.created_at DESC";
            PreparedStatement postPs = conn.prepareStatement(postSql);
            ResultSet postRs = postPs.executeQuery();
            while (postRs.next()) {
                Post post = new Post();
                post.setId(postRs.getInt("id"));
                post.setTitle(postRs.getString("title"));
                post.setBody(postRs.getString("body"));
                post.setUserId(postRs.getInt("user_id"));
                post.setStatus(postRs.getString("status"));
                post.setCreatedAt(postRs.getString("created_at"));
                post.setUsername(postRs.getString("username"));
                posts.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        request.setAttribute("users", users);
        request.setAttribute("posts", posts);
        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("home.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            // Xóa bài viết
            int postId = Integer.parseInt(request.getParameter("postId"));
            try (Connection conn = DBUtil.getConnection()) {
                String sql = "DELETE FROM posts WHERE id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, postId);
                int result = ps.executeUpdate();

                if (result > 0) {
                    response.sendRedirect("admin?msg=post_deleted");
                } else {
                    response.sendRedirect("admin?msg=delete_failed");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("admin?msg=error");
            }
        } else if ("delete_user".equals(action)) {
            // Xóa người dùng (logic từ UserManageServlet)
            int userId = Integer.parseInt(request.getParameter("userId"));
            try (Connection conn = DBUtil.getConnection()) {
                // Kiểm tra xem user có phải là admin không
                String checkSql = "SELECT role, username FROM users WHERE id=?";
                PreparedStatement checkPs = conn.prepareStatement(checkSql);
                checkPs.setInt(1, userId);
                var rs = checkPs.executeQuery();

                if (rs.next()) {
                    String role = rs.getString("role");
                    String username = rs.getString("username");

                    if ("admin".equals(role)) {
                        response.sendRedirect("admin?msg=not_allow_delete_admin");
                        return;
                    }

                    // Xóa user (database sẽ tự động xóa posts và follows nhờ CASCADE)
                    String deleteUserSql = "DELETE FROM users WHERE id=?";
                    PreparedStatement deleteUserPs = conn.prepareStatement(deleteUserSql);
                    deleteUserPs.setInt(1, userId);
                    int result = deleteUserPs.executeUpdate();

                    if (result > 0) {
                        response.sendRedirect("admin?msg=user_deleted&username=" + username);
                    } else {
                        response.sendRedirect("admin?msg=delete_failed");
                    }
                } else {
                    response.sendRedirect("admin?msg=user_not_found");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("admin?msg=error");
            }
        } else {
            response.sendRedirect("admin");
        }
    }
}