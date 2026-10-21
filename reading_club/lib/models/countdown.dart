sealed class Countdown {
  const Countdown();
}

final class Upcoming extends Countdown {
  final Duration remaining;

  const Upcoming(this.remaining);
}

final class Started extends Countdown {
  final Duration elapsed;

  const Started(this.elapsed);
}

final class Ended extends Countdown {
  const Ended();
}

Countdown getCountdown(DateTime meetingDate, {DateTime? now}) {
  final currentTime = now ?? DateTime.now();

  if (currentTime.isBefore(meetingDate)) {
    return Upcoming(meetingDate.difference(currentTime));
  }

  final elapsed = currentTime.difference(meetingDate);

  if (elapsed < const Duration(hours: 1)) {
    return Started(elapsed);
  }

  return const Ended();
}

String countdownLabel(Countdown countdown) {
  return switch (countdown) {
    Upcoming(:final remaining) => 'Starts in ${_formatRemaining(remaining)}',
    Started(:final elapsed) => 'Started ${_formatRemaining(elapsed)} ago',
    Ended() => 'Ended',
  };
}

String _formatRemaining(Duration duration) {
  final days = duration.inDays;
  final hours = duration.inHours % 24;
  final minutes = duration.inMinutes % 60;
  final seconds = duration.inSeconds % 60;

  final time =
      '${hours.toString().padLeft(2, '0')}:'
      '${minutes.toString().padLeft(2, '0')}:'
      '${seconds.toString().padLeft(2, '0')}';

  if (days > 0) {
    return '$days days, $time';
  }

  return '${duration.inHours.toString().padLeft(2, '0')}:'
      '${minutes.toString().padLeft(2, '0')}:'
      '${seconds.toString().padLeft(2, '0')}';
}
