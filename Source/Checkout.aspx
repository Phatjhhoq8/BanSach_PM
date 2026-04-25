<%@ Page Title="Thanh toán - The Book Haven" Language="C#" MasterPageFile="Site.Master" AutoEventWireup="true" CodeFile="Checkout.aspx.cs" Inherits="Checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <section class="container-page py-10 lg:py-16">
        <div class="mb-10">
            <p class="eyebrow">Thanh toán</p>
            <h1 class="mt-3 text-4xl font-bold sm:text-5xl">Hoàn tất đặt hàng</h1>
            <p class="mt-4 max-w-2xl text-[var(--ink-soft)]">Kiểm tra thông tin giao hàng, áp dụng mã ưu đãi nếu có và xác nhận đơn sách.</p>
            <div class="mt-6 flex flex-wrap gap-2 text-xs font-black uppercase tracking-[0.12em] text-[var(--muted)]">
                <span class="rounded-full bg-[var(--paper)] px-4 py-2">Giỏ hàng</span>
                <span class="rounded-full bg-[var(--primary)] px-4 py-2 text-white">Giao hàng</span>
                <span class="rounded-full bg-[var(--paper)] px-4 py-2">Xác nhận</span>
            </div>
        </div>

        <asp:Literal ID="litError" runat="server"></asp:Literal>

        <div class="grid gap-8 lg:grid-cols-[1fr_25rem]">
            <div class="space-y-8">
                <section class="surface-panel p-6 sm:p-8">
                    <div class="mb-6 flex items-center gap-3">
                        <span class="flex h-9 w-9 items-center justify-center rounded-full bg-[var(--primary)] text-sm font-black text-[oklch(98%_0.012_78)]">1</span>
                        <h2 class="text-2xl font-bold">Thông tin giao hàng</h2>
                    </div>
                    <div class="grid gap-5 md:grid-cols-2">
                        <div class="md:col-span-2">
                            <label class="mb-2 block text-sm font-extrabold text-[var(--ink-soft)]">Họ tên người nhận</label>
                            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="Nguyễn Văn A"></asp:TextBox>
                            <span id="errFullName" class="ux-field-error" aria-live="polite"></span>
                        </div>
                        <div>
                            <label class="mb-2 block text-sm font-extrabold text-[var(--ink-soft)]">Số điện thoại</label>
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="0901234567"></asp:TextBox>
                            <span id="errPhone" class="ux-field-error" aria-live="polite"></span>
                        </div>
                        <div>
                            <label class="mb-2 block text-sm font-extrabold text-[var(--ink-soft)]">Email nhận thông báo</label>
                            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" placeholder="example@gmail.com"></asp:TextBox>
                            <span id="errEmail" class="ux-field-error" aria-live="polite"></span>
                        </div>
                        <div class="md:col-span-2">
                            <label class="mb-2 block text-sm font-extrabold text-[var(--ink-soft)]">Địa chỉ giao hàng</label>
                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" placeholder="Số nhà, tên đường, phường/xã..."></asp:TextBox>
                            <span id="errAddress" class="ux-field-error" aria-live="polite"></span>
                        </div>
                        <div class="md:col-span-2">
                            <label class="mb-2 block text-sm font-extrabold text-[var(--ink-soft)]">Ghi chú thêm</label>
                            <asp:TextBox ID="txtNote" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" placeholder="Lời nhắn cho nhà sách hoặc shipper..."></asp:TextBox>
                        </div>
                    </div>
                </section>

                <section class="surface-panel p-6 sm:p-8">
                    <div class="mb-6 flex items-center gap-3">
                        <span class="flex h-9 w-9 items-center justify-center rounded-full bg-[var(--primary)] text-sm font-black text-[oklch(98%_0.012_78)]">2</span>
                        <h2 class="text-2xl font-bold">Phương thức thanh toán</h2>
                    </div>
                    <div class="space-y-4">
                        <label class="flex cursor-pointer items-start gap-4 rounded-3xl border border-[var(--line)] bg-[var(--paper)] p-5 hover:border-[var(--primary)]">
                            <asp:RadioButton ID="rbCOD" runat="server" GroupName="Payment" Checked="true" />
                            <span class="flex-1">
                                <span class="block font-black text-[var(--ink)]">Thanh toán khi nhận hàng (COD)</span>
                                <span class="mt-1 block text-sm text-[var(--muted)]">Bạn thanh toán bằng tiền mặt cho shipper khi nhận sách.</span>
                            </span>
                        </label>
                        <label class="flex cursor-not-allowed items-start gap-4 rounded-3xl border border-dashed border-[var(--line)] bg-[var(--paper)] p-5 opacity-65">
                            <asp:RadioButton ID="rbBank" runat="server" GroupName="Payment" Enabled="false" />
                            <span class="flex-1">
                                <span class="block font-black text-[var(--ink)]">Chuyển khoản ngân hàng <span class="text-xs uppercase tracking-[0.12em] text-[var(--muted)]">Sắp ra mắt</span></span>
                                <span class="mt-1 block text-sm text-[var(--muted)]">Phương thức này sẽ được mở rộng sau.</span>
                            </span>
                        </label>
                    </div>
                </section>
            </div>

            <aside>
                <div class="surface-panel sticky top-28 p-6 sm:p-8">
                    <h2 class="text-2xl font-bold">Tóm tắt đơn hàng</h2>
                    <div class="mt-6 max-h-72 space-y-4 overflow-y-auto pr-1">
                        <asp:Repeater ID="rptSummaryItems" runat="server">
                            <ItemTemplate>
                                <div class="flex gap-3">
                                    <div class="book-cover aspect-[3/4] w-14 flex-shrink-0 rounded-xl p-1.5">
                                        <img src='<%# Eval("HinhAnh") %>' onerror="this.src='https://placehold.co/400x550/f8f1e3/3b3028?text=Book';" alt='<%# Eval("TenSP") %>' class="h-full w-full" loading="lazy" />
                                    </div>
                                    <div class="min-w-0 flex-1">
                                        <h4 class="line-clamp-2 text-sm font-black"><%# Eval("TenSP") %></h4>
                                        <p class="mt-1 text-xs text-[var(--muted)]">SL: <%# Eval("SoLuong") %> x <%# Eval("DonGia", "{0:N0}đ") %></p>
                                    </div>
                                    <div class="text-sm font-black"><%# Eval("ThanhTien", "{0:N0}đ") %></div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                    <div class="mt-6 rounded-3xl bg-[var(--paper)] p-4">
                        <label class="mb-2 block text-xs font-black uppercase tracking-[0.12em] text-[var(--muted)]">Mã ưu đãi</label>
                        <div class="flex gap-2">
                            <asp:TextBox ID="txtCoupon" runat="server" CssClass="form-control min-h-11 rounded-full text-sm" placeholder="SALE10 hoặc FREESHIP"></asp:TextBox>
                            <asp:Button ID="btnApplyCoupon" runat="server" Text="Áp dụng" OnClick="btnApplyCoupon_Click" CssClass="btn-secondary min-h-11 px-4 text-sm" />
                        </div>
                        <asp:Literal ID="litCouponMessage" runat="server"></asp:Literal>
                    </div>

                    <div class="mt-6 space-y-3 border-t border-[var(--line)] pt-6 text-sm">
                        <div class="flex justify-between gap-4">
                            <span class="text-[var(--muted)]">Tạm tính</span>
                            <span class="font-black"><asp:Literal ID="litSubtotal" runat="server">0đ</asp:Literal></span>
                        </div>
                        <div class="flex justify-between gap-4">
                            <span class="text-[var(--muted)]">Vận chuyển</span>
                            <span class="font-black"><asp:Literal ID="litShipping" runat="server">30.000đ</asp:Literal></span>
                        </div>
                        <div class="flex justify-between gap-4">
                            <span class="text-[var(--muted)]">Giảm giá</span>
                            <span class="font-black text-[var(--success)]"><asp:Literal ID="litDiscountAmount" runat="server">0đ</asp:Literal></span>
                        </div>
                    </div>

                    <div class="mt-6 flex justify-between gap-4 text-xl font-black">
                        <span>Tổng thanh toán</span>
                        <span class="price-text"><asp:Literal ID="litTotal" runat="server">0đ</asp:Literal></span>
                    </div>

                    <asp:Button ID="btnOrder" runat="server" Text="Xác nhận đặt hàng" OnClick="btnOrder_Click" OnClientClick="return validateCheckoutClient(this);" CssClass="btn-primary mt-8 w-full py-4 text-base" />
                    <p class="mt-5 text-center text-xs leading-6 text-[var(--muted)]">Bằng cách đặt hàng, bạn đồng ý với điều khoản mua sách và chính sách xử lý đơn của The Book Haven.</p>
                </div>
            </aside>
        </div>
    </section>
    <script>
        function getCheckoutInput(serverIdSuffix) {
            return document.querySelector('[id$="' + serverIdSuffix + '"]');
        }

        function setCheckoutError(id, message) {
            const el = document.getElementById(id);
            if (el) el.innerText = message || '';
        }

        function validateCheckoutClient(btn) {
            const fullName = getCheckoutInput('txtFullName');
            const phone = getCheckoutInput('txtPhone');
            const email = getCheckoutInput('txtEmail');
            const address = getCheckoutInput('txtAddress');
            let firstInvalid = null;

            setCheckoutError('errFullName', '');
            setCheckoutError('errPhone', '');
            setCheckoutError('errEmail', '');
            setCheckoutError('errAddress', '');

            if (!fullName || !fullName.value.trim()) {
                setCheckoutError('errFullName', 'Vui lòng nhập họ tên người nhận.');
                firstInvalid = firstInvalid || fullName;
            }

            if (!phone || !/^[0-9+\-\s]{9,15}$/.test(phone.value.trim())) {
                setCheckoutError('errPhone', 'Số điện thoại chưa hợp lệ.');
                firstInvalid = firstInvalid || phone;
            }

            if (email && email.value.trim() && email.value.indexOf('@') < 0) {
                setCheckoutError('errEmail', 'Email nhận thông báo chưa hợp lệ.');
                firstInvalid = firstInvalid || email;
            }

            if (!address || !address.value.trim()) {
                setCheckoutError('errAddress', 'Vui lòng nhập địa chỉ giao hàng.');
                firstInvalid = firstInvalid || address;
            }

            if (firstInvalid) {
                firstInvalid.focus();
                AppUX.showToast('Vui lòng kiểm tra lại thông tin giao hàng.', 'error');
                return false;
            }

            btn.value = 'Đang tạo đơn...';
            setTimeout(() => { btn.disabled = true; }, 0);
            return true;
        }
    </script>
</asp:Content>
