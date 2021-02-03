class SliderModel {
  String _imagePath;
  String _title;
  String _description;

  SliderModel({String imagePath, String title, String description}) {
    this._imagePath = imagePath;
    this._title = title;
    this._description = title;
  }

  String get description => _description;

  setdescription(String value) {
    _description = value;
  }

  String get title => _title;

  settitle(String value) {
    _title = value;
  }

  String get imagePath => _imagePath;

  setimagePath(String value) {
    _imagePath = value;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = new List<SliderModel>();

  SliderModel sliderModel = new SliderModel();

  sliderModel.setimagePath("assets/images/localisationwalk.png");
  sliderModel.settitle("Exploration");
  sliderModel.setdescription(
      "Visualisez les alertes routières sur une carte en temps réel.");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  sliderModel.setimagePath("assets/images/mapwalk.png");
  sliderModel.settitle("Alertes");
  sliderModel.setdescription(
      "Signalez facilement et en un clic les alerte au prêt de vous.");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  sliderModel.setimagePath("assets/images/notifwalk.png");
  sliderModel.settitle("Notifications");
  sliderModel.setdescription(
      "Recevez en temp réel des notifications visuelles et sonores.");
  slides.add(sliderModel);

  sliderModel = new SliderModel();
  return slides;
}