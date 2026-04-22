Add-Type -AssemblyName System.Drawing
[System.Drawing.Bitmap]$bmp = New-Object System.Drawing.Bitmap(400, 600)
[System.Drawing.Graphics]$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.Clear([System.Drawing.Color]::AliceBlue)
$font = New-Object System.Drawing.Font("Arial", 24)
$brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Black)
$g.DrawString("D? Mèn Phiêu Luu Ký", $font, $brush, 20f, 250f)
$bmp.Save("c:\Users\Admin\Desktop\BanSachDemo\Source\img\books\demen.jpg", [System.Drawing.Imaging.ImageFormat]::Jpeg)

$g.Clear([System.Drawing.Color]::Beige)
$g.DrawString("Ð?c Nhân Tâm", $font, $brush, 50f, 250f)
$bmp.Save("c:\Users\Admin\Desktop\BanSachDemo\Source\img\books\dacnhantam.jpg", [System.Drawing.Imaging.ImageFormat]::Jpeg)

$g.Clear([System.Drawing.Color]::LightCyan)
$g.DrawString("Tu Duy Nhanh Ch?m", $font, $brush, 20f, 250f)
$bmp.Save("c:\Users\Admin\Desktop\BanSachDemo\Source\img\books\tuduynhanhvacham.jpg", [System.Drawing.Imaging.ImageFormat]::Jpeg)

$g.Clear([System.Drawing.Color]::LightGray)
$g.DrawString("Clean Code", $font, $brush, 50f, 250f)
$bmp.Save("c:\Users\Admin\Desktop\BanSachDemo\Source\img\books\cleancode.jpg", [System.Drawing.Imaging.ImageFormat]::Jpeg)

$bmp.Dispose()
