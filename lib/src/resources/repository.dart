import 'dart:async';
import 'news_api_provider.dart';
import 'news_db_provider.dart';
import '../models/item_model.dart';

class Repository {
  List<Source> sources = <Source>[
    newsDbProvider,
    NewsApiProvider(),
  ];

  List<Cache> caches = <Cache>[
    newsDbProvider,
  ];

//TODO - Iterate over sources when dbprovider
// get fetchTopIds implemented
  Future<List<int>> fetchTopIds(){
    return sources[1].fetchTopIds();
  }

//if the item is not empty then return it, use var so that we can re-assign it in the future
//if async we use await
  Future<ItemModel> fetchItem(int id) async {
   ItemModel item;
   var source; //type unspecified as when we perform a comparison when adding cache item below
   // cache != source they have to be of either the same or an undefined type

//fetch either item or a null
   for (source in sources) {
     item = await source.fetchItem(id);
     //if not null break
     if (item != null){
       break;
     }
   }
   for (var cache in caches) {
     if (cache != source){
      cache.addItem(item);
     }
   }
   return item;
  }

// wait for cache to clear before doing the next instance
  clearCache() async {
    for (var cache in caches){
      await cache.clear();
    }
  }
}

abstract class Source {
  Future<List<int>>fetchTopIds();
  Future<ItemModel>fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
  Future<int> clear();
}