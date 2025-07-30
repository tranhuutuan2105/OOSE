<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Đăng ký</title>
    <meta charset="UTF-8">
    <style>
        body {
            background: #f7f7f7;
            font-family: Arial, Helvetica, sans-serif;
            margin: 0;
            padding: 0;
        }
        .register-container {
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
    <div class="register-container">
        <h2>Đăng ký</h2>
        <form method="post" action="register" accept-charset="UTF-8">
            <label>Tên đăng nhập:</label>
            <input type="text" name="username" required autocomplete="off">
            <label>Mật khẩu:</label>
            <input type="password" name="password" required>
            <button type="submit">Đăng ký</button>
        </form>
        <a class="link" href="login.jsp">Đã có tài khoản? Đăng nhập</a>
        <% if (request.getParameter("err") != null) { 
            String err = request.getParameter("err");
            if ("username_exists".equals(err)) { %>
                <p class="error-msg">Tên đăng nhập đã tồn tại. Vui lòng chọn tên khác!</p>
            <% } else if ("system_error".equals(err)) { %>
                <p class="error-msg">Đăng ký thất bại do lỗi hệ thống. Vui lòng thử lại sau!</p>
            <% } else { %>
                <p class="error-msg">Đăng ký thất bại! Tên đăng nhập đã tồn tại hoặc lỗi hệ thống.</p>
            <% } 
        } %>
    </div>
</body>
</html> 