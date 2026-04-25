<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Admin_Login" %>

<!DOCTYPE html>
<html lang="vi">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - The Book Haven</title>
    <script>
        (function () {
            var savedTheme = null;
            try {
                savedTheme = localStorage.getItem('admin-theme');
            } catch (e) {
            }

            document.documentElement.setAttribute('data-theme', savedTheme === 'light' ? 'light' : 'dark');
        })();
    </script>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        :root {
            --admin-bg-start: oklch(8% 0.018 278);
            --admin-bg-mid: oklch(10% 0.02 278);
            --admin-bg-end: oklch(7% 0.014 274);
            --admin-glow-1: oklch(31% 0.13 250 / 0.24);
            --admin-glow-2: oklch(30% 0.11 235 / 0.2);
            --admin-star: rgba(255,255,255,0.72);
            --admin-text: oklch(95% 0.018 272);
            --admin-text-soft: oklch(78% 0.03 274);
            --admin-border: oklch(34% 0.055 284 / 0.72);
            --admin-panel-top: oklch(18% 0.035 282 / 0.8);
            --admin-panel-bottom: oklch(14% 0.028 278 / 0.84);
            --admin-input: oklch(12% 0.024 278 / 0.92);
            --admin-accent: oklch(68% 0.18 250);
            --admin-accent-2: oklch(72% 0.15 235);
            --admin-pill-text: oklch(8% 0.012 278);
        }

        html[data-theme='light'] {
            --admin-bg-start: oklch(95% 0.012 268);
            --admin-bg-mid: oklch(98% 0.008 270);
            --admin-bg-end: oklch(93% 0.02 252);
            --admin-glow-1: oklch(86% 0.06 250 / 0.34);
            --admin-glow-2: oklch(88% 0.05 235 / 0.28);
            --admin-star: rgba(255,255,255,0.42);
            --admin-text: oklch(24% 0.03 272);
            --admin-text-soft: oklch(52% 0.026 270);
            --admin-border: oklch(80% 0.02 270 / 0.9);
            --admin-panel-top: oklch(100% 0 0 / 0.82);
            --admin-panel-bottom: oklch(97% 0.01 270 / 0.9);
            --admin-input: oklch(100% 0 0 / 0.96);
            --admin-pill-text: oklch(18% 0.025 272);
        }

        body {
            background:
                radial-gradient(circle at 12% 18%, var(--admin-glow-1), transparent 20%),
                radial-gradient(circle at 85% 12%, var(--admin-glow-2), transparent 22%),
                linear-gradient(180deg, var(--admin-bg-start), var(--admin-bg-mid) 48%, var(--admin-bg-end));
            color: var(--admin-text);
            font-family: 'Inter', sans-serif;
        }

        body::before {
            background-image:
                radial-gradient(circle at 12% 18%, var(--admin-star) 0 1.05px, transparent 1.35px),
                radial-gradient(circle at 72% 26%, color-mix(in srgb, var(--admin-star) 82%, transparent) 0 0.95px, transparent 1.25px),
                radial-gradient(circle at 34% 78%, color-mix(in srgb, var(--admin-star) 70%, transparent) 0 1.15px, transparent 1.45px),
                radial-gradient(circle at 86% 62%, color-mix(in srgb, var(--admin-star) 64%, transparent) 0 0.85px, transparent 1.15px);
            content: '';
            inset: 0;
            pointer-events: none;
            position: fixed;
            z-index: -1;
        }

        .glass-login {
            background: linear-gradient(180deg, var(--admin-panel-top), var(--admin-panel-bottom));
            backdrop-filter: blur(20px);
            border: 1px solid var(--admin-border);
            box-shadow: 0 18px 48px oklch(2% 0.01 278 / 0.3);
        }

        .admin-input {
            background: var(--admin-input);
            border: 1px solid var(--admin-border);
            color: var(--admin-text);
        }

        .theme-toggle {
            align-items: center;
            background: linear-gradient(180deg, var(--admin-panel-top), var(--admin-panel-bottom));
            border: 1px solid var(--admin-border);
            border-radius: 999px;
            color: var(--admin-text-soft);
            display: inline-flex;
            gap: 0.625rem;
            padding: 0.65rem 1rem;
        }

        .theme-toggle:hover {
            color: var(--admin-text);
        }
    </style>
