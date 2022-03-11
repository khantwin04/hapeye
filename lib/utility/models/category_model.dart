import 'package:json_annotation/json_annotation.dart';
part 'category_model.g.dart';

Map<int, String> _fixedCategoryList = {
  10: 'ဂမ်ဘီရ',
  11: 'စီးပွားရေး',
  8: 'ပညာရေး',
  5: 'ဗုဒ္ဓဝင်',
  7: 'ဘဝနေနည်း',
  4: 'ရသ',
  6: 'သမိုင်း',
  1: 'သုတ',
  9: 'အတွေးအခေါ်',
  12: 'အိုင်တီ'
};

String getFixedCategoryName(int id) {
  return _fixedCategoryList[id]!;
}

List<CategoryModel> getSubList(int id) {
  switch (id) {
    case 1:
      return thutaSubList;

    case 4:
      return yathaSubList;

    case 5:
      return buddhaSubList;

    case 6:
      return historySubList;

    case 7:
      return liveSubList;

    case 8:
      return educationSubList;

    case 9:
      return philoSubList;

    case 11:
      return businessSubList;
    default:
      return itSubList;
  }
}

List<CategoryModel> yathaSubList = [
  CategoryModel(
      id: 0,
      count: 0,
      name: 'ဘဝဒဿန ရသစာများ',
      link: 'https://hapeye.net/archives/tag/ဘဝဒဿန-ရသစာများ'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'ဂန္တဝင်မြောက် ပင်ကိုယ်ရေးဝတ္ထု',
      link: 'https://hapeye.net/archives/tag/nga-ba'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'ဂမ္ဘီရ',
      link:
          'https://hapeye.net/archives/category/%e1%80%82%e1%80%99%e1%80%b9%e1%80%98%e1%80%ae%e1%80%9b'),
];

List<CategoryModel> thutaSubList = [
  CategoryModel(
      id: 0,
      count: 0,
      name: 'သဘာဝအစားအစာများ၏ ဂုဏ်သတ္တိဖြင့် ကျန်းမာလှပအောင်နေနည်',
      link: 'https://hapeye.net/archives/tag/yupar-thein'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'အိမ်ရှင်မများအတွက် နိုင်ငံတကာ ချတ်နည်း၊ ပြုတ်နည်',
      link: 'https://hapeye.net/archives/tag/cooking-ways-for-housekeepers'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'သင့်ကျန်းမာရေးအတွက် ရှောင်ရန် အမှုအကျင့်မျာ',
      link: 'https://hapeye.net/archives/tag/donts-for-your-health'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'အရည်အသွေးဆိုတာ ဘာလဲ',
      link: 'https://hapeye.net/archives/tag/nu-nu-yin'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'Rules Of Golf',
      link: 'https://hapeye.net/archives/tag/rules-of-golf'),
];

List<CategoryModel> buddhaSubList = [
  CategoryModel(
      id: 0,
      count: 0,
      name: 'The Luminous Life Of Buddha ( မဟာလူသား မြတ်ဗုဒ္ဓ )',
      link: 'https://hapeye.net/archives/tag/life_of_buddha'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'ဇာတ်ကြီးဆယ်ဘွဲ့',
      link: 'https://hapeye.net/archives/tag/10-previous-lives-of-buddha'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'Buddha Quotes',
      link: 'https://hapeye.net/archives/tag/buddha-quotes'),
];

List<CategoryModel> historySubList = [
  CategoryModel(
      id: 0,
      count: 0,
      name: 'Mandalay The Golden',
      link: 'https://hapeye.net/archives/tag/sein-thin'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'မြန်မာ့သတင်းစာများထဲမှ သမိုင်းဆိုင်ရာ ဆောင်းပါးများ',
      link:
          'https://hapeye.net/archives/tag/historical-articles-in-myanmar-newspapers'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'ခေါင်းဆောင် ၁၀၀',
      link: 'https://hapeye.net/archives/tag/100-leaders'),
];

