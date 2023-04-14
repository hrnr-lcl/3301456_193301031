import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/viewmodel/article_list_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<Category> categories = [
    Category('Business', 'İş'),
    Category('Entertaiment', 'Eğlence'),
    Category('General', 'Genel'),
    Category('Health', 'Sağlık'),
    Category('Science', 'Bilim'),
    Category('Sports', 'Spor'),
    Category('Technology', 'Teknoloji'),

  ];
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ArticleListViewModel>(context);
    return Scaffold(
        appBar: AppBar(title: const Text('Haberler'),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: getCategoriesTab(vm),
              ),
            )
          ],
        ),
    );
  }

  List<GestureDetector> getCategoriesTab(ArticleListViewModel vm){
    List<GestureDetector> list = [];
    for(int i = 0; i<categories.length; i++){
      list.add(
        onTap: ()=>vm.getNews(categories[i].key),
        GestureDetector(child: Text(categories[i].title),
        )
      );
    }
    return list;
  }

  Widget getWidgetByStatus(ArticleListViewModel vm) {
    switch (vm.status.index) {
      case 2:
        return ListView.builder(
            itemCount: vm.viewModel.articles.length,
            itemBuilder: (context, index) {
              return Card(
                child: Column(
                  children: [
                    Image.network(vm.viewModel.articles[index].urlToImage ??
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/2048px-No_image_available.svg.png'),
                    ListTile(
                      title: Text(
                        vm.viewModel.articles[index].title ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle:
                      Text(vm.viewModel.articles[index].description ?? ''),
                    ),
                    ButtonBar(
                      children: [
                        MaterialButton(
                          onPressed: () async {
                            await launchUrl(Uri.parse(
                                vm.viewModel.articles[index].url ?? ''));
                          },
                          child: const Text(
                            'Habere git',
                            style: TextStyle(color: Colors.blue),),
                        )
                      ],
                    ),
                  ],
                ),
              );
            });
      default:
        return const Center(child: CircularProgressIndicator());
    }
  }
}
