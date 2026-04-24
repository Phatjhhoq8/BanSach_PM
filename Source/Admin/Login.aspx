<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Admin_Login" %>

<!DOCTYPE html>
<html lang="vi">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - BanSach Premium</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #0f172a; }
        .glass-login { background: rgba(30, 41, 59, 0.7); backdrop-filter: blur(20px); border: 1px solid rgba(255,255,255,0.1); }
    </style>
</head>
<body class="flex items-center justify-center min-h-screen p-6">
    <div class="w-full max-w-md">
        <div class="text-center mb-10">
            <div class="inline-flex items-center justify-center w-16 h-16 bg-blue-600 rounded-2xl shadow-xl shadow-blue-500/20 mb-6">
                <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path></svg>
            </div>
            <h1 class="text-3xl font-bold text-white tracking-tight">Admin Portal</h1>
            <p class="text-slate-400 mt-2">Đăng nhập để quản lý hệ thống bán sách</p>
        </div>

        <form id="form1" runat="server" class="glass-login p-8 rounded-[32px] shadow-2xl">
            <div class="space-y-6">
                <div>
                    <label class="block text-sm font-medium text-slate-300 mb-2">Tên đăng nhập</label>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="w-full bg-slate-900/50 border border-slate-700 text-white px-4 py-4 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition-all" placeholder="admin"></asp:TextBox>
                </div>
                <div>
                    <label class="block text-sm font-medium text-slate-300 mb-2">Mật khẩu</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="w-full bg-slate-900/50 border border-slate-700 text-white px-4 py-4 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition-all" placeholder="••••••••"></asp:TextBox>
                </div>
                <div class="flex items-center justify-between">
                    <label class="flex items-center gap-2 cursor-pointer group">
                        <input type="checkbox" class="w-4 h-4 rounded border-slate-700 bg-slate-900 text-blue-600 focus:ring-0">
                        <span class="text-sm text-slate-400 group-hover:text-slate-300 transition-colors">Ghi nhớ đăng nhập</span>
                    </label>
                </div>
                <asp:Button ID="btnLogin" runat="server" Text="Đăng nhập ngay" OnClick="btnLogin_Click" CssClass="w-full bg-blue-600 hover:bg-blue-500 text-white font-bold py-4 rounded-xl shadow-lg shadow-blue-600/30 transition-all active:scale-[0.98]" />
                
                <asp:Literal ID="litError" runat="server"></asp:Literal>
            </div>
        </form>

        <p class="text-center text-slate-500 text-sm mt-8">
            &copy; 2026 BanSach Premium Publisher. All rights reserved.
        </p>
    </div>
</body>
</html>