List<CategoryModel> liveSubList = [
  CategoryModel(
      id: 0,
      count: 0,
      name: 'လွတ်လပ်သော လူသား',
      link: 'https://hapeye.net/archives/tag/khin-maung-lwin'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'အခြားသူများအား တွန်းအားပေးရန် နည်းလမ်း ၁၀၀',
      link: 'https://hapeye.net/archives/tag/100-ways-motivation-u-ye-nyut'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'သင့်လုပ်ငန်းတွင်မွေ့လျော်ရန် နည်းလမ်း ၁၀၁သွယ်',
      link:
          'https://hapeye.net/archives/tag/101-way-to-love-your-jobstephanie-goddard-davigson'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'ပြည်သူ့နီတိနှင့် ယဉ်ကျေးမှုပဒေသာ',
      link: 'https://hapeye.net/archives/tag/ethics'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'လုံးဝလက်မလျှော့လိုက်ပါနဲ့',
      link: 'https://hapeye.net/archives/tag/never-give-up'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'ပန်းတိုင်သို့ ပစ်မှတ်',
      link: 'https://hapeye.net/archives/tag/target-to-the-goal'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'ငပျင်းတွေအတွက် အောင်မြင်ရေးနည်းလမ်း',
      link: 'https://hapeye.net/archives/tag/successways-for-lazy-people'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'ဂရုမစိုက်ခြင်း အနုပညာ',
      link:
          'https://hapeye.net/archives/tag/the-subtle-art-of-not-giving-a-fuck'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'အောင်မြင်မှုသို့ ခြေလှမ်း၁၀၁လှမ်း',
      link: 'https://hapeye.net/archives/tag/101_to_success'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'Why Worry? Be Happy',
      link: 'https://hapeye.net/archives/tag/why-worry-be-happy'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'စိတ်ချမ်းသာဖို့ အကြံပြုချက်၅၀',
      link:
          'https://hapeye.net/archives/tag/%e1%80%85%e1%80%ad%e1%80%90%e1%80%ba%e1%80%81%e1%80%bb%e1%80%99%e1%80%ba%e1%80%b8%e1%80%9e%e1%80%ac%e1%80%96%e1%80%ad%e1%80%af%e1%80%b7-%e1%80%a1%e1%80%80%e1%80%bc%e1%80%b6%e1%80%95%e1%80%bc%e1%80%af'),
];

List<CategoryModel> philoSubList = [
  CategoryModel(
      id: 0,
      count: 0,
      name: 'မိတ္တဗလဋ္ဋီကာ',
      link: 'https://hapeye.net/archives/tag/u-nu'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'ပလေးတိုးနိဒါန်း',
      link: 'https://hapeye.net/archives/tag/zaw-gyi'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'အတွေးလက်ဆောင်',
      link: 'https://hapeye.net/archives/tag/gift-of-thought'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'လူငယ်တို့အတွက် ဘဝခွန်အားပြောစကားများ (by Daw Aung San Su Kyi)',
      link: 'https://hapeye.net/archives/tag/for-young-people'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'မျှဝေလိုသောအတွေးများ',
      link: 'https://hapeye.net/archives/tag/sharing-thoughts'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'မရှိမဖြစ် အပြုသဘောဆောင်သော အကောင်းမြင်စိတ်သဘောထား',
      link: 'https://hapeye.net/archives/tag/positive-thinking'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'မဖြစ်နိုင်ဘူးဆိုတာ သေချာပြီလား',
      link: 'https://hapeye.net/archives/tag/are-you-sure-it-is-not-possible'),
];

List<CategoryModel> educationSubList = [
  CategoryModel(
      id: 0,
      count: 0,
      name: 'Learn Together Win Together',
      link: 'https://hapeye.net/archives/tag/learn-together-win-together'),
];

List<CategoryModel> businessSubList = [
  CategoryModel(
      id: 0,
      count: 0,
      name: 'စီးပွားရေးဆိုင်ရာအယူအဆချက်မျာ',
      link: 'https://hapeye.net/archives/tag/nyunt-thaung'),
];

List<CategoryModel> itSubList = [
  CategoryModel(
      id: 0,
      count: 0,
      name: 'Photoshop',
      link: 'https://hapeye.net/archives/tag/photoshop'),
  CategoryModel(
      id: 0,
      count: 0,
      name: 'Website',
      link: 'https://hapeye.net/archives/tag/website'),
];

List<CategoryModel> localCategoryList = [
  CategoryModel(
    id: 4,
    name: 'ရသ',
    link: 'assets/yatha.png',
    count: 0,
  ),
  CategoryModel(id: 1, name: 'သုတ', link: 'assets/thuta.png', count: 0),
  CategoryModel(id: 5, name: 'ဗုဒ္ဓဝင်', link: 'assets/buddha.png', count: 0),
  CategoryModel(id: 6, name: 'သမိုင်း', link: 'assets/history.jpg', count: 0),
  CategoryModel(
      id: 7, name: 'ဘဝနေနည်း', link: 'assets/howtolive.jpg', count: 0),
  CategoryModel(
      id: 9, name: 'အတွေးအခေါ်', link: 'assets/thought.jpg', count: 0),
  CategoryModel(id: 8, name: 'ပညာရေး', link: 'assets/edu.jpg', count: 0),
  CategoryModel(
      id: 11, name: 'စီးပွားရေး', link: 'assets/business.jpg', count: 0),
  CategoryModel(id: 12, name: 'အိုင်တီ', link: 'assets/it.jpg', count: 0),
  CategoryModel(id: 10, name: 'ဂမ်ဘီရ', link: 'assets/gamiya.jpg', count: 0),
];

@JsonSerializable()
class CategoryModel {
  final int id;
  final int count;
  final String name;
  final String link;

  CategoryModel(
      {required this.id,
      required this.count,
      required this.name,
      required this.link});

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}
