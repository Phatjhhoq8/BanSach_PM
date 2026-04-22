<%@ Page Title="Giỏ Hàng - Nhà Sách Premium" Language="C#" MasterPageFile="Site.master" AutoEventWireup="true" CodeFile="GioHang.aspx.cs" Inherits="GioHang" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
        <h1 class="text-3xl font-bold text-gray-900 mb-8 border-b pb-4">Giỏ hàng của bạn</h1>

        <div class="flex flex-col lg:flex-row gap-8">
            <!-- Danh sách sản phẩm -->
            <div class="w-full lg:w-2/3">
                <div class="bg-white rounded-lg shadow overflow-hidden">
                    <ul class="divide-y divide-gray-200">
                        <!-- Vòng lặp các sản phẩm trong giỏ (Dùng Repeater) -->
                        <asp:Repeater ID="rptCart" runat="server">
                            <ItemTemplate>
                            <li class="p-6 flex items-center">
                                <img src='<%# "img/books/" + Eval("HinhAnh") %>' onerror="this.src='https://via.placeholder.com/100x150'" class="w-20 h-28 object-cover rounded shadow" alt='<%# Eval("TenSP") %>'>
                                <div class="ml-6 flex-1">
                                    <h3 class="text-xl font-bold text-gray-900"><%# Eval("TenSP") %></h3>
                                    <p class="text-primary font-medium mt-1"><%# string.Format("{0:N0} đ", Eval("Gia")) %></p>
                                </div>
                                <div class="flex items-center space-x-4">
                                    Mã SP: <%# Eval("MaSP") %> | SL: 1
                                    <!-- Nút xoá gọi ajax -->
                                    <button type="button" onclick='removeFromCart(<%# Eval("MaSP") %>)' class="text-red-500 hover:text-red-700 font-medium ml-4 uppercase text-sm">Xóa</button>
                                </div>
                            </li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>
                    <asp:Label ID="lblCartEmpty" runat="server" Text="Giỏ hàng hiện trống." Visible="false" CssClass="p-6 block text-center text-gray-500 italic"></asp:Label>
                </div>
            </div>

            <!-- Tổng kết hóa đơn (Order Summary) -->
            <div class="w-full lg:w-1/3">
                <div class="bg-gray-100 rounded-lg p-6 shadow sticky top-6">
                    <h2 class="text-lg font-bold text-gray-900 mb-4">Tóm tắt đơn hàng</h2>
                    <div class="flex justify-between mb-2">
                        <span class="text-gray-600">Tổng phụ</span>
                        <span class="font-medium text-gray-900"><asp:Label ID="lblSubTotal" runat="server" Text="0 đ"></asp:Label></span>
                    </div>
                    <div class="flex justify-between mb-4 border-b border-gray-300 pb-4">
                        <span class="text-gray-600">Phí giao hàng</span>
                        <span class="font-medium text-green-600">Miễn phí</span>
                    </div>
                    <div class="flex justify-between items-center mb-6">
                        <span class="text-xl font-bold text-gray-900">Tổng cộng</span>
                        <span class="text-2xl font-black text-primary"><asp:Label ID="lblTotal" runat="server" Text="0 đ"></asp:Label></span>
                    </div>
                    <asp:Button ID="btnCheckout" runat="server" Text="TIẾN HÀNH THANH TOÁN" CssClass="w-full bg-primary text-white py-4 rounded-xl uppercase font-bold hover:bg-secondary transition-all shadow-lg shadow-primary/20" OnClick="btnCheckout_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsContent" Runat="Server">
    <script>
        function removeFromCart(maSP) {
            let formData = new URLSearchParams();
            formData.append("action", "remove");
            formData.append("maSP", maSP);

            fetch("CartHandler.ashx", {
                method: "POST",
                body: formData
            })
            .then(res => res.json())
            .then(data => {
                if(data.success) {
                    alert("Đã xóa khỏi giỏ!");
                    window.location.reload();
                } else alert("Lỗi: " + data.message);
            });
        }
    </script>
</asp:Content>
