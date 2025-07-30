package com.nhom6.social.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        List<Post> posts = new ArrayList<>();
        List<User> users = new ArrayList<>();
        List<Integer> followedUserIds = new ArrayList<>(); // Thêm dòng này
        try (Connection conn = DBUtil.getConnection()) {
            // Lấy userId hiện tại
            int userId = (int) session.getAttribute("userId");
            // Lấy danh sách bài viết của chính mình và người đã follow, kèm username tác giả
            String sqlPost = "SELECT p.*, u.username FROM posts p JOIN users u ON p.user_id = u.id WHERE p.user_id = ? OR p.user_id IN (SELECT followed_user_id FROM follows WHERE following_user_id = ?) ORDER BY p.created_at DESC";
            PreparedStatement psPost = conn.prepareStatement(sqlPost);
            psPost.setInt(1, userId);
            psPost.setInt(2, userId);
            ResultSet rsPost = psPost.executeQuery();
            while (rsPost.next()) {
                posts.add(new Post(
                    rsPost.getInt("id"),
                    rsPost.getString("title"),
                    rsPost.getString("body"),
                    rsPost.getInt("user_id"),
                    rsPost.getString("status"),
                    rsPost.getString("created_at"),
                    rsPost.getString("username")
                ));
            }
            // Lấy danh sách người dùng (không bao gồm admin)
            String sqlUser = "SELECT * FROM users WHERE role != 'admin'";
            PreparedStatement psUser = conn.prepareStatement(sqlUser);
            ResultSet rsUser = psUser.executeQuery();
            while (rsUser.next()) {
                users.add(new User(
                    rsUser.getInt("id"),
                    rsUser.getString("username"),
                    null,
                    rsUser.getString("role"),
                    rsUser.getString("created_at")
                ));
            }
            // Lấy danh sách userId mà mình đã theo dõi
            String sqlFollowed = "SELECT followed_user_id FROM follows WHERE following_user_id = ?";
            PreparedStatement psFollowed = conn.prepareStatement(sqlFollowed);
            psFollowed.setInt(1, userId);
            ResultSet rsFollowed = psFollowed.executeQuery();
            while (rsFollowed.next()) {
                followedUserIds.add(rsFollowed.getInt("followed_user_id"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("posts", posts);
        request.setAttribute("users", users);
        request.setAttribute("followedUserIds", followedUserIds); // Thêm dòng này
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}