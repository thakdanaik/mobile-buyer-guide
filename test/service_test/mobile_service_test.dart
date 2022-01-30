import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mobile_buyer_guide/constants/api_constant.dart';
import 'package:mobile_buyer_guide/models/mobile.dart';
import 'package:mobile_buyer_guide/models/mobile_image.dart';
import 'package:mobile_buyer_guide/services/mobile_service.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;

  setUp((){
    dio = Dio();
    dioAdapter = DioAdapter(dio: dio);
  });

  group('API getMobiles', () {
    test(
      'test success',
      () async {
        dioAdapter.onGet(
          '${ApiConstant.baseUrl}/${MobileService.controllerName}',
          (request) => request.reply(200, [
            {
              "name": "Iphone SE 2021",
              "rating": 5,
              "id": 1,
              "brand": "Apple",
              "thumbImageURL": "https://cdn.mos.cms.futurecdn.net/grwJkAGWQp4EPpWA3ys3YC-650-80.jpg",
              "description": "this is a description",
              "price": 999.99,
            },
          ]),
        );

        MobileService service = MobileService(dio);
        final result = await service.getMobiles();

        expect(result.length, 1);
        expect(result[0], isA<Mobile>());
        expect(result[0].name, 'Iphone SE 2021');
      },
    );

    test(
      'test api failed',
      () async {
        dioAdapter.onGet(
          '${ApiConstant.baseUrl}/${MobileService.controllerName}',
          (request) => request.reply(404, {}),
        );

        try {
          MobileService service = MobileService(dio);
          await service.getMobiles();
        } catch (error) {
          expect(error, isA<DioError>());
        }
      },
    );

    test(
      'test response invalid format',
      () async {
        dioAdapter.onGet(
          '${ApiConstant.baseUrl}/${MobileService.controllerName}',
          (request) => request.reply(200, {"message": "success"}),
        );

        try {
          MobileService service = MobileService(dio);
          await service.getMobiles();

          assert(false);
        } catch (error) {
          assert(true);
        }
      },
    );
  });

  group('API getMobileImages', () {
    test(
      'test success',
      () async {
        int mobileId = 1;

        dioAdapter.onGet(
          '${ApiConstant.baseUrl}/${MobileService.controllerName}/$mobileId/images',
          (request) => request.reply(200, [
            {
              "url": "https://www.91-img.com/gallery_images_uploads/c/3/c32cff8945621ad06c929f50af9f7c55f978c726.jpg",
              "id": 7,
              "mobile_id": 1,
            },
          ]),
        );

        MobileService service = MobileService(dio);
        final result = await service.getMobileImages(mobileId);

        expect(result.length, 1);
        expect(result[0], isA<MobileImage>());
        expect(result[0].mobileId, 1);
      },
    );

    test(
      'test api failed',
      () async {
        int mobileId = 99;

        dioAdapter.onGet(
          '${ApiConstant.baseUrl}/${MobileService.controllerName}/$mobileId/images',
          (request) => request.reply(404, {}),
        );

        try {
          MobileService service = MobileService(dio);
          await service.getMobileImages(mobileId);
        } catch (error) {
          expect(error, isA<DioError>());
        }
      },
    );

    test(
      'test response invalid format',
      () async {
        int mobileId = 1;

        dioAdapter.onGet(
          '${ApiConstant.baseUrl}/${MobileService.controllerName}/$mobileId/images',
          (request) => request.reply(200, {"message": "success"}),
        );

        try {
          MobileService service = MobileService(dio);
          await service.getMobileImages(mobileId);

          assert(false);
        } catch (error) {
          assert(true);
        }
      },
    );
  });

  tearDown((){
    dioAdapter.close();
    dio.close();
  });
}
