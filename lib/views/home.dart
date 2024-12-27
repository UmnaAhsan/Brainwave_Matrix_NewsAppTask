import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_channel_headlines_models.dart';
import 'package:news_app/view_model/news_view_model.dart';
import 'package:news_app/views/widgets/categories_screen.dart';
import 'package:news_app/views/widgets/news_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
enum FilterList{bbcNews, aryNews, Independent, aljazeera     , australian}

class _HomeScreenState extends State<HomeScreen> {

 NewsViewModel newsViewModel = NewsViewModel();


FilterList? selectedMenu;
final format = DateFormat('MMMM dd, YYYY');
String name = 'bbc news';
String formatDateTime(String timestamp) {
  // Parse the timestamp to a DateTime object
  DateTime dateTime = DateTime.parse(timestamp);

  // Format the date and time
  String formattedDate = DateFormat('d MMM yyyy').format(dateTime); // 22 Nov 2024
  String formattedTime = DateFormat('hh:mm a').format(dateTime); // 12:02 AM/PM

  // Combine the formatted date and time
  return '$formattedDate | $formattedTime';
}


  @override
  Widget build(BuildContext context) {
   // MediaQuery.of(context).size;
    final width = MediaQuery.sizeOf(context).width*1;
    final height = MediaQuery.sizeOf(context).height*1;
    
    return Scaffold(
      appBar: AppBar(title: Text('News',style: GoogleFonts.poppins(fontSize: 24,fontWeight: FontWeight.w700),),
      centerTitle: true,
      actions: [
       PopupMenuButton<FilterList>(
        initialValue: selectedMenu,
        icon: Icon(Icons.more_vert,color: Colors.black),
        onSelected: (FilterList item){
          if(FilterList.bbcNews.name == item.name){
            name = 'bbc-news';
          }
          if(FilterList.aryNews.name == item.name){
            name = 'ary-news';
          }
           if(FilterList.aljazeera.name ==item.name){
            name = 'al-jazeera-english';
          
          }

          setState(() {
            selectedMenu = item;
          });
           
     // newsViewModel.fetchNewsChannelHeadlineApi();
        },
        itemBuilder:(BuildContext
         context)=>< PopupMenuEntry<FilterList> > [
        PopupMenuItem<FilterList>(
          value: FilterList.bbcNews,
          child: Text('BBC News')),

          PopupMenuItem<FilterList>(
          value: FilterList.aryNews,
          child: Text('ARY News')),

            PopupMenuItem<FilterList>(
          value: FilterList.aljazeera,
          child: Text('Aljazeera News'))
       ]),

      //),
       
      ],
      leading: IconButton(onPressed: (){
        Get.to(CategoriesScreen());
      }, icon: Image.asset('images/category_icon.png',height: 30,width: 30,)),),
      body: ListView(children: [
       // Container(
         SizedBox(height: height*.55,
          width: width,
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
              future: newsViewModel.fetchNewsChannelHeadlineApi(name),
              builder: (BuildContext context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: SpinKitCircle(size: 40,color: Colors.blue[900],),);
                }else{
                  return ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index){
                  String dateTime = formatDateTime("${snapshot.data!.articles![index].publishedAt}");
                  print(snapshot.data!.articles![index].source!.name.toString());
                  
                     return snapshot.data!.articles![index].source!.name=="[Removed]"?SizedBox(): Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: InkWell(onTap: (){
                        Get.to(NewsDetailsScreen(
                          author:snapshot.data!.articles![index].author.toString() , 
                          content: snapshot.data!.articles![index].content.toString(),
                           description: snapshot.data!.articles![index].description.toString(),
                            newImage: snapshot.data!.articles![index].urlToImage.toString(),
                             newsData: snapshot.data!.articles![index].publishedAt.toString(), 
                             newsTitle: snapshot.data!.articles![index].title.toString(), 
                             source: snapshot.data!.articles![index].source!.name.toString()));
                       },
                         child: SizedBox(child: Stack(alignment: Alignment.center,
                                           children: [
                                           Container
                                           (height:height * 0.9,width:width *.9,
                                           padding: EdgeInsets.symmetric(horizontal: height *.0),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(15),
                                              child: CachedNetworkImage(imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                                                                       fit: BoxFit.cover,
                                                                                       placeholder: (context, url) => Container(child: spinKit2,),
                                                                                       errorWidget: (context, url, error) => Icon(Icons.error,color: Colors.red,),),
                                            ),
                                           )
                                         , Positioned(
                                          bottom: 20,
                                           child: Card(
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                           ),child: Container(
                                            alignment: Alignment.bottomCenter,
                                            padding: EdgeInsets.all(15),
                                            height: height*0.27,
                                            width: width *0.8,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(width: width*0.7,
                                                child: 
                                                Text(snapshot.data!.articles![index].title.toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: 
                                                GoogleFonts.poppins(fontSize: 17,fontWeight: FontWeight.w700),),
                                                ),
                                                Spacer(),
                                                Container(
                                                  width: width *0.7,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                   Text(snapshot.data!.articles![index].source!.name.toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: 
                                                GoogleFonts.poppins(fontSize: 11,fontWeight: FontWeight.w600),),
                                                 Text("$dateTime",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: 
                                                GoogleFonts.poppins(fontSize: 9,fontWeight: FontWeight.w700),),
                                                ],),)
                                            ],),
                                           ),
                                           ),
                                         ) ],),
                                           ),
                       ),
                     );
                  });
                }
              },
             ),
             ),



          Padding(
  padding: const EdgeInsets.all(8.0),
  child: FutureBuilder<CategoriesNewsModel>(
    future: newsViewModel.fetchCategoriesNewsApi('General'),
    builder: (BuildContext context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: SpinKitCircle(
            size: 40,
            color: Colors.blue[900],
          ),
        );
      } else if (snapshot.hasData) {
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 16.0),
          itemCount: snapshot.data!.articles!.length,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(), // Allows smooth scrolling
          itemBuilder: (context, index) {
            String dateTime =
                formatDateTime("${snapshot.data!.articles![index].publishedAt}");
            
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(
                        NewsDetailsScreen(
                          author: snapshot.data!.articles![index].author ?? '',
                          content: snapshot.data!.articles![index].content ?? '',
                          description:
                              snapshot.data!.articles![index].description ?? '',
                          newImage:
                              snapshot.data!.articles![index].urlToImage ?? '',
                          newsData:
                              snapshot.data!.articles![index].publishedAt ?? '',
                          newsTitle: snapshot.data!.articles![index].title ?? '',
                          source: snapshot.data!.articles![index].source?.name ?? '',
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl:
                            snapshot.data!.articles![index].urlToImage ?? '',
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 0.18,
                        width: MediaQuery.of(context).size.width * 0.3,
                        placeholder: (context, url) => Center(
                          child: SpinKitCircle(
                            size: 40,
                            color: Colors.blue[900],
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.18,
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data!.articles![index].title ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                snapshot.data!.articles![index].source?.name ?? '',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                dateTime,
                                maxLines: 2,
                                style: GoogleFonts.poppins(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        return Center(
          child: Text(
            'No data available',
            style: GoogleFonts.poppins(fontSize: 16),
          ),
        );
      }
    },
  ),
),
















      ],),
    
    );
  }
}
const spinKit2 = SpinKitFadingCircle(
    color: Colors.amber,
    size: 50,
  );