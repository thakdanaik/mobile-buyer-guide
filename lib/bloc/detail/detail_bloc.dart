import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mobile_buyer_guide/models/mobile.dart';
import 'package:mobile_buyer_guide/models/mobile_image.dart';
import 'package:mobile_buyer_guide/services/mobile_service.dart';

part 'detail_event.dart';

part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final MobileService mobileService;
  final Mobile mobile;

  DetailBloc({required this.mobileService, required this.mobile}) : super(DetailState(mobile: mobile)) {
    on<GetMobileImageEvent>(_getMobileImage);
  }

  Future<void> _getMobileImage(
    GetMobileImageEvent event,
    Emitter<DetailState> emit,
  ) async {
    try {
      emit(LoadingState(state));
      List<MobileImage> imageList = await mobileService.getMobileImages(mobile.id!);
      emit(DetailState(mobile: mobile, imageList: imageList));
    } on DioError catch (error) {
      emit(ExceptionState(state, errorMsg: error.type == DioErrorType.response ? error.message : 'An error occurred in the system.'));
    } catch (error) {
      emit(ExceptionState(state, errorMsg: 'An error occurred in the system.'));
    }
  }
}