</head>
<body class="flex min-h-screen items-center justify-center p-6">
    <div class="w-full max-w-md">
        <div class="mb-6 flex justify-end">
            <button type="button" class="theme-toggle text-sm font-bold" onclick="toggleAdminTheme()" aria-label="Chuyển chế độ sáng tối">
                <i data-lucide="moon-star" class="h-4 w-4" data-theme-icon></i>
                <span id="themeToggleLabel">Dark mode</span>
            </button>
        </div>

        <div class="mb-10 text-center">
            <div class="mb-6 inline-flex h-16 w-16 items-center justify-center rounded-2xl text-[var(--admin-pill-text)] shadow-xl" style="background:linear-gradient(135deg,var(--admin-accent),var(--admin-accent-2)); box-shadow:0 18px 38px oklch(27% 0.12 250 / 0.35);">
                <svg class="h-8 w-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path></svg>
            </div>
            <h1 class="text-3xl font-bold tracking-tight" style="color:var(--admin-text);">Admin Portal</h1>
            <p class="mt-2" style="color:var(--admin-text-soft);">Đăng nhập để quản lý hệ thống bán sách</p>
        </div>

        <form id="form1" runat="server" class="glass-login rounded-[32px] p-8 shadow-2xl">
            <div class="space-y-6">
                <div>
                    <label class="mb-2 block text-sm font-medium" style="color:var(--admin-text);">Tên đăng nhập</label>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="admin-input w-full rounded-xl px-4 py-4 outline-none transition-all focus:border-transparent focus:ring-2 focus:ring-blue-400" placeholder="admin"></asp:TextBox>
                </div>
                <div>
                    <label class="mb-2 block text-sm font-medium" style="color:var(--admin-text);">Mật khẩu</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="admin-input w-full rounded-xl px-4 py-4 outline-none transition-all focus:border-transparent focus:ring-2 focus:ring-blue-400" placeholder="••••••••"></asp:TextBox>
                </div>
                <div class="flex items-center justify-between">
                    <label class="group flex cursor-pointer items-center gap-2">
                        <input type="checkbox" class="h-4 w-4 rounded" style="border-color:var(--admin-border); background:var(--admin-input); color:var(--admin-accent);">
                        <span class="text-sm transition-colors group-hover:opacity-100" style="color:var(--admin-text-soft);">Ghi nhớ đăng nhập</span>
                    </label>
                </div>
                <asp:Button ID="btnLogin" runat="server" Text="Đăng nhập ngay" OnClick="btnLogin_Click" CssClass="w-full rounded-xl py-4 font-bold transition-all active:scale-[0.98]" style="background:linear-gradient(135deg,var(--admin-accent),var(--admin-accent-2)); color:var(--admin-pill-text); box-shadow:0 18px 38px oklch(27% 0.12 250 / 0.35);" />

                <asp:Literal ID="litError" runat="server"></asp:Literal>
            </div>
        </form>

        <p class="mt-8 text-center text-sm" style="color:var(--admin-text-soft);">
            &copy; 2026 The Book Haven. All rights reserved.
        </p>
    </div>

    <script>
        function applyAdminThemeUi(theme) {
            var label = document.getElementById('themeToggleLabel');
            var icon = document.querySelector('[data-theme-icon]');
            if (label) {
                label.textContent = theme === 'light' ? 'Light mode' : 'Dark mode';
            }

            if (icon) {
                icon.setAttribute('data-lucide', theme === 'light' ? 'sun-medium' : 'moon-star');
                if (window.lucide) {
                    lucide.createIcons();
                }
            }
        }

        function toggleAdminTheme() {
            var currentTheme = document.documentElement.getAttribute('data-theme') === 'light' ? 'light' : 'dark';
            var nextTheme = currentTheme === 'light' ? 'dark' : 'light';
            document.documentElement.setAttribute('data-theme', nextTheme);
            try {
                localStorage.setItem('admin-theme', nextTheme);
            } catch (e) {
            }
            applyAdminThemeUi(nextTheme);
        }

        lucide.createIcons();
        applyAdminThemeUi(document.documentElement.getAttribute('data-theme') === 'light' ? 'light' : 'dark');
    </script>
</body>
</html>
