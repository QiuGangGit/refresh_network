import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:refresh_network/model/Detail.dart';
import 'package:refresh_network/refresh/page_controller.dart';

import '../serivice/api_service.dart';
import 'state.dart';

class HomeListLogic extends PagingController<Data,HomeListState> {
  final HomeListState state = HomeListState();
  @override
  getState() {
    // TODO: implement getState
    return state;
  }

  @override
  Future<List<Data>?> loadData(int page) async{
    return await ApiService().searchUser("哈哈", page: page) ?? [];
  }
}
