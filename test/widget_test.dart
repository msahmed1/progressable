import 'package:exercise_journal/src/blocs/format_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
      'Given time in seconds When formatTime is called then Time returns only seconds',
      () async {
    //Arrange
    final formatTime = FormatTime();
    const int timeInSeconds = 1;
    //Act
    final String formattedTime = formatTime.displayTime(timeInSeconds);
    //Assert
    expect(formattedTime, '1secs');
  });

  test(
      'Given time in minutes When formatTime is called Then time returns only minutes',
      () async {
    //Arrange
    final formatTime = FormatTime();
    const int timeInSeconds = 60;
    //Act
    final String formattedTime = formatTime.displayTime(timeInSeconds);
    //Assert
    expect(formattedTime, '1mins');
  });

  test(
      'Given time in hours When formatTime is called Then time returns only hours',
      () async {
    //Arrange
    final formatTime = FormatTime();
    const int timeInSeconds = 3600;
    //Act
    final String formattedTime = formatTime.displayTime(timeInSeconds);
    //Assert
    expect(formattedTime, '1hrs');
  });

  test(
      'Given time in minutes and seconds When formatTime is called Then time returns only minutes and seconds',
      () async {
    //Arrange
    final formatTime = FormatTime();
    const int timeInSeconds = 61;
    //Act
    final String formattedTime = formatTime.displayTime(timeInSeconds);
    //Assert
    expect(formattedTime, '1mins:1secs');
  });

  test(
      'Given time in minutes and seconds When formatTime is called Then time returns only minutes and seconds',
      () async {
    //Arrange
    final formatTime = FormatTime();
    const int timeInSeconds = 1019;
    //Act
    final String formattedTime = formatTime.displayTime(timeInSeconds);
    //Assert
    expect(formattedTime, '16mins:59secs');
  });

  test(
      'Given time in hours and minutes When formatTime is called Then time returns only hours and minutes',
      () async {
    //Arrange
    final formatTime = FormatTime();
    const int timeInSeconds = 3660;
    //Act
    final String formattedTime = formatTime.displayTime(timeInSeconds);
    //Assert
    expect(formattedTime, '1hrs:1mins');
  });

  test(
      'Given time in hours and seconds When formatTime is called Then time returns only hours and seconds',
      () async {
    //Arrange
    final formatTime = FormatTime();
    const int timeInSeconds = 3601;
    //Act
    final String formattedTime = formatTime.displayTime(timeInSeconds);
    //Assert
    expect(formattedTime, '1hrs:1secs');
  });

  test(
      'Given time in hours, minutes and seconds When formatTime is called Then time returns only hours, minutes and seconds',
      () async {
    //Arrange
    final formatTime = FormatTime();
    const int timeInSeconds = 3661;
    //Act
    final String formattedTime = formatTime.displayTime(timeInSeconds);
    //Assert
    expect(formattedTime, "1h1'1''");
  });
}
