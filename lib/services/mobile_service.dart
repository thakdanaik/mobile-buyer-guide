import 'package:dio/dio.dart';
import 'package:mobile_buyer_guide/constants/api_constant.dart';
import 'package:mobile_buyer_guide/models/mobile.dart';

class MobileService {
  final Dio dio;

  MobileService(this.dio);

  static const String controllerName = 'api/mobiles';

  Future<List<Mobile>> getMobiles() async {
    try {
      var response = await dio.get('${ApiConstant.baseUrl}/$controllerName');
      List result = response.data as List;
      return result.map((model) => Mobile.fromJson(model)).toList();
    } catch (error) {
      rethrow;
    }
  }
}