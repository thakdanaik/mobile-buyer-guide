part of 'detail_bloc.dart';

class DetailState {
  final Mobile mobile;
  final List<MobileImage> imageList;

  DetailState({required this.mobile, this.imageList = const <MobileImage>[]});
}

class LoadingState extends DetailState {
  LoadingState({required Mobile mobile}) : super(mobile: mobile);
}
