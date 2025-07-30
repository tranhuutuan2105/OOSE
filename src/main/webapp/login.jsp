<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Đăng nhập</title>
    <meta charset="UTF-8">
    <style>
        body {
            background: #f7f7f7;
            font-family: Arial, Helvetica, sans-serif;
            margin: 0;
            padding: 0;
        }
        .login-container {
            max-width: 400px;
            margin: 60px auto;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.10);
            padding: 36px 32px 28px 32px;
        }
        h2 {
            text-align: center;
            color: #1976d2;
            margin-bottom: 28px;
        }
        label {
            font-weight: bold;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 8px 12px;
            margin: 8px 0 18px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 15px;
        }
        button {
            width: 100%;
            background: #1976d2;
            color: #fff;
            border: none;
            border-radius: 5px;
            padding: 10px 0;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            margin-bottom: 10px;
            transition: background 0.2s;
        }
        button:hover {
            background: #1256a3;
        }
        .link {
            display: block;
            text-align: center;
            margin-top: 10px;
            color: #1976d2;
            text-decoration: none;
        }
        .link:hover {
            text-decoration: underline;
        }
        .error-msg {
            color: #e53935;
            text-align: center;
            margin-bottom: 10px;
        }
        .success-msg {
            color: green;
            text-align: center;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Đăng nhập</h2>
        <form method="post" action="login" accept-charset="UTF-8">
            <label>Tên đăng nhập:</label>
            <input type="text" name="username" required autocomplete="off">
            <label>Mật khẩu:</label>
            <input type="password" name="password" required>
            <button type="submit">Đăng nhập</button>
        </form>
        <a class="link" href="register.jsp">Bạn chưa có tài khoản? Đăng ký</a>
        <% if (request.getParameter("err") != null) { %>
            <p class="error-msg">Sai tài khoản hoặc mật khẩu!</p>
        <% } %>
        <% if (request.getParameter("msg") != null && request.getParameter("msg").equals("register_success")) { %>
            <p class="success-msg">Đăng ký thành công! Hãy đăng nhập.</p>
        <% } %>
    </div>
</body>
</html> 