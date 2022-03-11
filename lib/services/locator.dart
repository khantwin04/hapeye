import 'dart:io';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:dio_flutter_transformer/dio_flutter_transformer.dart';
import 'package:news/services/network/categoryBloc/buddha/buddha_bloc.dart';
import 'package:news/services/network/categoryBloc/business/business_bloc.dart';
import 'package:news/services/network/categoryBloc/education/education_bloc.dart';
import 'package:news/services/network/categoryBloc/ganbiya/ganbiya_bloc.dart';
import 'package:news/services/network/categoryBloc/history/history_bloc.dart';
import 'package:news/services/network/categoryBloc/it/it_bloc.dart';
import 'package:news/services/network/categoryBloc/live/live_bloc.dart';
import 'package:news/services/network/categoryBloc/philo/philo_bloc.dart';
import 'package:news/services/network/categoryBloc/thuta/thuta_bloc.dart';
import 'package:news/services/network/categoryBloc/yatha/yatha_bloc.dart';
import 'package:news/services/network/get_all_post_bloc/get_all_post_bloc.dart';
import 'package:news/services/network/latestPostBloc/get_search_result_cubit.dart';
import 'package:news/services/offline/recently_read_cubit.dart';
import 'package:news/services/repo/repo.dart';
import 'network/categoryBloc/get_category_cubit.dart';
import 'network/latestPostBloc/get_latest_post_cubit.dart';
import '../services/api.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:path_provider/path_provider.dart' as pp;
import '../services/offline/readPostRepo.dart';

var getIt = GetIt.I;

Future<void> locator() async {
  Directory dir = await pp.getApplicationDocumentsDirectory();

  final options = CacheOptions(
    // A default store is required for interceptor.
    store: HiveCacheStore(dir.path),
    // Default.
    policy: CachePolicy.request,
    // Optional. Returns a cached response on error but for statuses 401 & 403.
    hitCacheOnErrorExcept: [401, 403],
    // Optional. Overrides any HTTP directive to delete entry past this duration.
    maxStale: const Duration(days: 7),
    // Default. Allows 3 cache sets and ease cleanup.
    priority: CachePriority.normal,
    // Default. Body and headers encryption with your own algorithm.
    cipher: null,
    // Default. Key builder to retrieve requests.
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    // Default. Allows to cache POST requests.
    // Overriding [keyBuilder] is strongly recommended.
    allowPostMethod: false,
  );

  final dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));
  dio.transformer = FlutterTransformer();

  getIt.registerLazySingleton(() => dio);

  Api api = Api(getIt.call());
  getIt.registerLazySingleton(() => api);

  ReadPostRepository readPostRepo = ReadPostRepository();
  getIt.registerLazySingleton(() => readPostRepo);

  RecentlyReadCubit recentlyReadCubit = RecentlyReadCubit(getIt.call());
  getIt.registerLazySingleton(() => recentlyReadCubit);

  WpRepsitory wpRepsitory = WpRepsitory(getIt.call());
  getIt.registerLazySingleton(() => wpRepsitory);

  GetAllPostBloc getAllPostBloc = GetAllPostBloc(apiRepository: getIt.call())
    ..add(GetAllPostFetched());
  getIt.registerLazySingleton(() => getAllPostBloc);

  BuddhaBloc buddhaBloc = BuddhaBloc(apiRepository: getIt.call());
  getIt.registerLazySingleton(() => buddhaBloc);

  BusinessBloc businessBloc = BusinessBloc(apiRepository: getIt.call());
  getIt.registerLazySingleton(() => businessBloc);

  EducationBloc educationBloc = EducationBloc(apiRepository: getIt.call());
  getIt.registerLazySingleton(() => educationBloc);

  GanbiyaBloc ganbiyaBloc = GanbiyaBloc(apiRepository: getIt.call());
  getIt.registerLazySingleton(() => ganbiyaBloc);

  HistoryBloc historyBloc = HistoryBloc(apiRepository: getIt.call());
  getIt.registerLazySingleton(() => historyBloc);

  ItBloc itbloc = ItBloc(apiRepository: getIt.call());
  getIt.registerLazySingleton(() => itbloc);

  LiveBloc liveBloc = LiveBloc(apiRepository: getIt.call());
  getIt.registerLazySingleton(() => liveBloc);

  PhiloBloc philoBloc = PhiloBloc(apiRepository: getIt.call());
  getIt.registerLazySingleton(() => philoBloc);

  ThutaBloc thutaBloc = ThutaBloc(apiRepository: getIt.call());
  getIt.registerLazySingleton(() => thutaBloc);

  YathaBloc yathaBloc = YathaBloc(apiRepository: getIt.call());
  getIt.registerLazySingleton(() => yathaBloc);

  GetCategoryCubit getCategoryCubit = GetCategoryCubit(getIt.call());
  getIt.registerLazySingleton(() => getCategoryCubit);

  GetLatestPostCubit getLatestPostCubit = GetLatestPostCubit(getIt.call());
  getIt.registerLazySingleton(() => getLatestPostCubit);

  GetSearchResultCubit getSearchResultCubit =
      GetSearchResultCubit(getIt.call());
  getIt.registerLazySingleton(() => getSearchResultCubit);
}
