<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.nhom6.social.model.Post" %>
<%
    String role = (String) session.getAttribute("role");
    if (role != null && role.equals("admin")) {
        response.sendRedirect("admin");
        return;
    }
    Post post = (Post) session.getAttribute("editPost");
    if (post == null) {
        response.sendRedirect("home");
        return;
    }
    // Xóa thông tin bài viết khỏi session sau khi lấy
    session.removeAttribute("editPost");
%>
<html>
<head>
    <title>Sửa bài viết</title>
    <meta charset="UTF-8">
    <style>
        body { 
            font-family: Arial, sans-serif; 
            background: #f7f7f7; 
            margin: 0;
            padding: 0;
        }
        .container { 
            max-width: 700px; 
            margin: 40px auto; 
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
        }
        .header h2 {
            margin: 0;
            color: #fff;
        }
        .post-info {
            background: #e3f2fd;
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 24px;
        }
        .post-info p {
            margin: 8px 0;
            color: #1976d2;
        }
        label { 
            font-weight: bold; 
            color: #333;
            display: block;
            margin-bottom: 8px;
        }
        input, textarea { 
            width: 100%; 
            padding: 12px; 
            margin-bottom: 16px; 
            border-radius: 4px; 
            border: 1px solid #ccc; 
            font-size: 15px; 
            box-sizing: border-box;
            font-family: inherit;
        }
        textarea {
            min-height: 120px;
            resize: vertical;
        }
        .button-group {
            display: flex;
            gap: 12px;
            margin-top: 24px;
        }
        button { 
            background: #1976d2; 
            color: #fff; 
            border: none; 
            border-radius: 4px; 
            padding: 12px 24px; 
            cursor: pointer; 
            font-size: 15px; 
            transition: background 0.3s;
        }
        button:hover { 
            background: #1565c0;
        }
        .cancel-btn {
            background: #6c757d;
        }
        .cancel-btn:hover {
            background: #5a6268;
        }
        .back-link {
            display: inline-block;
            background: #6c757d;
            color: #fff;
            text-decoration: none;
            padding: 12px 24px;
            border-radius: 4px;
            margin-top: 16px;
            transition: background 0.3s;
        }
        .back-link:hover {
            background: #5a6268;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Sửa bài viết</h2>
        </div>
        
        <div class="post-info">
            <p><strong>Ngày tạo:</strong> <%= post.getCreatedAt() %></p>
        </div>
        
        <form method="post" action="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="postId" value="<%= post.getId() %>">
            
            <label>Tiêu đề:</label>
            <input type="text" name="title" value="<%= post.getTitle() %>" required>
            
            <label>Nội dung:</label>
            <textarea name="body" required><%= post.getBody() %></textarea>
            
            <div class="button-group">
                <button type="submit">Cập nhật bài viết</button>
                <button type="button" class="cancel-btn" onclick="history.back()">Hủy</button>
            </div>
        </form>
        
        <a href="home" class="back-link">← Về trang chủ</a>
    </div>
</body>
</html> 