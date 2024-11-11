import 'package:get/get.dart';

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
  ) {
    trackedAssets.add(
      TrackedAsset(
        name: name,
        amount: amount,
      ),
    );
    print(trackedAssets);
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
