import 'dart:math';

import 'package:playback/api/api.dart';
import 'package:playback/models/response/users_response.dart';
import 'package:playback/screens/home/home.dart';
import 'package:playback/shared/shared.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final ApiRepository apiRepository;
  SettingsController({required this.apiRepository});

  var currentTab = MainTabs.home.obs;
  var users = Rxn<UsersResponse>();
  var user = Rxn<Datum>();

  late MainTab mainTab;
  late DiscoverTab discoverTab;
  late ResourceTab resourceTab;
  late MeTab meTab;

  @override
  void onInit() async {
    super.onInit();

    mainTab = const MainTab();
    loadUsers();

    discoverTab = const DiscoverTab();
    resourceTab = const ResourceTab();
    meTab = const MeTab();
  }

  Future<void> loadUsers() async {
    // ignore: no_leading_underscores_for_local_identifiers
    var _users = await apiRepository.getUsers();
    if (_users!.data!.isNotEmpty) {
      users.value = _users;
      users.refresh();
      _saveUserInfo(_users);
    }
  }

  void signout() {
    var prefs = Get.find<SharedPreferences>();
    prefs.clear();

    // Get.back();
    NavigatorHelper.popLastScreens(popCount: 2);
  }

  void _saveUserInfo(UsersResponse users) {
    var random = Random();
    var index = random.nextInt(users.data!.length);
    user.value = users.data![index];
    var prefs = Get.find<SharedPreferences>();
    prefs.setString(StorageConstants.userInfo, users.data![index].toRawJson());

    // var userInfo = prefs.getString(StorageConstants.userInfo);
    // var userInfoObj = Datum.fromRawJson(xx!);
    // print(userInfoObj);
  }

  void switchTab(int index) {
    var tab = _getCurrentTab(index);
    currentTab.value = tab;
  }

  int getCurrentIndex(MainTabs tab) {
    switch (tab) {
      case MainTabs.home:
        return 0;
      case MainTabs.discover:
        return 1;
      case MainTabs.resource:
        return 2;
      case MainTabs.me:
        return 3;
      default:
        return 0;
    }
  }

  MainTabs _getCurrentTab(int index) {
    switch (index) {
      case 0:
        return MainTabs.home;
      case 1:
        return MainTabs.discover;
      case 2:
        return MainTabs.resource;
      case 3:
        return MainTabs.me;
      default:
        return MainTabs.home;
    }
  }
}
