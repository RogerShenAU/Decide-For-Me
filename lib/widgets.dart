import 'package:flutter/material.dart';
import 'services.dart';
import 'random.dart';
import 'selections.dart';

class CustomizeWidget{

  Services services = new Services();
  RandomGenerate randomGenerate = new RandomGenerate();

  // iconWithText
  Column iconWithText(IconData icon, String label, Color color) {

    return new Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        new Icon(icon, color: color),
        new Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: new Text(
            label,
            style: new TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  // display random place with google place api
  Widget displayPlace(String url, String type){
    if(url != null){
      return new FutureBuilder(
        future: services.fetchPost(url),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none: 
              return new Center(
                child: new Text('Press Button to start'),
              );
            case ConnectionState.waiting: 
              return new Center(
                child: spinner(),
              );
            default:
              if(snapshot.hasError){
                return textWithPadding('Error: ${snapshot.error}');
              }else{
                if (snapshot.hasData) {
                  if(snapshot.data['status'] == 'OK' && snapshot.data.containsKey('results')){
                    List places = snapshot.data['results'];
                    /*
                    // place api only return 20 places at a time and it has a  time limit between api calls - need to wait some time to excute the pageToken api call to retrieve more places.

                    if(snapshot.data.containsKey('next_page_token')){
                      String pageToken = snapshot.data['next_page_token'];
                      String pageTokenUrl = services.getPageTokenUrl(pageToken);
                      services.getAdditionalPlaces(pageTokenUrl).then((data){
                        List additionalPlaces = data;
                      });
                    }
                    */

                    if(type == "random"){
                      var randomPlace = randomGenerate.randomListItem(places);
                      return placeInfoBox(randomPlace);
                    }else if(type == "list"){
                      return placeInfoBoxes(places);
                    }else{
                      return textWithPadding('Please try again.');
                    }
                  }else{
                    return textWithPadding('No result found. Please try again.'); 
                  }
                } else if (snapshot.hasError) {
                  return textWithPadding("${snapshot.error}");
                }
              } 
          }
        },
      );
    }else{
      return spinner();
    }
  }

  // display place info in a box
  Widget placeInfoBox(place){
    
    String _placeName = place['name'];
    String _placeAddress = place['vicinity'];
    double _rating = 0.0;
    String _placeOpen = 'No';
    String _iconUrl = '';
    // Map<String,double> _geo;
    
    if(place.containsKey('rating'))
      if(place['rating'] is num)
        _rating = place['rating'].toDouble();

    if(place.containsKey('opening_hours')){
      if(place['opening_hours'].containsKey('open_now')){
        if(place['opening_hours']['open_now']){
          _placeOpen = 'Yes';
        }
      }else{
        _placeOpen = 'N/A';
      }
    }else{
      _placeOpen = 'N/A';
    }
    if(place.containsKey('icon')){
      _iconUrl = place['icon'];
    }else{
      _iconUrl = 'https://www.google.com/mapfiles/marker.png';
    }
    // if(place.containsKey('geometry')){
    //   if(place['geometry'].containsKey('location')){
    //     if(
    //       place['geometry']['location'].containsKey('lat') &&
    //       place['geometry']['location'].containsKey('lng')
    //     ){
    //       _geo = {
    //         'lat' :place['geometry']['location']['lat'],
    //         'lng' : place['geometry']['location']['lng']
    //       };
    //     }
    //   }
    // }

    return new Container(
      margin: const EdgeInsets.only(
        bottom: 28.0,
      ),
      child: new Card(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(top: 10.0),
            ),
            new ListTile(
              leading: new Image.network(_iconUrl),
              title: new Text(
                '$_placeName'
              ),
              subtitle: new Text('$_placeAddress'),
            ),
            new Container(
              padding: const EdgeInsets.all(20.0),
              child: new Row(
                children: <Widget>[
                  new Text(
                    'Open Now: ',
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  new Text(
                    '$_placeOpen'
                  ),
                ],
              ),
            ),
            new Container(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 20.0
              ),
              child: new Row(
                children: <Widget>[
                  new Text(
                    'Rating ',
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  new StarRating(
                    rating: _rating
                  ),
                ],
              ),
            ),
            new ButtonTheme.bar( // make buttons use the appropriate styles for cards
              child: new ButtonBar(
                children: <Widget>[
                  new FlatButton(
                    child: new Text(
                      'Direction'.toUpperCase()
                    ),
                    onPressed: (){
                      // services.launchMapByGeo(_geo);
                      services.launchMapByAddress(_placeAddress);
                    },
                  ),
                  // new FlatButton(
                  //   child: const Text('View More'),
                  //   onPressed: () { /* ... */ },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget placeInfoBoxes(places){
    return new Column(
      children: <Widget>[
        new ListView.builder(
          shrinkWrap: true,
          physics: new NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index){
            return placeInfoBox(places[index]);
          },
          itemCount: places.length,
        )
      ],
    );
  }

  // display a circle indicator 
  Widget spinner() {
    return new Container(
      padding: const EdgeInsets.all(32.0),
      child: const Center(
        child: const CircularProgressIndicator(),
      ),
    );
  }  

  // text with padding inside a container, default padding 32.0
  Widget textWithPadding(String content , [double padding = 32.0]){
    return new Container(
      padding: new EdgeInsets.all(padding),
      child: new Text(content)
    );
  }

  // dropdown list
  Widget dropdownList(List<DropdownList> list, String defaultValue, [Function handler, String label = 'Select']){
    return new Container(
      margin: const EdgeInsets.only(left : 32.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            label,
          ),
          new DropdownButton(
            value: defaultValue,
            onChanged: (newValue){
              if(handler != null){
                handler(newValue);
              }
            },
            items: list.map(
              (DropdownList item){
                return new DropdownMenuItem(
                  value: item.value,
                  child: new Text(
                    item.title,
                    style: new TextStyle(
                      color: Colors.black,
                    ),
                  ),
                );
              }
            ).toList(),
          ),
        ],
      ),
    );
  }

  // place type selection dropdown list
  Widget typeDropdownList(String placeDefaultValue, [Function handler]){

    DropdownList dropdown = new DropdownList('', '');

    List<DropdownList> placeTypes = dropdown.placeTypeDropdownList();

    return dropdownList(placeTypes,placeDefaultValue,handler,'Type');
  }

  // radius value selection dropdown list
  Widget radiusDropdownList(String radiusDefaultValue, [Function handler]){

    DropdownList dropdown = new DropdownList('', '');

    List<DropdownList> placeTypes = dropdown.radiusDropdownList();

    return dropdownList(placeTypes,radiusDefaultValue,handler,'Radius');
  }

  Widget switchWithText(bool defaultValue, [String label = 'Switch', Function handler]){
    return new Container(
      margin: const EdgeInsets.only(left : 32.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            label,
          ),
          new Switch(
            value: defaultValue,
            onChanged: (newValue){
              if(handler != null){
                handler(newValue);
              }
            },
          )
        ],
      ),
    );
  }
}

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;

  StarRating({this.starCount = 5, this.rating = .0, this.onRatingChanged, this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: Theme.of(context).buttonColor,
      );
    }
    else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: color ?? Theme.of(context).primaryColor,
      );
    }
    return new InkResponse(
      onTap: onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(children: new List.generate(starCount, (index) => buildStar(context, index)));
  }
}