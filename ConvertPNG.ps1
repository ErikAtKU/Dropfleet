using namespace System.Drawing

$input_folder = "C:\ErikPrograms\png1"
$output_folder = "C:\ErikPrograms\png2"
$width = 480
$height = 320
$BGColor = [Color]::LimeGreen
$BGbrush = [SolidBrush]::new($BGColor)

Get-ChildItem $input_folder -File | ForEach-Object {
    $image = [Image]::FromFile($_.FullName)
    $height = $image.Height * $width / $image.width
    $destination_rect = New-Object Rectangle 0, 0, $width, $height
    $destination_image = New-Object bitmap $width, $height
    $destination_image.SetResolution($image.HorizontalResolution, $image.VerticalResolution)
    $graphics = [Graphics]::FromImage($destination_image)


    $graphics.CompositingMode = [Drawing2D.CompositingMode]::SourceCopy
    $graphics.CompositingQuality = [Drawing2D.CompositingQuality]::HighQuality
    $graphics.InterpolationMode = [Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.SmoothingMode = [Drawing2D.SmoothingMode]::HighQuality
    $graphics.PixelOffsetMode = [Drawing2D.PixelOffsetMode]::HighQuality

    $wrapmode = [Imaging.ImageAttributes]::new()
    $wrapmode.SetWrapMode([Drawing2D.WrapMode]::TileFlipXY)


    $graphics.DrawImage($image, $destination_rect, 0, 0, $image.Width, $image.Height, [GraphicsUnit]::Pixel, $wrapmode)


    $destination_image.MakeTransparent($destination_image.GetPixel(1, 1))    
  

    
    $destination_image.Save((Join-Path $output_folder ucm$_))
}