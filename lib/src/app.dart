import 'package:flutter/material.dart';
import 'screens/new_list.dart';
import 'blocs/stories_provider.dart';
import 'screens/news_detail.dart';
import 'blocs/comments_provider.dart';

//map is a data structure, has keys, values and pagebuilder functions

class App extends StatelessWidget {
  Widget build(context) {
    return StoriesProvider(
      child: new CommentsProvider(
        child: MaterialApp( //automatically makes navigator
          title: "News!",
          onGenerateRoute: routes,
        ),
      ),
    );
  }
  Route routes(RouteSettings settings){
    if (settings.name == '/'){
      return MaterialPageRoute(
        builder: (context) {
          final storiesBloc = StoriesProvider.of(context);

          storiesBloc.fetchTopIds();
          
          return NewsList();
        },
      );
    } else {
        return MaterialPageRoute(
          builder: (context) {
            final commentsBloc = CommentsProvider.of(context);
            final itemId = int.parse(settings.name.replaceFirst('/','')); //replacing the /number to just number

            commentsBloc.fetchItemWithComments(itemId);

            return NewsDetail(
              itemId: itemId,
            );
          },
        );
      }   
  }
}