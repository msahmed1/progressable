class FormatTime {
  String displayTime(int time) {
    final int formattedHour = time ~/ 3600;
    final int formattedMinute = (time - formattedHour * 3600) ~/ 60;
    final int formattedSeconds =
        time - ((formattedHour * 60 * 60) + (formattedMinute * 60));
    String formattedTime = '';

    if (formattedHour == 0 && formattedMinute == 0) {
      if (formattedSeconds == 1) {
        formattedTime = '${formattedSeconds}sec';
      } else {
        formattedTime = '${formattedSeconds}secs';
      }
    } else if (formattedHour == 0 && formattedSeconds == 0) {
      if (formattedMinute == 1) {
        formattedTime = '${formattedMinute}min';
      } else {
        formattedTime = '${formattedMinute}mins';
      }
    } else if (formattedMinute == 0 && formattedSeconds == 0) {
      if (formattedHour == 1) {
        formattedTime = '${formattedHour}hr';
      } else {
        formattedTime = '${formattedHour}hrs';
      }
    } else if (formattedHour == 0) {
      formattedTime = '${formattedMinute}m:${formattedSeconds}s';
    } else if (formattedSeconds == 0) {
      if (formattedHour == 1) {
        formattedTime = '${formattedHour}hr:${formattedMinute}m';
      } else {
        formattedTime = '${formattedHour}hrs:${formattedMinute}m';
      }
    } else if (formattedMinute == 0) {
      if (formattedHour == 1) {
        formattedTime = '${formattedHour}hr:${formattedSeconds}s';
      } else {
        formattedTime = '${formattedHour}hrs:${formattedSeconds}s';
      }
    } else {
      formattedTime = "${formattedHour}h$formattedMinute'$formattedSeconds''";
    }

    return formattedTime;
  }

  List<int> formattedTime(int time) {
    final List<int> timeArray = <int>[];

    final int formattedHour = time ~/ 3600;
    timeArray.add(formattedHour);

    final int formattedMinute = (time - formattedHour * 3600) ~/ 60;
    timeArray.add(formattedMinute);

    final int formattedSeconds =
        time - ((formattedHour * 60 * 60) + (formattedMinute * 60));
    timeArray.add(formattedSeconds);

    return timeArray;
  }
}
