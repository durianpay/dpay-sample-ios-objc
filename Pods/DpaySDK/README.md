<!-- DpaySDK -->

### Generate xcframework

To generate .xcframework for DpaySDK, go into the root folder and run

```sh
  sh build_static_framework.sh DpaySDK
```

The interface file generated as a bridge between the merchant application and DpaySDK might have the same name for both module and library, so to change the reference in the interface file, in the root directory, please run the command

```sh
  find . -name "*.swiftinterface" -exec sed -i -e 's/DpaySDK\.//g' {} \;
```