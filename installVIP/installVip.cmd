cd %0/../
echo Latest version is available on the pdc_vip repository, under 'Artifacts'
set installPath="C:\Program Files (x86)\Visual Prolog Build1100 Step5"
mkdir %installPath%
pause
npm install --prefix %installPath% "visual-prolog-11.0.5-3.tgz"