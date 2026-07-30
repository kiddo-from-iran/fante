dynamic extractBusNumber(String? input) {
  if (input == null || input.isEmpty) return null;
  
  try {
    // Try to match "Bus X" pattern first
    final busRegex = RegExp(r'Bus\s+([0-9\-]+)');
    final busMatch = busRegex.firstMatch(input);
    if (busMatch != null) {
      return busMatch.group(1)!;
    }
    
    // If no "Bus" pattern, try to extract just numbers
    final numberRegex = RegExp(r'([0-9]+)');
    final numberMatch = numberRegex.firstMatch(input);
    if (numberMatch != null) {
      return numberMatch.group(1)!;
    }
    
    // If no numbers found, return the original input
    return input;
  } catch (e) {
    // If any error occurs, return the original input
    return input;
  }
}

String convertTimeRange(List<String> timeList) {
  if (timeList.length != 2) return 'Invalid time range';

  // Extract hours and minutes, remove leading zeros
  var startTime = timeList[0];
  var endTime = timeList[1];

  var startParts = startTime.split(':');
  var endParts = endTime.split(':');

  var startHour = int.parse(startParts[0]).toString();
  var startMin = startParts[1];
  var endHour = int.parse(endParts[0]).toString();
  var endMin = endParts[1];

  // Combine with Persian "تا" (meaning "to")
  return '$startHour:$startMin تا $endHour:$endMin';
}
