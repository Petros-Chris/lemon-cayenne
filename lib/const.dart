import 'package:shared_preferences/shared_preferences.dart';

var username = "";
int highestScore = 0;

var renderViewVal = "full";

List<String> renderView = ['full', 'bust', 'face'];
String url = "";
String difficulty = "Easy";
var renderTypeVal = "default";
final List<String> rendertype = [
  'archer',
  'bitzel',
  'cheering',
  'cowering',
  'criss_cross',
  'crouching',
  'crossed',
  'dead',
  'default',
  'dungeons',
  'facepalm',
  'head',
  'isometric',
  'kicking',
  'lunging',
  'marching',
  'mojavatar',
  'pixel',
  'pointing',
  'reading',
  'relaxing',
  'sleeping',
  'ultimate',
  'trudging',
  'walking',
];

void saveRenderView() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('render_view_val', renderViewVal);
}

void saveRenderType() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('render_type_val', renderTypeVal);
}

void stopIncorrectViews() {
  switch (renderTypeVal) {
    case 'mojavatar':
      {
        if (renderViewVal == 'face') {
          renderViewVal = 'bust';
          saveRenderView();
        }

        renderView = ['full', 'bust'];

        break;
      }
    case 'head':
      {
        if (renderViewVal != 'full') {
          renderViewVal = 'full';
          saveRenderView();
        }
        renderView = ['full'];
        break;
      }
    default:
      {
        renderView = ['full', 'bust', 'face'];
      }
  }
}
