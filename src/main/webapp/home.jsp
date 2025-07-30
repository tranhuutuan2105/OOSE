<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nhom6.social.model.Post" %>
<%@ page import="com.nhom6.social.model.User" %>
<%
    String role = (String) session.getAttribute("role");
    if (role != null && role.equals("admin")) {
        response.sendRedirect("admin");
        return;
    }
    List<Post> posts = (List<Post>) request.getAttribute("posts");
    List<User> users = (List<User>) request.getAttribute("users");
    String username = (String) session.getAttribute("username");
    List<Integer> followedUserIds = (List<Integer>) request.getAttribute("followedUserIds");
%>
<html>
<head>
    <title>Trang chủ</title>
    <meta charset="UTF-8">
    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #f7f7f7;
            margin: 0;
            padding: 0;
        }
        .container {
            display: flex;
            flex-direction: row;
            justify-content: center;
            align-items: flex-start;
            margin: 30px auto;
            max-width: 1100px;
        }
        .posts-section {
            flex: 2;
            margin-right: 30px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
            padding: 24px;
        }
        .users-section {
            flex: 1;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
            padding: 24px;
        }
        .post-item {
            background: #f9f9f9;
            border-radius: 8px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.05);
            border: 1px solid #e0e0e0;
            margin-bottom: 22px;
            padding: 16px 18px 10px 18px;
        }
        .post-item:last-child {
            margin-bottom: 0;
        }
        .user-item {
            background: #f9f9f9;
            border-radius: 8px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.05);
            border: 1px solid #e0e0e0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 18px;
            padding: 10px 14px;
        }
        .user-item:last-child {
            margin-bottom: 0;
        }
        button {
            background: #1976d2;
            color: #fff;
            border: none;
            border-radius: 4px;
            padding: 6px 14px;
            cursor: pointer;
            font-size: 14px;
            transition: background 0.2s;
        }
        button[name="action"][value="unfollow"] {
            background: #e53935;
        }
        button:hover {
            opacity: 0.9;
        }
        .header-bar {
            background: #1976d2;
            color: #fff;
            padding: 16px 0;
            text-align: center;
            font-size: 22px;
            letter-spacing: 1px;
        }
        .logout-link {
            float: right;
            color: #fff;
            margin-right: 30px;
            text-decoration: none;
            font-size: 16px;
        }
        .logout-link:hover {
            text-decoration: underline;
        }
        .form-section {
            margin-bottom: 30px;
        }
        .success-msg {
            color: green;
            margin-bottom: 10px;
        }
        input, textarea {
            font-family: inherit;
            font-size: 15px;
            border-radius: 4px;
            border: 1px solid #ccc;
            padding: 6px 10px;
            margin-bottom: 8px;
            width: 100%;
            box-sizing: border-box;
        }
        textarea {
            min-height: 60px;
            resize: vertical;
        }
        label {
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="header-bar">
        Chào, <%= username %>!
        <a href="login.jsp" class="logout-link">Đăng xuất</a>
    </div>
    <div class="container">
        <div class="posts-section">
            <div class="form-section">
                <h3>Đăng bài mới</h3>
                <form method="post" action="post" accept-charset="UTF-8">
                    <label>Tiêu đề:</label>
                    <input type="text" name="title" required autocomplete="off">
                    <label>Nội dung:</label>
                    <textarea name="body" required></textarea>
                    <button type="submit">Đăng bài</button>
                </form>
                <% if (request.getParameter("msg") != null) { %>
                    <% if ("post_success".equals(request.getParameter("msg"))) { %>
                        <p class="success-msg">Đăng bài thành công!</p>
                    <% } else if ("update_success".equals(request.getParameter("msg"))) { %>
                        <p class="success-msg">Cập nhật bài viết thành công!</p>
                    <% } else if ("delete_success".equals(request.getParameter("msg"))) { %>
                        <p class="success-msg">Xóa bài viết thành công!</p>
                    <% } else if ("not_authorized".equals(request.getParameter("msg"))) { %>
                        <p style="color: red; margin-bottom: 10px;">Bạn không có quyền thực hiện hành động này!</p>
                    <% } %>
                <% } %>
            </div>
            <h3>Danh sách bài viết</h3>
            <% if (posts != null) for (Post p : posts) { %>
                <div class="post-item">
                    <b><%= p.getTitle() %></b> <span style="color:gray;">- bởi <%= p.getUsername() %></span><br>
                    <i><%= p.getCreatedAt() %></i><br>
                    <div><%= p.getBody() %></div>
                    <% if (p.getUsername().equals(username)) { %>
                        <div style="margin-top: 10px;">
                            <form method="post" action="post" style="display:inline;">
                                <input type="hidden" name="action" value="edit">
                                <input type="hidden" name="postId" value="<%= p.getId() %>">
                                <button type="submit" style="background: #fbc02d; color: #333; border: none; border-radius: 4px; padding: 4px 8px; cursor: pointer; margin-right: 5px;">Sửa</button>
                            </form>
                            <form method="post" action="post" style="display:inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="postId" value="<%= p.getId() %>">
                                <button type="submit" style="background: #e53935; color: #fff; border: none; border-radius: 4px; padding: 4px 8px; cursor: pointer;" onclick="return confirm('Bạn có chắc chắn muốn xóa bài viết này?')">Xóa</button>
                            </form>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
        <div class="users-section">
            <h3>Những người bạn có thể biết , hãy follow họ để xem nhiều bài viết</h3>
            <% if (users != null) for (User u : users) { %>
                <% if (!u.getUsername().equals(username)) { %>
                <div class="user-item">
                    <span><%= u.getUsername() %></span>
                    <form method="post" action="follow" style="display:inline; margin:0;">
                        <input type="hidden" name="followedUserId" value="<%= u.getId() %>">
                        <% if (followedUserIds != null && followedUserIds.contains(u.getId())) { %>
                            <button type="submit" name="action" value="unfollow">Hủy theo dõi</button>
                        <% } else { %>
                            <button type="submit" name="action" value="follow">Theo dõi</button>
                        <% } %>
                    </form>
                </div>
                <% } %>
            <% } %>
            <% if (request.getParameter("msg") != null && request.getParameter("msg").equals("follow_success")) { %>
                <p class="success-msg">Theo dõi thành công!</p>
            <% } %>
            <% if (request.getParameter("msg") != null && request.getParameter("msg").equals("unfollow_success")) { %>
                <p class="success-msg">Hủy theo dõi thành công!</p>
            <% } %>
        </div>
    </div>
</body>
</html> 