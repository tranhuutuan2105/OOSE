<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nhom6.social.model.User" %>
<%@ page import="com.nhom6.social.model.Post" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) {
        response.sendRedirect("home.jsp");
        return;
    }
    List<User> users = (List<User>) request.getAttribute("users");
    List<Post> posts = (List<Post>) request.getAttribute("posts");
%>
<html>
<head>
    <title>Quản trị Admin</title>
    <meta charset="UTF-8">
    <style>
        body { 
            font-family: Arial, sans-serif; 
            background: #f7f7f7; 
            margin: 0;
            padding: 0;
        }
        .container { 
            max-width: 1200px; 
            margin: 20px auto; 
            background: #fff; 
            border-radius: 8px; 
            box-shadow: 0 2px 8px rgba(0,0,0,0.07); 
            padding: 24px; 
        }
        .header {
            background: #1976d2;
            color: #fff;
            padding: 16px 24px;
            margin: -24px -24px 24px -24px;
            border-radius: 8px 8px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header h2 {
            margin: 0;
            color: #fff;
        }
        .logout-link { 
            color: #fff; 
            text-decoration: none; 
            font-size: 16px; 
            padding: 8px 16px;
            border: 1px solid #fff;
            border-radius: 4px;
            transition: all 0.3s;
        }
        .logout-link:hover { 
            background: #fff;
            color: #1976d2;
        }
        .section {
            margin-bottom: 40px;
        }
        .section h3 {
            color: #1976d2;
            border-bottom: 2px solid #1976d2;
            padding-bottom: 8px;
            margin-bottom: 20px;
        }
        table { 
            width: 100%; 
            border-collapse: collapse; 
            margin-bottom: 20px; 
            background: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        th, td { 
            border: 1px solid #e0e0e0; 
            padding: 12px 8px; 
            text-align: left; 
        }
        th { 
            background: #1976d2; 
            color: #fff; 
            font-weight: bold;
        }
        tr:nth-child(even) { 
            background: #f9f9f9; 
        }
        tr:hover {
            background: #f0f8ff;
        }
        .action-btn { 
            background: #1976d2; 
            color: #fff; 
            border: none; 
            border-radius: 4px; 
            padding: 6px 12px; 
            cursor: pointer; 
            margin-right: 4px; 
            font-size: 12px;
            transition: background 0.3s;
        }
        .action-btn:hover {
            opacity: 0.8;
        }
        .action-btn.delete { 
            background: #e53935; 
        }
        .status-pending {
            color: #f57c00;
            font-weight: bold;
        }
        .status-public {
            color: #43a047;
            font-weight: bold;
        }
        .home-link {
            display: inline-block;
            background: #1976d2;
            color: #fff;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 4px;
            margin-top: 20px;
            transition: background 0.3s;
        }
        .home-link:hover {
            background: #1565c0;
        }
        .stats {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: #e3f2fd;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            flex: 1;
        }
        .stat-number {
            font-size: 24px;
            font-weight: bold;
            color: #1976d2;
        }
        .stat-label {
            color: #666;
            margin-top: 5px;
        }
        .message {
            margin-bottom: 20px;
            padding: 12px;
            border-radius: 4px;
            font-weight: bold;
        }
        .message.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .message.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Quản trị Admin</h2>
            <a href="login.jsp" class="logout-link">Đăng xuất</a>
        </div>
        
        <div class="stats">
            <div class="stat-card">
                <div class="stat-number"><%= users != null ? users.size() : 0 %></div>
                <div class="stat-label">Tổng người dùng</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= posts != null ? posts.size() : 0 %></div>
                <div class="stat-label">Tổng bài viết</div>
            </div>
        </div>

        <% if (request.getParameter("msg") != null) { %>
            <div class="message <%= "user_deleted".equals(request.getParameter("msg")) || "post_deleted".equals(request.getParameter("msg")) ? "success" : "error" %>">
                <% if ("user_deleted".equals(request.getParameter("msg"))) { %>
                    ✓ Đã xóa người dùng <%= request.getParameter("username") %> thành công!
                <% } else if ("post_deleted".equals(request.getParameter("msg"))) { %>
                    ✓ Đã xóa bài viết thành công!
                <% } else if ("not_allow_delete_admin".equals(request.getParameter("msg"))) { %>
                    ✗ Không thể xóa tài khoản admin!
                <% } else if ("delete_failed".equals(request.getParameter("msg"))) { %>
                    ✗ Xóa thất bại!
                <% } else if ("user_not_found".equals(request.getParameter("msg"))) { %>
                    ✗ Không tìm thấy người dùng!
                <% } else if ("error".equals(request.getParameter("msg"))) { %>
                    ✗ Đã xảy ra lỗi!
                <% } %>
            </div>
        <% } %>

        <div class="section">
            <h3>Quản lý người dùng</h3>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Role</th>
                    <th>Ngày tạo</th>
                    <th>Hành động</th>
                </tr>
                <% if (users != null && !users.isEmpty()) { %>
                    <% for (User u : users) { %>
                        <tr>
                            <td><%= u.getId() %></td>
                            <td><%= u.getUsername() %></td>
                            <td><%= u.getRole() %></td>
                            <td><%= u.getCreatedAt() %></td>
                            <td>
                                <form method="post" action="admin" style="display:inline;">
                                    <input type="hidden" name="userId" value="<%= u.getId() %>">
                                    <button type="submit" name="action" value="delete_user" class="action-btn delete" 
                                            onclick="return confirm('Bạn có chắc chắn muốn xóa người dùng <%= u.getUsername() %>?')">
                                        Xóa
                                    </button>
                                </form>
                            </td>
                        </tr>
                    <% } %>
                <% } else { %>
                    <tr>
                        <td colspan="5" style="text-align: center; color: #666;">Chưa có người dùng nào</td>
                    </tr>
                <% } %>
            </table>
        </div>

        <div class="section">
            <h3>Quản lý bài viết</h3>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Tiêu đề</th>
                    <th>Người đăng</th>
                    <th>Ngày tạo</th>
                    <th>Hành động</th>
                </tr>
                <% if (posts != null && !posts.isEmpty()) { %>
                    <% for (Post p : posts) { %>
                        <tr>
                            <td><%= p.getId() %></td>
                            <td><%= p.getTitle() %></td>
                            <td><%= p.getUsername() %></td>
                            <td><%= p.getCreatedAt() %></td>
                            <td>
                                <form method="post" action="admin" style="display:inline;">
                                    <input type="hidden" name="postId" value="<%= p.getId() %>">
                                    <button type="submit" name="action" value="delete" class="action-btn delete"
                                            onclick="return confirm('Bạn có chắc chắn muốn xóa bài viết này?')">
                                        Xóa
                                    </button>
                                </form>
                            </td>
                        </tr>
                    <% } %>
                <% } else { %>
                    <tr>
                        <td colspan="5" style="text-align: center; color: #666;">Chưa có bài viết nào</td>
                    </tr>
                <% } %>
            </table>
        </div>
    </div>
</body>
</html> 