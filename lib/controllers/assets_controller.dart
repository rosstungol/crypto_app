import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/api_response.dart';
import '../models/coin_data.dart';
import '../models/tracked_asset.dart';
import '../services/http_service.dart';

class AssetsController extends GetxController {
  RxList<CoinData> coinData = <CoinData>[].obs;
  RxBool loading = false.obs;
  RxList<TrackedAsset> trackedAssets = <TrackedAsset>[].obs;

  @override
  void onInit() {
    super.onInit();
    _getAssets();
    _loadTrackedAssetsFromStorage();
  }

  Future<void> _getAssets() async {
    loading.value = true;

    HTTPService httpService = Get.find();
    var responseData = await httpService.get('currencies');
    CurrenciesListAPIResponse currenciesListAPIResponse =
        CurrenciesListAPIResponse.fromJson(responseData);
    coinData.value = currenciesListAPIResponse.data ?? [];

    loading.value = false;
  }

  void addTrackedAsset(
    String name,
    double amount,
  ) async {
    trackedAssets.add(
      TrackedAsset(
        name: name,
        amount: amount,
      ),
    );
    List<String> data =
        trackedAssets.map((asset) => jsonEncode(asset)).toList();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tracked assets', data);
  }

  void _loadTrackedAssetsFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? data = prefs.getStringList('tracked assets');

    if (data != null) {
      trackedAssets.value = data
          .map(
            (el) => TrackedAsset.fromJson(
              jsonDecode(el),
            ),
          )
          .toList();
    }
  }

  double getPortfolioValue() {
    if (coinData.isEmpty) return 0;
    if (trackedAssets.isEmpty) return 0;

    double value = 0;
    for (TrackedAsset asset in trackedAssets) {
      value += getAssetPrice(asset.name!) * asset.amount!;
    }

    return value;
  }

  double getAssetPrice(String name) {
    CoinData? data = getCoinData(name);
    return data?.values?.uSD?.price?.toDouble() ?? 0;
  }

  CoinData? getCoinData(String name) {
    return coinData.firstWhereOrNull((e) => e.name == name);
  }
}
