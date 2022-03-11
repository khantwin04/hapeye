import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/services/locator.dart';
import 'package:news/services/network/categoryBloc/buddha/buddha_bloc.dart';
import 'package:news/services/network/categoryBloc/business/business_bloc.dart';
import 'package:news/services/network/categoryBloc/education/education_bloc.dart';
import 'package:news/services/network/categoryBloc/ganbiya/ganbiya_bloc.dart';
import 'package:news/services/network/categoryBloc/get_category_cubit.dart';
import 'package:news/services/network/categoryBloc/history/history_bloc.dart';
import 'package:news/services/network/categoryBloc/it/it_bloc.dart';
import 'package:news/services/network/categoryBloc/live/live_bloc.dart';
import 'package:news/services/network/categoryBloc/philo/philo_bloc.dart';
import 'package:news/services/network/categoryBloc/thuta/thuta_bloc.dart';
import 'package:news/services/network/categoryBloc/yatha/yatha_bloc.dart';
import 'package:news/services/network/get_all_post_bloc/get_all_post_bloc.dart';
import 'package:news/services/network/latestPostBloc/get_latest_post_cubit.dart';
import 'package:news/services/network/latestPostBloc/get_search_result_cubit.dart';
import 'package:news/services/offline/readPostRepo.dart';
import 'package:news/services/offline/recently_read_cubit.dart';
import 'package:news/ui/home/new_home_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    enableVibration: true,
    playSound: true,
    showBadge: true,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);



  await locator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
   super.initState();
    initPlatformState();
  }

  String _debugLabelString = "";

  Future<void> initPlatformState() async {
    if (!mounted) return;

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(true);

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
      this.setState(() {
        _debugLabelString =
            "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      print('FOREGROUND HANDLER CALLED WITH: ${event}');

      /// Display Notification, send null to not display
      event.complete(null);

      this.setState(() {
        _debugLabelString =
            "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });

      flutterLocalNotificationsPlugin.show(
          event.notification.hashCode,
          event.notification.title,
          event.notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              playSound: true,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ));
    });

    OneSignal.shared
        .setInAppMessageClickedHandler((OSInAppMessageAction action) {
      this.setState(() {
        _debugLabelString =
            "In App Message Clicked: \n${action.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared
        .setSMSSubscriptionObserver((OSSMSSubscriptionStateChanges changes) {
      print("SMS SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
    });

    // NOTE: Replace with your own app ID from https://www.onesignal.com
    await OneSignal.shared.setAppId("1caf5713-d5e0-4854-a7a7-34652fcbe1e6");

    OneSignal.shared.consentGranted(true);

    bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();

    bool userProvidedPrivacyConsent =
        await OneSignal.shared.userProvidedPrivacyConsent();
    print("USER PROVIDED PRIVACY CONSENT: $userProvidedPrivacyConsent");

    // Some examples of how to use In App Messaging public methods with OneSignal SDK
    oneSignalInAppMessagingTriggerExamples();

    OneSignal.shared.disablePush(false);

    // Some examples of how to use Outcome Events public methods with OneSignal SDK
    oneSignalOutcomeEventsExamples();
  }

  oneSignalInAppMessagingTriggerExamples() async {
    /// Example addTrigger call for IAM
    /// This will add 1 trigger so if there are any IAM satisfying it, it
    /// will be shown to the user
    OneSignal.shared.addTrigger("trigger_1", "one");

    /// Example addTriggers call for IAM
    /// This will add 2 triggers so if there are any IAM satisfying these, they
    /// will be shown to the user
    Map<String, Object> triggers = new Map<String, Object>();
    triggers["trigger_2"] = "two";
    triggers["trigger_3"] = "three";
    OneSignal.shared.addTriggers(triggers);

    // Removes a trigger by its key so if any future IAM are pulled with
    // these triggers they will not be shown until the trigger is added back
    OneSignal.shared.removeTriggerForKey("trigger_2");

    // Get the value for a trigger by its key
    Object? triggerValue =
        await OneSignal.shared.getTriggerValueForKey("trigger_3");
    print("'trigger_3' key trigger value: ${triggerValue?.toString()}");

    // Create a list and bulk remove triggers based on keys supplied
    List<String> keys = ["trigger_1", "trigger_3"];
    OneSignal.shared.removeTriggersForKeys(keys);

    // Toggle pausing (displaying or not) of IAMs
    OneSignal.shared.pauseInAppMessages(false);
  }

  oneSignalOutcomeEventsExamples() async {
    // Await example for sending outcomes
    outcomeAwaitExample();

    // Send a normal outcome and get a reply with the name of the outcome
    OneSignal.shared.sendOutcome("normal_1");
    OneSignal.shared.sendOutcome("normal_2").then((outcomeEvent) {
      print(outcomeEvent.jsonRepresentation());
    });

    // Send a unique outcome and get a reply with the name of the outcome
    OneSignal.shared.sendUniqueOutcome("unique_1");
    OneSignal.shared.sendUniqueOutcome("unique_2").then((outcomeEvent) {
      print(outcomeEvent.jsonRepresentation());
    });

    // Send an outcome with a value and get a reply with the name of the outcome
    OneSignal.shared.sendOutcomeWithValue("value_1", 3.2);
    OneSignal.shared.sendOutcomeWithValue("value_2", 3.9).then((outcomeEvent) {
      print(outcomeEvent.jsonRepresentation());
    });
  }

  Future<void> outcomeAwaitExample() async {
    var outcomeEvent = await OneSignal.shared.sendOutcome("await_normal_1");
    print(outcomeEvent.jsonRepresentation());
  }

  @override
  Widget build(BuildContext context) {
    print(_debugLabelString);

    return MultiBlocProvider(
      providers: [
        BlocProvider<RecentlyReadCubit>(create: (_) => getIt.call(),),
        BlocProvider<GetLatestPostCubit>(create: (_) => getIt.call()),
        BlocProvider<GetAllPostBloc>(create: (_) => getIt.call()),
        BlocProvider<GetCategoryCubit>(create: (_) => getIt.call()),
        BlocProvider<GetSearchResultCubit>(create: (_) => getIt.call()),
        BlocProvider<BuddhaBloc>(create: (_) => getIt.call()),
        BlocProvider<BusinessBloc>(create: (_) => getIt.call()),
        BlocProvider<EducationBloc>(create: (_) => getIt.call()),
        BlocProvider<GanbiyaBloc>(create: (_) => getIt.call()),
        BlocProvider<HistoryBloc>(create: (_) => getIt.call()),
        BlocProvider<ItBloc>(create: (_) => getIt.call()),
        BlocProvider<LiveBloc>(create: (_) => getIt.call()),
        BlocProvider<PhiloBloc>(create: (_) => getIt.call()),
        BlocProvider<ThutaBloc>(create: (_) => getIt.call()),
        BlocProvider<YathaBloc>(create: (_) => getIt.call()),
      ],
      child: MaterialApp(
        title: 'HapEye.net',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
              elevation: 0.0,
              titleTextStyle: TextStyle(color: Colors.white),
              color: Colors.white),
          primarySwatch: Colors.orange,
        ),
        home: NewHomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
