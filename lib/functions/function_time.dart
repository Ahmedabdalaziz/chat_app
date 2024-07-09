String formatTime(DateTime dateTime) {
  int hour = dateTime.hour % 12;
  hour = hour == 0 ? 12 : hour;
  String period = dateTime.hour >= 12 ? 'PM' : 'AM';
  return '${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} '
      '$period';
}
