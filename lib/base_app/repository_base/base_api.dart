import 'dart:io';

import 'package:dio/io.dart';
import 'package:package_ekyc/base_app/base_app.src.dart';
import 'package:package_ekyc/const.dart';
import 'package:package_ekyc/core/core.src.dart';
import 'package:package_ekyc/shares/package/export_package.dart';
import 'package:package_ekyc/shares/utils/log/dio_log.dart';

class BaseApi {
  static Dio dio = getBaseDio();
  late Function(Object error) onErrorCallBack;

  static Dio getBaseDio() {
    Dio dio = Dio();

    dio.options = buildDefaultOptions();
    // if (Diolog().showDebug) {
    //   dio.interceptors.add(DioLogForkInterceptor());
    // }
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );

/*    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };*/
    return dio;
  }

  static BaseOptions buildDefaultOptions({Duration? timeOut}) {
    return BaseOptions()
      ..connectTimeout =
          timeOut ?? const Duration(milliseconds: AppConst.requestTimeOut)
      ..receiveTimeout =
          timeOut ?? const Duration(milliseconds: AppConst.requestTimeOut);
  }

  static void close() {
    dio.close(force: true);
    updateCurrentDio();
  }

  static void updateCurrentDio() {
    dio = getBaseDio();
  }

  static Dio getCurrentDio() {
    return dio;
  }

  void setOnErrorListener(Function(Object error) onErrorCallBack) {
    this.onErrorCallBack = onErrorCallBack;
  }

  /// [isQueryParametersPost]: `true`: phương thức post gửi params, mặc định = `false`
  ///
  /// [dioOptions]: option của Dio() sử dụng khi gọi api có option riêng
  ///
  /// [functionError]: chạy function riêng khi request xảy ra Exception (mặc định sử dụng [showDialogError])
  /// [queryParameters]: sử dụng khi truyền cùng lúc cả body và query
  /// [isToken]: mặc định là true, nếu false sẽ không gửi token
  /// [isHaveVersion]: mặc định là true, nếu false sẽ không gửi version
  ///  [contentType]: mặc định là application/json
  ///
  Future<dynamic> callApi(
    String action,
    String requestMethod, {
    dynamic jsonMap,
    bool isDownload = false,
    String? urlOther,
    Map<String, String>? headersUrlOther,
    bool isQueryParametersPost = false,
    required BaseGetxController controller,
    BaseOptions? dioOptions,
    Function(Object error)? functionError,
    bool isToken = true,
    bool isHaveVersion = true,
    Duration? timeOut,
    String? contentType,
    Map<String, dynamic>? queryParameters,
  }) async {
    dio.options = dioOptions ?? buildDefaultOptions(timeOut: timeOut);
    dynamic response;
    String url = urlOther ??
        (AppApi.url + action + (isHaveVersion ? AppApi.version : ""));
    Map<String, String> headers = isToken
        ? (headersUrlOther ?? getBaseHeader())
        : {"Content-Type": "application/json"};
    Options options = isDownload
        ? Options(
            headers: headers,
            responseType: ResponseType.bytes,
            followRedirects: false,
            contentType: contentType,
            validateStatus: (status) {
              return status != null && status < 500;
            })
        : Options(
            headers: headers,
            contentType: contentType,
            //method: requestMethod.toString(),
            responseType: ResponseType.json,
          );
    CancelToken cancelToken = CancelToken();
    controller.addCancelToken(cancelToken);
    try {
      if (requestMethod == EnumRequestMethod.post) {
        if (isQueryParametersPost) {
          response = await dio.post(
            url,
            queryParameters: jsonMap,
            options: options,
            cancelToken: cancelToken,
          );
        } else {
          response = await dio.post(
            url,
            data: jsonMap,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
          );
        }
      } else if (requestMethod == EnumRequestMethod.delete) {
        response = await dio.delete(
          url,
          data: jsonMap,
          options: options,
          cancelToken: cancelToken,
        );
      } else if (requestMethod == EnumRequestMethod.put) {
        response = await dio.put(
          url,
          data: jsonMap,
          options: options,
          cancelToken: cancelToken,
        );
      } else {
        response = await dio.get(
          url,
          queryParameters: jsonMap,
          options: options,
          cancelToken: cancelToken,
        );
      }
      return response.data;
    } catch (e) {
      var baseResponseError = catchErrorBE(e);
      if (baseResponseError != null) {
        return baseResponseError;
      }
      controller.cancelRequest(cancelToken);

      return functionError != null ? functionError(e) : showDialogError(e);
    }
  }

  // dynamic showDialogError(dynamic e) {
  //   if (e.response?.data != null &&
  //       e.response.data is Map &&
  //       e.response.data["Data"] != null) return e.response.data;
  //   onErrorCallBack(e);
  // }

  dynamic catchErrorBE(Object e) {
    try {
      if (e is DioException && e.response?.data is Map) {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        final BaseResponseBE temp = BaseResponseBE.fromJson(e.response?.data);
        if (!temp.status) {
          // if (temp.errors?.first.code == "TOKEN_EXPIRED") {
          //   isCheckShowDialog = true;
          //   gotoLogin();
          // }

          return e.response?.data;
        }
      }
    } catch (e) {
      return null;
    }
  }

// void setOnErrorListener(Function(Object error) onErrorCallBack) {
//   this.onErrorCallBack = onErrorCallBack;
// }

  dynamic showDialogError(dynamic e) {
    if (e.response?.data != null &&
        e.response.data is Map &&
        e.response.data["errorMessage"] != null) return e.response.data;
    onErrorCallBack(e);
  }

  Map<String, String> getBaseHeader() {
    return {
      "Content-Type": "application/json",
      // 'Authorization': hiveApp.get(AppKey.keyToken) ?? "",
      "ApiKey": AppConstSDK.apiKey,
      'pf': Get.theme.platform.name
    };
  }
}
