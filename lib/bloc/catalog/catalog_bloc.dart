import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mobile_buyer_guide/constants/constant.dart';
import 'package:mobile_buyer_guide/models/mobile.dart';
import 'package:mobile_buyer_guide/services/mobile_service.dart';

part 'catalog_event.dart';

part 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final MobileService mobileService;

  CatalogBloc({required this.mobileService}) : super(CatalogState()) {
    on<GetMobileDataEvent>(_getMobileData);
    on<ChangePageViewEvent>(_changePageView);
    on<AddFavoriteEvent>(_addFavorite);
    on<RemoveFavoriteEvent>(_removeFavorite);
    on<SortDataEvent>(_sortData);
  }

  Future<void> _getMobileData(
    GetMobileDataEvent event,
    Emitter<CatalogState> emit,
  ) async {
    try {
      emit(LoadingState(state));
      List<Mobile> mobileList = await mobileService.getMobiles();
      _sortMobileList(mobileList, state.sortBy);
      emit(CatalogState(mobileList: mobileList, currentPage: state.currentPage));
    } on DioError catch (error) {
      emit(ExceptionState(state, errorMsg: error.type == DioErrorType.response ? error.message : 'An error occurred in the system.'));
    } catch (error) {
      emit(ExceptionState(state, errorMsg: 'An error occurred in the system.'));
    }
  }

  void _changePageView(
    ChangePageViewEvent event,
    Emitter<CatalogState> emit,
  ) {
    try {
      if (state is LoadingState) {
        emit(LoadingState(state));
      } else {
        emit(CatalogState(mobileList: state.mobileList, favoriteList: state.favoriteList, currentPage: event.pageIndex, sortBy: state.sortBy));
      }
    } catch (error) {
      emit(ExceptionState(state, errorMsg: 'An error occurred in the system.'));
    }
  }

  void _addFavorite(
    AddFavoriteEvent event,
    Emitter<CatalogState> emit,
  ) {
    try {
      event.mobile.isFavorite = true;
      emit(CatalogState(mobileList: state.mobileList, favoriteList: state.mobileList.where((e) => e.isFavorite ?? false).toList(), currentPage: state.currentPage, sortBy: state.sortBy));
    } catch (error) {
      emit(ExceptionState(state, errorMsg: 'An error occurred in the system.'));
    }
  }

  void _removeFavorite(
    RemoveFavoriteEvent event,
    Emitter<CatalogState> emit,
  ) {
    try {
      event.mobile.isFavorite = false;
      emit(CatalogState(mobileList: state.mobileList, favoriteList: state.mobileList.where((e) => e.isFavorite ?? false).toList(), currentPage: state.currentPage, sortBy: state.sortBy));
    } catch (error) {
      emit(ExceptionState(state, errorMsg: 'An error occurred in the system.'));
    }
  }

  void _sortData(
    SortDataEvent event,
    Emitter<CatalogState> emit,
  ) {
    try {
      emit(LoadingState(state));
      _sortMobileList(state.mobileList, event.sortBy);
      emit(CatalogState(mobileList: state.mobileList, favoriteList: state.mobileList.where((e) => e.isFavorite ?? false).toList(), currentPage: state.currentPage, sortBy: event.sortBy));
    } catch (error) {
      emit(ExceptionState(state, errorMsg: 'An error occurred in the system.'));
    }
  }

  void _sortMobileList(List<Mobile> mobileList, SortBy sortBy) {
    if (mobileList.isNotEmpty) {
      mobileList.sort((a, b) {
        switch (sortBy) {
          case SortBy.priceLowToHigh:
            return a.price!.compareTo(b.price!);
          case SortBy.priceHighToLow:
            return b.price!.compareTo(a.price!);
          case SortBy.rating:
            return b.rating!.compareTo(a.rating!);
        }
      });
    }
  }
}
