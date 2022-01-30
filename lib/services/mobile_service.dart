import 'package:dio/dio.dart';
import 'package:mobile_buyer_guide/constants/api_constant.dart';
import 'package:mobile_buyer_guide/models/mobile.dart';
import 'package:mobile_buyer_guide/models/mobile_image.dart';

class MobileService {
  final Dio dio;

  MobileService(this.dio);

  static const String controllerName = 'api/mobiles';

  Future<List<Mobile>> getMobiles() async {
      var response = await dio.get('${ApiConstant.baseUrl}/$controllerName');
      List result = response.data as List;
      return result.map((model) => Mobile.fromJson(model)).toList();
  }

  Future<List<MobileImage>> getMobileImages(int mobileId) async {
      var response = await dio.get('${ApiConstant.baseUrl}/$controllerName/$mobileId/images');
      List result = response.data as List;
      return result.map((model) => MobileImage.fromJson(model)).toList();
  }


}