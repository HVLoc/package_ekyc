# package_ekyc

# To generate a localization file:

- Chạy câu này lần đầu để activate get_cli

dart pub global activate get_cli

- Khi thay đổi string trong file json thì chạy câu này
  get generate locales assets/locales


dart pub global activate -s git https://github.com/HVLoc/assets_generator_by_lochv.git


lochv_agen -s -t d --const-array --rule uwu --package --no-watch
