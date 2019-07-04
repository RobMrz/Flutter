import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';
import 'dart:async';

class StoriesBloc{
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemsFetcher = PublishSubject<int>();

  //Getter to streams
  Observable<List<int>> get topIds => _topIds.stream;
  Observable<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  //Getter to Sinks
  Function(int) get fetchItem => _itemsFetcher.sink.add;

  StoriesBloc(){
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  clearCache() {
    return _repository.clearCache();
  }

//used to provider StreamBuilders with ItemModels and id keys in a neat package
// cache is a single object carried along through the stream
//id fetched by stream
//index is the number of times the scan streamer has been invoked, in this example we dont care about it
// we replaced index with _ because it's not used 
// takes id, fetches appropriate item, adds id and item to cache object
  _itemsTransformer(){
    return ScanStreamTransformer(
      (Map <int, Future<ItemModel>> cache, int id, index){
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      //this is a map
      <int, Future<ItemModel>>{}, 
    );
  }

  dispose(){
    _topIds.close();
    _itemsOutput.close();
    _itemsFetcher.close();
  }
}

