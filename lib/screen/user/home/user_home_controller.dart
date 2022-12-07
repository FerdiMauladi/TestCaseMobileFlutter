import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:userapp/base/base_controller.dart';
import 'package:userapp/data/model/user_model.dart';

enum UserHomeViewState {
  none,
  loading,
  error,
}

class UserHomeController extends BaseController {
  UserHomeViewState _state = UserHomeViewState.none;

  UserHomeViewState get state => _state;

  final limit = 10;
  String searchTerm = "";
  String query = 'name';
  final Debouncer debouncer = Debouncer(delay: const Duration(milliseconds: 400));

  final PagingController<int, UserModel?> pagingController =
      PagingController(firstPageKey: 1);

  @override
  void onInit() {
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });
    super.onInit();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  changeState(UserHomeViewState s) {
    _state = s;
    update();
  }

  Future<void> fetchPage(int pageKey) async {
    try {
      final newItems = await repository.getDataUser(pageKey, searchTerm, query);
      final isLastPage = newItems.length < limit;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  void updateList(String dataText) {
    searchTerm = dataText;
    pagingController.refresh();
  }
}
